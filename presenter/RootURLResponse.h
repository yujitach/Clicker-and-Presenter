//
//  RootURLResponse.h
//  PicServer
//
//  Created by Yuji on 6/13/10.
//  Copyright 2010 Y. Tachikawa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTTPResponseHandler.h"

@interface RootURLResponse : HTTPResponseHandler {

}
-(NSData*)dataToReturn; 
@end
