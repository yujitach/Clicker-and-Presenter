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

@property (nonatomic, strong) IBOutlet Spinner *spinner;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet ClickerViewController *viewController;
@property (nonatomic, strong) NSString* urlString;

-(void)prev;
-(void)next;

@end

