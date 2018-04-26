//
//  ClickerViewController.h
//  Clicker
//
//  Created by Yuji on 6/30/10.
//  Copyright Y. Tachikawa 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClickerAppDelegate;
@interface ClickerViewController : UIViewController {
    ClickerAppDelegate*appDelegate;
}
-(IBAction)prev:(id)sender;
-(IBAction)next:(id)sender;
@property (nonatomic,assign) IBOutlet ClickerAppDelegate*appDelegate;
@end

