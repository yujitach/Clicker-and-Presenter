//
//  ClickerServerAppDelegate.h
//  ClickerServer
//
//  Created by Yuji on 7/1/10.
//  Copyright 2010 Y. Tachikawa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ClickerServerAppDelegate : NSObject 

@property (assign) IBOutlet NSWindow *window;

-(IBAction)prev:(id)sender;
-(IBAction)next:(id)sender;
@end
