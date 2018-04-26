//
//  Spinner.h
//  Clicker
//
//  Created by Yuji on 6/30/10.
//  Copyright 2010 Y. Tachikawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpinnerDelegate
-(void)found:(NSString*)us;
-(void)lost;
@end

@class Reachability;
@interface Spinner : UIViewController<NSNetServiceDelegate,NSNetServiceBrowserDelegate> {
    NSNetServiceBrowser*netServiceBrowser;
    NSNetService*netService;
    Reachability*reach;
    BOOL serverFound;
    id<SpinnerDelegate> delegate;
    NSString*ipString;
    int port;
}
@property (nonatomic,retain) Reachability*reach;
@property (nonatomic,retain) NSString*ipString;
-(id)initWithDelegate:(id<SpinnerDelegate>)d;
-(IBAction)openDocument:(id)sender;
@end
