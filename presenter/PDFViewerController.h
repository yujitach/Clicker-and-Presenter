//
//  PDFViewerController.h
//  ClickerServer
//
//  Created by Yuji on 2018/09/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDFViewerController : NSWindowController
-(void)loadPDF:(NSURL*)url;
-(void)plusonepage;
-(void)minusonepage;
@end

NS_ASSUME_NONNULL_END
