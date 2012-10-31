//
//  UploadImageHelper.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 29/10/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//


#import <RestKit/RKRequestSerialization.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "GlobalFunctions.h"
#import "RestKit/RestKit.h"
#import <Foundation/Foundation.h>

@interface UploadImageHelper : NSObject <RKObjectLoaderDelegate, RKRequestDelegate, UIApplicationDelegate> {
    RKObjectManager *RKObjManeger;
    UIImageView     *imageView;
    
    
    
}

@property (retain) id delegate;


@property (nonatomic, retain)  UIImageView       *imageView;
@property (nonatomic, retain) RKObjectManager                   *RKObjManeger;

-(void)uploadPhotos:(int)index mutArrayPicsProduct:(NSMutableArray *)mutArrayPicsProduct;

@end
