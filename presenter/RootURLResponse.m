//
//  RootURLResponse.m
//  PicServer
//
//  Created by Yuji on 6/13/10.
//  Copyright 2010 Y. Tachikawa. All rights reserved.
//

#import "RootURLResponse.h"
#import "HTTPServer.h"
#import "ClickerServerAppDelegate.h"

@implementation RootURLResponse

//
// load
//
// Implementing the load method and invoking
// [HTTPResponseHandler registerHandler:self] causes HTTPResponseHandler
// to register this class in the list of registered HTTP response handlers.
//
+ (void)load
{
    [HTTPResponseHandler registerHandler:self];
}

//
// canHandleRequest:method:url:headerFields:
//
// Class method to determine if the response handler class can handle
// a given request.
//
// Parameters:
//    aRequest - the request
//    requestMethod - the request method
//    requestURL - the request URL
//    requestHeaderFields - the request headers
//
// returns YES (if the handler can handle the request), NO (otherwise)
//
+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest
		  method:(NSString *)requestMethod
		     url:(NSURL *)requestURL
	    headerFields:(NSDictionary *)requestHeaderFields
{
    return YES;
}

//
// startResponse
//
// Since this is a simple response, we handle it synchronously by sending
// everything at once.
//
- (void)startResponse
{
    NSData*data=[self dataToReturn];
    
    CFHTTPMessageRef response =
    CFHTTPMessageCreateResponse(
				kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
    CFHTTPMessageSetHeaderFieldValue(
				     response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
    CFHTTPMessageSetHeaderFieldValue(
				     response, (CFStringRef)@"Connection", (CFStringRef)@"close");
    CFHTTPMessageSetHeaderFieldValue(
				     response,
				     (CFStringRef)@"Content-Length",
				     (CFStringRef)[NSString stringWithFormat:@"%ld", [data length]]);
    CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);
    
    @try
    {
	[fileHandle writeData:(NSData *)headerData];
	[fileHandle writeData:data];
    }
    @catch (NSException *exception)
    {
	// Ignore the exception, it normally just means the client
	// closed the connection from the other end.
    }
    @finally
    {
	CFRelease(headerData);
	[server closeHandler:self];
    }
}

#pragma mark 
-(NSData*)dataToReturn
{
    NSString*x=[[url absoluteString] lastPathComponent];
    if([x isEqualToString:@"prev"]){
        [(ClickerServerAppDelegate*)[NSApp delegate] prev:self];
    }else if([x isEqualToString:@"next"]){
        [(ClickerServerAppDelegate*)[NSApp delegate] next:self];
    }
    return nil;
}
@end
