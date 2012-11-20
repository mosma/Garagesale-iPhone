//
//  UploadImageDelegate.h
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
#import "PhotoReturn.h"

@interface UploadImageDelegate : NSObject <RKRequestDelegate/* , delegatedelete, delegatelongpress */> {
    UIImageView     *imageView;
    UIProgressView  *progressView;
    UIButton        *buttonSaveProduct;
    PhotoReturn     *photoReturn;
}


@property (nonatomic, retain)   UIImageView     *imageView;
@property (nonatomic, retain)   UIProgressView  *progressView;
@property (nonatomic, retain)   UIButton        *buttonSaveProduct;
@property (nonatomic, retain)   PhotoReturn     *photoReturn;



-(void)uploadPhotos:(NSMutableArray *)mutArrayPicsProduct idProduct:(int)idProduct;
-(void)deletePhoto;

@end
