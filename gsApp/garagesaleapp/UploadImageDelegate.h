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
    UIScrollView    *scrollViewPicsProduct;
    UIActivityIndicatorView *activityIndicator;
    UIButton     *buttonSaveProduct;
    NSDictionary *photoReturn;
    
}


@property (nonatomic, retain)   UIImageView     *imageView;
@property (nonatomic, retain)   UIScrollView    *scrollViewPicsProduct;
@property (nonatomic, retain)   UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain)   UIButton     *buttonSaveProduct;

@property (nonatomic, retain)    NSDictionary *photoReturn;



-(void)uploadPhotos:(NSMutableArray *)mutArrayPicsProduct;
-(void)deletePhoto;

@end
