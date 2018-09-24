//
//  PDFViewerController.m
//  ClickerServer
//
//  Created by Yuji on 2018/09/24.
//

#import "PDFViewerController.h"

@interface PDFViewerController ()

@end

@implementation PDFViewerController
{
    IBOutlet NSImageView*imageView;
    CGPDFDocumentRef currentPDF;
    NSUInteger pages;
    NSUInteger currentPage;
}
-(NSImage*)imageAtPageNumber:(NSUInteger)pageNumber
{
    NSImage*image=[NSImage imageWithSize:imageView.frame.size flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        CGPDFPageRef pdfPage = CGPDFDocumentGetPage (currentPDF, pageNumber);
        CGRect cropBox= CGPDFPageGetBoxRect(pdfPage, kCGPDFCropBox) ;
        CGRect mediaBox= CGPDFPageGetBoxRect(pdfPage, kCGPDFMediaBox) ;
        CGRect target=dstRect;
        float ratio=target.size.height/cropBox.size.height;
        float wratio=target.size.width/cropBox.size.width;
        if(wratio<ratio)ratio=wratio;
        float theight=ratio*cropBox.size.height;
        float twidth=ratio*cropBox.size.width;
        CGContextRef context=[NSGraphicsContext currentContext].CGContext;
        CGContextSetCMYKFillColor(context, 0, 0, 0, 0, 1);
        //    CGContextTranslateCTM(context, 0,target.size.height);
        //    CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, (target.size.width-twidth)/2,(target.size.height-theight)/2);
        CGContextFillRect(context,CGRectMake(0, 0, twidth, theight));
        CGContextScaleCTM(context, ratio, ratio);
        CGContextTranslateCTM(context, -(mediaBox.size.width-cropBox.size.width),-(mediaBox.size.height-cropBox.size.height));
        //    CGContextClipToRect(context, CGRectMake(0,0, cropBox.size.width, cropBox.size.height));
        CGContextDrawPDFPage (context, pdfPage);
        return YES;
    }];
    return image;
}
-(void)loadPDF:(NSURL*)fileURL
{
    self.window.representedURL=fileURL;
    self.window.title=fileURL.lastPathComponent;
    if(currentPDF){
        CGPDFDocumentRelease(currentPDF);
    }
    currentPDF=CGPDFDocumentCreateWithURL((__bridge CFURLRef)fileURL);
    pages=CGPDFDocumentGetNumberOfPages(currentPDF);
    currentPage=1;
    [self loadPage];
}-(void)loadPage
{
    NSImage*image=[self imageAtPageNumber:currentPage];
    [imageView setImage:image];
}
-(void)minusonepage
{
    currentPage--;
    if(currentPage<1){
        currentPage=1;
    }else{
        [self loadPage];
    }
}
-(void)plusonepage
{
    currentPage++;
    if(currentPage>pages){
        currentPage=pages;
    }else{
        [self loadPage];
    }
}
-(instancetype)init
{
    self=[super initWithWindowNibName:@"PDFViewerController"];
    return self;
}
- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
