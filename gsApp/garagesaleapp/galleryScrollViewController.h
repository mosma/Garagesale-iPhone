//
//  galleryScrollViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 11/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface galleryScrollViewController : UIViewController <UIScrollViewDelegate> {
    NSMutableArray          *productPhotos;
    UIImageView             *imageView;
    
    IBOutlet UIScrollView   *galleryScrollView;
    IBOutlet UIPageControl  *PagContGallery;
}

@property (retain, nonatomic) NSMutableArray    *productPhotos;
@property (retain, nonatomic) UIImageView       *imageView;

@property (retain, nonatomic) IBOutlet UIScrollView  *galleryScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *PagContGallery;

- (IBAction)pageControlCliked;
- (void)loadAttribsToComponents;
- (void)setupProductMapping:(NSString *)localResource;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView;

@end
