//
//  photosGallery.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadImageDelegate.h"
#import "productAccountViewController.h"

@interface photosGallery : NSObject {
    NSMutableArray      *nsMutArrayPicsProduct;
    NSMutableArray      *nsMutArrayNames;
    UIScrollView        *scrollView;
    NSMutableArray      *nsMutArrayPhotosDelegate;
    float               imageWidth_;
    float               imageHeight_;

    productAccountViewController *prodAccount;
}

@property (retain, nonatomic) NSMutableArray *nsMutArrayPicsProduct;
@property (retain, nonatomic) NSMutableArray *nsMutArrayNames;
@property (retain, nonatomic) UIScrollView      *scrollView;

@property (nonatomic) float heightPaddingInImages;
@property (nonatomic) float widthPaddingInImages;

@property (retain, nonatomic) productAccountViewController *prodAccount;

-(void)addImageToScrollView:(UIImage *)aImage
                photoReturn:(PhotoReturn *)photoReturn
                    product:(Product *)product
               isFromPicker:(BOOL)isFromPicker;
-(void)releaseMemoryCache;

@end
