//
//  ClickerServerAppDelegate.m
//  ClickerServer
//
//  Created by Yuji on 7/1/10.
//  Copyright 2010 Y. Tachikawa. All rights reserved.
//

#import "ClickerServerAppDelegate.h"
#import "HTTPServer.h"
#import "PDFViewerController.h"
#import <IOKit/pwr_mgt/IOPMLib.h>
@implementation ClickerServerAppDelegate
{
    NSWindow *window;
    NSNetService*netService;
    NSAppleScript*prev;
    NSAppleScript*next;
    PDFViewerController*_pvc;
    IOPMAssertionID assertionID;
    NSSound*haagerup1;
    NSSound*haagerup2;
}
@synthesize window;
-(PDFViewerController*)pvc
{
    if(!_pvc){
        _pvc=[[PDFViewerController alloc] init];
    }
    return _pvc;
}
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
    
    haagerup1=[[NSSound alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"haagerup-1" withExtension:@"mp3"] byReference:NO];
    haagerup2=[[NSSound alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"haagerup-2" withExtension:@"mp3"] byReference:NO];
}
-(IBAction)openDocument:(id)sender
{
    NSOpenPanel*panel=[NSOpenPanel openPanel];
    panel.allowedFileTypes=@[@"pdf"];
    [panel runModal];
    NSURL*url=panel.URLs[0];
    [self.pvc loadPDF:url];
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:url];
}
-(BOOL)application:(NSApplication *)sender openFile:(nonnull NSString *)filename
{
    NSURL*url=[NSURL fileURLWithPath:filename];
    [self.pvc loadPDF:url];
    return YES;
}
-(void)runScriptNamed:(NSString*)foo
{
    NSString*s=[[NSBundle mainBundle] pathForResource:foo ofType:@"txt"];
    NSString*command=[NSString stringWithFormat:@"osascript %@",s];
    dispatch_async(dispatch_get_global_queue(0, 0),^{system([command UTF8String]);});
}
-(void)activateTargetApp
{
    NSRunningApplication*app=[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.adobe.Reader"][0];
    [app activateWithOptions:NSApplicationActivateIgnoringOtherApps|NSApplicationActivateAllWindows];
}
-(void)assertActive
{
    IOPMAssertionDeclareUserActivity((CFStringRef)@"presenting a slide using Presenter.app", kIOPMUserActiveLocal, &assertionID);
}
-(IBAction)prev:(id)sender
{
//    dispatch_async(dispatch_get_main_queue(),^{[prev executeAndReturnError:nil];});
//    [self activateTargetApp];
//    [self runScriptNamed:@"prev"];
    [self assertActive];
    [self.pvc minusonepage];
}
-(IBAction)next:(id)sender
{
//    dispatch_async(dispatch_get_main_queue(),^{[next executeAndReturnError:nil];});
//    [self activateTargetApp];
//    [self runScriptNamed:@"next"];
    [self assertActive];
    [self.pvc plusonepage];
}
-(IBAction)haagerup1:(id)sender
{
    [haagerup1 play];
}
-(IBAction)haagerup2:(id)sender
{
    [haagerup2 play];
}
@end
