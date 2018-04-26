//
//  ClickerAppDelegate.m
//  Clicker
//
//  Created by Yuji on 6/30/10.
//  Copyright Y. Tachikawa 2010. All rights reserved.
//

#import "ClickerAppDelegate.h"
#import "ClickerViewController.h"
#import "Spinner.h"

@implementation ClickerAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize spinner,urlString;


#pragma mark -
#pragma mark Application lifecycle

-(void)lost
{
    NSLog(@"lost!");
    self.urlString=nil;
    spinner.modalPresentationStyle=UIModalTransitionStyleCoverVertical;
    [self.viewController presentViewController:spinner animated:NO completion:^{}];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
-(void)found:(NSString*)us;
{
    NSLog(@"found!");
    self.urlString=us;
    [viewController dismissViewControllerAnimated:NO completion:^{}];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [window setRootViewController:viewController];
    [window makeKeyAndVisible];
    spinner=[[Spinner alloc] initWithDelegate:self];
    [self lost];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [viewController dismissViewControllerAnimated:NO completion:^{}];
    self.spinner=nil;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


#pragma mark actions
-(void)prev;
{
    NSURL*url=[NSURL URLWithString:[urlString stringByAppendingString:@"prev"]];
    [NSData dataWithContentsOfURL:url];
}
-(void)next;
{
    NSURL*url=[NSURL URLWithString:[urlString stringByAppendingString:@"next"]];
    [NSData dataWithContentsOfURL:url];
}
@end
