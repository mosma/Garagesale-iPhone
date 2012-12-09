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
#import "photosGallery.h"

@interface UploadImageDelegate : UIView <RKRequestDelegate/* , delegatedelete, delegatelongpress */> {
    
    /*
     Parameters instancied control
     from photosGallery at path ProductAccount
     */
    int idProduct;
    UIScrollView    *scrollView;
    UIImageView     *imageView;
    UIImage         *imagePic;
    UIButton        *buttonSaveProduct;
    NSMutableArray  *nsMutArrayPicsProduct;
    UITapGestureRecognizer *moveLeftGesture;
    UITapGestureRecognizer *refreshGesture;
    
    /*
     Total Bytes received from ResKit request Delegate.
     */
    int totalBytesWritten;
    int totalBytesExpectedToWrite;

    UIProgressView  *progressView;
    PhotoReturn     *photoReturn;
    NSTimer         *timerUpload;
}

@property (readwrite,assign)    int idProduct;
@property (nonatomic, retain)   UIImageView     *imageView;
@property (nonatomic, retain)   UIImage         *imagePic;
@property (nonatomic, retain)   UIProgressView  *progressView;
@property (nonatomic, retain)   UIButton        *buttonSaveProduct;
@property (nonatomic, retain)   PhotoReturn     *photoReturn;
@property (nonatomic, retain)   NSMutableArray  *nsMutArrayPicsProduct;
@property (nonatomic, retain)   UIScrollView    *scrollView;
@property (nonatomic, retain)   UITapGestureRecognizer *moveLeftGesture;

@property (readwrite,assign)    int totalBytesWritten;
@property (readwrite,assign)    int totalBytesExpectedToWrite;

-(void)uploadPhotos;
-(void)deletePhoto;

@end