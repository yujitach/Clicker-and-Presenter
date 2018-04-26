//
//  ClickerAppDelegate.h
//  Clicker
//
//  Created by Yuji on 6/30/10.
//  Copyright Y. Tachikawa 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spinner.h"

@class ClickerViewController;
@interface ClickerAppDelegate : NSObject <UIApplicationDelegate,SpinnerDelegate> {
    UIWindow *window;
    ClickerViewController *viewController;
    Spinner*spinner;
    NSString*urlString;
}

@property (nonatomic, retain) IBOutlet Spinner *spinner;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ClickerViewController *viewController;
@property (nonatomic, retain) NSString* urlString;

-(void)prev;
-(void)next;

@end

