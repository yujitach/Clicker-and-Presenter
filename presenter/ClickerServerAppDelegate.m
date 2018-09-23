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
    prev=[[NSAppleScript alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"prev" withExtension:@"txt"]
						error:NULL];
 //   [prev compileAndReturnError:nil];
    next=[[NSAppleScript alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"next" withExtension:@"txt"]
						error:NULL];
//    [next compileAndReturnError:nil];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application 
    HTTPServer*httpServer=[HTTPServer sharedHTTPServer];
    httpServer.port=721255981;
    [httpServer start];
    
    NSString *domain = @"local";
    NSString *protocol = @"_yujitach_clicker._udp";
    NSString *name = @"";
    int portNumber = (int)httpServer.port-123;
    
    netService = [[NSNetService alloc] initWithDomain:domain type:protocol name:name port: portNumber];	
    [netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [netService publish];
    [self loadAppleScripts];
}
-(void)runScriptNamed:(NSString*)foo
{
    NSString*s=[[NSBundle mainBundle] pathForResource:foo ofType:@"txt"];
    NSString*command=[NSString stringWithFormat:@"osascript %@",s];
    dispatch_async(dispatch_get_global_queue(0, 0),^{system([command UTF8String]);});
}
-(void)prev
{
//    dispatch_async(dispatch_get_main_queue(),^{[prev executeAndReturnError:nil];});
    [self runScriptNamed:@"prev"];
}
-(void)next
{
//    dispatch_async(dispatch_get_main_queue(),^{[next executeAndReturnError:nil];});
    [self runScriptNamed:@"next"];
}
@end
