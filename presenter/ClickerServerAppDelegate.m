//
//  ClickerServerAppDelegate.m
//  ClickerServer
//
//  Created by Yuji on 7/1/10.
//  Copyright 2010 Y. Tachikawa. All rights reserved.
//

#import "ClickerServerAppDelegate.h"
#import "HTTPServer.h"

@implementation ClickerServerAppDelegate

@synthesize window;

-(void)loadAppleScripts
{
    prev=[[NSAppleScript alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"prev" withExtension:@"applescript"]
						error:NULL];
    next=[[NSAppleScript alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"next" withExtension:@"applescript"]
						error:NULL];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application 
    HTTPServer*httpServer=[HTTPServer sharedHTTPServer];
    httpServer.port=721255981;
    [httpServer start];
    
    NSString *domain = @"local";
    NSString *protocol = @"_yujitach_clicker._udp";
    NSString *name = @"";
    int portNumber = httpServer.port-123;
    
    netService = [[NSNetService alloc] initWithDomain:domain type:protocol name:name port: portNumber];	
    [netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [netService publish];
    [self loadAppleScripts];
}
-(void)prev
{
    [prev executeAndReturnError:NULL];
}
-(void)next
{
    [next executeAndReturnError:NULL];
}
@end
