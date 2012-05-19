//
//  galleryScrollViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 11/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "RestKit/RKJSONParserJSONKit.h"

@interface galleryScrollViewController : UIViewController <RKObjectLoaderDelegate,UIScrollViewDelegate> {
    RKObjectManager         *RKObjManeger;
    NSMutableArray          *productPhotos;
    NSString                *idPessoa;     //from ProductDetail
    NSNumber                *idProduto;    //from ProductDetail
    UIImageView             *imageView;
    UIView                  *zoomView;
    IBOutlet UIScrollView   *galleryScrollView;
    IBOutlet UIPageControl  *PagContGallery;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (retain, nonatomic) RKObjectManager        *RKObjManeger;
@property (retain, nonatomic) NSMutableArray         *productPhotos;
@property (retain, nonatomic) NSString               *idPessoa;
@property (retain, nonatomic) NSNumber               *idProduto;
@property (retain, nonatomic) UIImageView            *imageView;
@property (retain, nonatomic) UIView                 *zoomView;
@property (retain, nonatomic) IBOutlet UIScrollView  *galleryScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *PagContGallery;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)pageControlCliked;
- (void)loadAttribsToComponents;
- (void)setupProductMapping:(NSString *)localResource;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView;

@end
