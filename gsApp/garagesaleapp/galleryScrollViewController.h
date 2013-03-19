//
//  galleryScrollViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 11/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface galleryScrollViewController : UIViewController <UIScrollViewDelegate> {
    UIImageView             *imageView;
    NSArray                 *urls;
    NSMutableDictionary     *fotos;
    int                     index;
    
    IBOutlet UIScrollView   *galleryScrollView;
}

@property (retain, nonatomic) UIImageView       *imageView;
@property (retain, nonatomic) NSArray           *urls;
@property (nonatomic)         int               index;

@property (retain, nonatomic) IBOutlet UIScrollView  *galleryScrollView;

- (IBAction)pageControlCliked;
- (void)loadAttribsToComponents;
- (void)setupProductMapping:(NSString *)localResource;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView;
- (IBAction)dimissModal:(id)sender;
@end
