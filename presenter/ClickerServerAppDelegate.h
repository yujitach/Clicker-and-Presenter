//
//  ClickerServerAppDelegate.h
//  ClickerServer
//
//  Created by Yuji on 7/1/10.
//  Copyright 2010 Y. Tachikawa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ClickerServerAppDelegate : NSObject {
    NSWindow *window;
    NSNetService*netService;
    NSAppleScript*prev;
    NSAppleScript*next;
}

@property (assign) IBOutlet NSWindow *window;

-(void)prev;
-(void)next;
@end
