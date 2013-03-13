//
//  galleryScrollViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 11/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//
// see reference to solution scale and zoom image in :
// http://stackoverflow.com/questions/3448614/uiimageview-gestures-zoom-rotate-question

#import "galleryScrollViewController.h"
#import "ProductPhotos.h"
#import "Photo.h"
#import "GlobalFunctions.h"
#import "QuartzCore/QuartzCore.h"

@implementation galleryScrollViewController

//@synthesize productPhotos;
@synthesize imageView;
@synthesize galleryScrollView;
@synthesize urls;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [GlobalFunctions hideTabBar:self.tabBarController animated:YES];
    if (IS_IPHONE_5) {
        [self.view setFrame:CGRectMake(0, 20, 320, 548)];
        [self.galleryScrollView setFrame:CGRectMake(0, 0, 320, 548)];
    } else {
        [self.view setFrame:CGRectMake(0, 20, 320, 460)];
        [self.galleryScrollView setFrame:CGRectMake(0, 0, 320, 460)];
    }
    
    [self loadAttribsToComponents];
}

- (void)loadAttribsToComponents{
    self.navigationItem.leftBarButtonItem   = [GlobalFunctions getIconNavigationBar:
                                               @selector(backPage) viewContr:self
                                                                  imageNamed:@"btBackNav.png"
                                                                        rect:CGRectMake(0, 0, 40, 30)];

    imageView.contentMode   = UIViewContentModeScaleAspectFit;
    [galleryScrollView addSubview:imageView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [galleryScrollView addGestureRecognizer:doubleTap];
    
    galleryScrollView.minimumZoomScale = 0.6;
    galleryScrollView.maximumZoomScale = 3.0;

    UIRotationGestureRecognizer *rotationGesture =
    [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(handleRotate:)];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:rotationGesture];
    
    [galleryScrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    galleryScrollView.delegate              = self;
    galleryScrollView.clipsToBounds         = YES;
    
    [galleryScrollView setZoomScale:galleryScrollView.minimumZoomScale animated:NO];
    
    fotos = [[NSMutableDictionary alloc] init];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^(void) {
        Caminho *caminho    = (Caminho *)[[[urls objectAtIndex:index] caminho ] objectAtIndex:0];
        NSURL *url          = [NSURL URLWithString:[caminho original]];
        UIImage *image      = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        imageView.image     = image;
        
        for (int i = 0; i < [urls count]; i++) {
            Caminho *caminho    = (Caminho *)[[[urls objectAtIndex:i] caminho ] objectAtIndex:0];
            NSURL *url          = [NSURL URLWithString:[caminho original]];
            UIImage *image      = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            if (![[fotos allKeys] containsObject:[NSString stringWithFormat:@"%i", i]])
                [fotos setValue:image forKey:[NSString stringWithFormat:@"%i", i]];
        }
    });
    
    for (int i=0; i < [urls count]; i++) {
        CGRect rect;
        rect = i == 9 ? CGRectMake(10, 5, 10, 20) : CGRectMake(10, 5, 20, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(290, i*32+5, 27, 27)];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadImage:)];
        [singleTap setNumberOfTapsRequired:1];
        
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[NSString stringWithFormat:@"%i", i+1]];
        [label setFont:[UIFont fontWithName:@"Droid Sans" size:14.0]];
        [countView setUserInteractionEnabled:YES];
        [countView addGestureRecognizer:singleTap];
        if (i == 0){
            [countView setBackgroundColor:[UIColor grayColor]];
            [label setTextColor:[UIColor whiteColor]];
        }else{
            [countView setBackgroundColor:[UIColor whiteColor]];
            [label setTextColor:[UIColor blackColor]];
        }
        [countView.layer setCornerRadius:4];
        [countView.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [countView.layer setShadowOffset:CGSizeMake(1, 1)];
        [countView.layer setShadowOpacity:0.2];
        [countView setAlpha:0.8];
        [countView addSubview:label];
        [self.view addSubview:countView];
    }
}

-(void)loadImage:(UITapGestureRecognizer *)gesture{
    for (UIView *view in [self.view subviews]){
        [view setBackgroundColor:[UIColor whiteColor]];
        for (UIView *v in [view subviews])
            if ([v isKindOfClass:[UILabel class]])
                [(UILabel *)v setTextColor:[UIColor blackColor]];
    }
    
    int indx;
    for (UILabel *lab in [gesture.view subviews]){
        indx = [lab.text intValue]-1;
        [lab setTextColor:[UIColor whiteColor]];
    }
    
    if ([[fotos allKeys] containsObject:[NSString stringWithFormat:@"%i", indx]])
        imageView.image = (UIImage *)[fotos valueForKey:[NSString stringWithFormat:@"%i", indx]];
    else{
        Caminho *caminho    = (Caminho *)[[[urls objectAtIndex:indx] caminho ] objectAtIndex:0];
        NSURL *url          = [NSURL URLWithString:[caminho original]];
        UIImage *image      = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [fotos setValue:image forKey:[NSString stringWithFormat:@"%i", indx]];
        imageView.image     = image;
    }
    
    [gesture.view setBackgroundColor:[UIColor grayColor]];
    [galleryScrollView setBackgroundColor:[UIColor whiteColor]];
    [galleryScrollView setZoomScale:galleryScrollView.minimumZoomScale animated:YES];
}

- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan ||
       recognizer.state == UIGestureRecognizerStateChanged)
    {
        recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform,
                                                            recognizer.rotation);
        [recognizer setRotation:0];
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if(galleryScrollView.zoomScale > galleryScrollView.minimumZoomScale)
        [galleryScrollView setZoomScale:galleryScrollView.minimumZoomScale animated:YES];
    else
        [galleryScrollView setZoomScale:galleryScrollView.maximumZoomScale animated:YES];
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [GlobalFunctions showTabBar:self.navigationController.tabBarController];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    imageView.frame = [self centeredFrameForScrollView:scrollView andUIView:imageView];
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    CGSize boundsSize    = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
