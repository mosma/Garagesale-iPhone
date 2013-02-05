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
#import "PDColoredProgressView.h"

@interface UploadImageDelegate : UIView <RKRequestDelegate/* , delegatedelete, delegatelongpress */> {
    
    /*
     Parameters instancied control
     from photosGallery at path ProductAccount
     */
    int idProduct;
    UIImageView     *imageView;
    UIImageView     *imageViewDelete;
    UIImage         *imagePic;
    NSMutableArray  *nsMutArrayPicsProduct;
    UITapGestureRecognizer *moveLeftGesture;
    UITapGestureRecognizer *refreshGesture;
    
    /*
     Total Bytes received from ResKit request Delegate.
     */
    int totalBytesWritten;
    int totalBytesExpectedToWrite;
    PDColoredProgressView  *progressView;
    PhotoReturn     *photoReturn;
    NSTimer         *timerUpload;
    
    productAccountViewController *prodAccount;
}

@property (readwrite,assign)    int idProduct;
@property (nonatomic, retain)   UIImageView     *imageView;
@property (nonatomic, retain)   UIImageView     *imageViewDelete;
@property (nonatomic, retain)   UIImage         *imagePic;
@property (nonatomic, retain)   PDColoredProgressView  *progressView;
@property (nonatomic, retain)   PhotoReturn     *photoReturn;
@property (nonatomic, retain)   NSMutableArray  *nsMutArrayPicsProduct;
@property (nonatomic, retain)   UIScrollView    *scrollView;
@property (nonatomic, retain)   UITapGestureRecognizer *moveLeftGesture;

@property (readwrite,assign)    int totalBytesWritten;
@property (readwrite,assign)    int totalBytesExpectedToWrite;

@property (retain, nonatomic) productAccountViewController *prodAccount;

-(void)uploadPhotos;
-(void)deletePhoto;
-(void)setTimmer;
@end