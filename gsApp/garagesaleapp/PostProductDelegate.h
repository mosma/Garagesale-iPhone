//
//  PostProductDelegate
//  garagesaleapp
//
//  Created by Tarek Jradi on 31/10/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "GlobalFunctions.h"
#import "RestKit/RestKit.h"
#import <Foundation/Foundation.h>

@interface PostProductDelegate : NSObject <RKObjectLoaderDelegate, RKRequestDelegate> {
    BOOL isSaveProductDone;
    BOOL isSaveProductFail;
}

@property(unsafe_unretained, nonatomic) BOOL isSaveProductDone;
@property(unsafe_unretained, nonatomic) BOOL isSaveProductFail;

-(void)postProduct:(NSMutableDictionary *)productParams idProduct:(int)idProduct;
@end