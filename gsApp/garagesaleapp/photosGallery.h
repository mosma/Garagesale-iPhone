//
//  photosGallery.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadImageDelegate.h"

@interface photosGallery : NSObject {
    NSMutableArray              *nsMutArrayPicsProduct;
    NSMutableArray              *nsMutArrayNames;

    UIScrollView                *scrollView;
    NSMutableArray              *nsMutArrayPhotosDelegate;
    
    float imageWidth_;
    float imageHeight_;
    
    UIButton * buttonSaveProduct;
    UIButton * buttonAddPics;

}

@property (retain, nonatomic) NSMutableArray *nsMutArrayPicsProduct;
@property (retain, nonatomic) NSMutableArray *nsMutArrayNames;


@property (retain, nonatomic) UIScrollView *scrollView;

@property (retain, nonatomic) UIButton * buttonSaveProduct;
@property (retain, nonatomic) UIButton * buttonAddPics;

@property (nonatomic) float heightPaddingInImages;
@property (nonatomic) float widthPaddingInImages;

-(void)addImageToScrollView:(UIImage *)aImage
                photoReturn:(PhotoReturn *)photoReturn
                    product:(Product *)product
                  isPosting:(BOOL)isPosting;

@end
