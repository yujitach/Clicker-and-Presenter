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

@implementation ClickerServerAppDelegate
{
    NSWindow *window;
    NSNetService*netService;
    NSAppleScript*prev;
    NSAppleScript*next;
    PDFViewerController*_pvc;
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
-(IBAction)prev:(id)sender
{
//    dispatch_async(dispatch_get_main_queue(),^{[prev executeAndReturnError:nil];});
//    [self activateTargetApp];
//    [self runScriptNamed:@"prev"];
    [self.pvc minusonepage];
}
-(IBAction)next:(id)sender
{
//    dispatch_async(dispatch_get_main_queue(),^{[next executeAndReturnError:nil];});
//    [self activateTargetApp];
//    [self runScriptNamed:@"next"];
    [self.pvc plusonepage];
}
@end
