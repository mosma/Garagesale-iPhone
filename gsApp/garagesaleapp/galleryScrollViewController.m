//
//  galleryScrollViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 11/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "galleryScrollViewController.h"
#import "ProductPhotos.h"
#import "Photo.h"
#import "GlobalFunctions.h"
#import "QuartzCore/QuartzCore.h"

@implementation galleryScrollViewController

@synthesize productPhotos;
@synthesize imageView;
@synthesize zoomView;
@synthesize galleryScrollView;
@synthesize PagContGallery;

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
    zoomView                    = [[UIView alloc] init];
    PagContGallery.hidden       = YES;
    int countPhotos = (int)[productPhotos count];
    self.navigationItem.leftBarButtonItem   = [GlobalFunctions getIconNavigationBar:
                                               @selector(backPage) viewContr:self imageNamed:@"btBackNav.png" rect:CGRectMake(0, 0, 40, 30)];

        //imageView               =[[UIImageView alloc] init];

    imageView.contentMode   = UIViewContentModeScaleAspectFit;
    [galleryScrollView addSubview:imageView];
    
    galleryScrollView.minimumZoomScale = 0.25;
    galleryScrollView.maximumZoomScale = 4.0;
    [galleryScrollView setZoomScale:galleryScrollView.minimumZoomScale];
         
    
    [galleryScrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
    galleryScrollView.pagingEnabled         = YES;
    galleryScrollView.delegate              = self;
    galleryScrollView.clipsToBounds         = YES;
    galleryScrollView.autoresizesSubviews   = YES;
    PagContGallery.numberOfPages        = countPhotos; 
    PagContGallery.hidden               = NO;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    PagContGallery.currentPage = galleryScrollView.contentOffset.x / self.view.frame.size.width;
//    NSOperationQueue *queue = [NSOperationQueue new];
//    UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] init];
//    [actInd startAnimating];
//    [actInd setColor:[UIColor grayColor]];
//    [actInd setCenter:CGPointMake(160+(320*PagContGallery.currentPage), 140)];
//    [galleryScrollView addSubview:actInd];
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
//                                        initWithTarget:self
//                                        selector:@selector(loadGalleryTop:)
//                                        object:PagContGallery];
//    [queue addOperation:operation];
}

-(void)loadGalleryTop:(UIPageControl *)pagContr{
    UIImage *image;
    /*copy pagCont.currentPage with NSString, we do
     this because pagCont is instable acconding fast
     or slow scroll*/
    NSString *pageCCopy = [NSString stringWithFormat:@"%i" , pagContr.currentPage];
    [NSThread detachNewThreadSelector:@selector(loadImageGalleryThumbs:) toTarget:self
                           withObject:pageCCopy];
}

- (void)loadImageGalleryThumbs:(NSString *)pagContr{
    @try {
        UIImage *image;
        CGRect rect;//             = imageView.frame;
        rect.size.width         = 320;
        rect.size.height        = 280;
        
        Caminho *caminho = (Caminho *)[[[productPhotos objectAtIndex:[pagContr intValue]] caminho ] objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:[caminho mobile]];
        
        image                   = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        imageView               = [[UIImageView alloc] initWithImage:image];
        rect.origin.x           = [pagContr intValue]*320;
        [imageView setFrame:rect];
        imageView.contentMode   = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [galleryScrollView addSubview:imageView];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

-(IBAction)pageControlCliked{
    CGPoint offset = CGPointMake(PagContGallery.currentPage * self.view.frame.size.width, 0);
    [galleryScrollView setContentOffset:offset animated:YES];
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
