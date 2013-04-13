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
    __weak NSArray                 *urls;
    NSMutableDictionary     *fotos;
    int                     indice;
    
    __weak IBOutlet UIScrollView   *galleryScrollView;
}

@property (strong, nonatomic) UIImageView       *imageView;
@property (weak, nonatomic) NSArray           *urls;
@property (nonatomic)         int               indice;

@property (weak, nonatomic) IBOutlet UIScrollView  *galleryScrollView;

- (IBAction)pageControlCliked;
- (void)loadAttribsToComponents;
- (void)setupProductMapping:(NSString *)localResource;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView;
- (IBAction)dimissModal:(id)sender;
@end
