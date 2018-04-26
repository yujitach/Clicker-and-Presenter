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
    ClickerAppDelegate*__weak appDelegate;
}
-(IBAction)prev:(id)sender;
-(IBAction)next:(id)sender;
@property (nonatomic,weak) IBOutlet ClickerAppDelegate*appDelegate;
@end

