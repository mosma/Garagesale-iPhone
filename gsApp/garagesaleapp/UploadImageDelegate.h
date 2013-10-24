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
#import "productAccountViewController.h"
#import "GlobalFunctions.h"
#import "RestKit/RestKit.h"
#import "PhotoReturn.h"
#import "photosGallery.h"


@interface UploadImageDelegate : UIView <RKRequestDelegate/* , delegatedelete, delegatelongpress */> {
    
    /*
     Parameters instancied control
     from photosGallery at path ProductAccount
     */
    int                         idProduct;
    UIImageView                 *imageView;
    UIImageView                 *imageViewDelete;
    UIImage                     *imageUpload;
    NSMutableArray              *nsMutArrayPicsProduct;
    UITapGestureRecognizer      *moveLeftGesture;
    UITapGestureRecognizer      *refreshGesture;
    
    /*
     Total Bytes received from ResKit request Delegate.
     */
    int                         totalBytesW;
    int                         totalBytesExpectedToW;
    UIProgressView       *progressView;
    PhotoReturn                 *photoReturn;
    NSTimer                     *timerUpload;
    
    productAccountViewController *prodAccount;
}

@property (readwrite,assign)    int             idProduct;
@property (nonatomic, retain)   UIImageView     *imageView;
@property (nonatomic, retain)   UIImageView     *imageViewDelete;
@property (nonatomic, retain)   UIImage         *imageUpload;
@property (nonatomic, retain)   UIProgressView  *progressView;
@property (nonatomic, retain)   PhotoReturn     *photoReturn;
@property (nonatomic, retain)   NSMutableArray  *nsMutArrayPicsProduct;
@property (nonatomic, retain)   UIScrollView    *scrollView;
@property (nonatomic, retain)   UITapGestureRecognizer *moveLeftGesture;

@property (readwrite,assign)    int totalBytesW;
@property (readwrite,assign)    int totalBytesExpectedToW;

@property (retain, nonatomic) productAccountViewController *prodAccount;

-(void)uploadPhotos:(UITapGestureRecognizer *)tap;
-(void)deletePhoto;
-(void)setTimmer;
@end