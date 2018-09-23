//
//  Spinner.m
//  Clicker
//
//  Created by Yuji on 6/30/10.
//  Copyright 2010 Y. Tachikawa. All rights reserved.
//

#import "Spinner.h"
#import "Reachability.h"

#include <netinet/in.h>
#include <arpa/inet.h>

@implementation Spinner
@synthesize reach,ipString;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
-(id)initWithDelegate:(id<SpinnerDelegate>)d;
{
    if ((self = [super initWithNibName:@"Spinner" bundle:nil])) {
    delegate=d;
    serverFound=NO;
    netServiceBrowser = [[NSNetServiceBrowser alloc] init];
    netServiceBrowser.delegate = self;
    [netServiceBrowser searchForServicesOfType:@"_yujitach_clicker._udp" inDomain:@"local"];    
    }
    return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (void)dealloc {
    [netServiceBrowser stop];
    [netService stop];
}

#pragma mark Reachability Warning
- (void) reachabilityChanged: (NSNotification* )note
{
    NetworkStatus status=[self.reach currentReachabilityStatus];
    if(status==NotReachable){
    [delegate lost];
    self.reach=nil;
    }else if(status==ReachableViaWiFi){
    NSString*urlString=[NSString stringWithFormat:@"http://%@:%d/",ipString,port];
    [delegate found:urlString];     
    }
    
}

#pragma mark Bonjour
- (void)netServiceBrowser:(NSNetServiceBrowser *)nsb didFindService:(NSNetService *)service moreComing:(BOOL)moreDomainsComing
{
    serverFound=YES;
    netService=service;
    [netService setDelegate:self];
    [netService resolveWithTimeout:1.0f];
}
-(void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSData*data=[[netService addresses] objectAtIndex:0];
    struct sockaddr_in *socketAddress = (struct sockaddr_in *) [data bytes];
    self.ipString = [NSString stringWithFormat: @"%s", inet_ntoa(socketAddress->sin_addr)];
    port = ntohs(socketAddress->sin_port)+123;
    NSString*urlString=[NSString stringWithFormat:@"http://%@:%d/",ipString,port];
    [delegate found:urlString];     

/*    self.reach=[Reachability reachabilityWithAddress:socketAddress];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    [self.reach startNotifier];
 */
}
- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didRemoveService:(NSNetService*)service moreComing:(BOOL)moreComing
{
    self.reach=nil;
    [delegate lost];
}

-(IBAction)openDocument:(id)sender;
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sns.ias.edu/~yujitach/clicker"]];
}
@end
