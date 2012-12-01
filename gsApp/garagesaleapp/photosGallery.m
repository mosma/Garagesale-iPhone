//
//  photosGallery.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "photosGallery.h"
#import "Tile.h"
#import <QuartzCore/QuartzCore.h>

#define kWidthPaddingInImages 10
#define kHeightPaddingInImages 10


@implementation photosGallery

@synthesize nsMutArrayPicsProduct;
@synthesize nsMutArrayNames;
@synthesize scrollView;
@synthesize buttonAddPics;
@synthesize buttonSaveProduct;

@synthesize widthPaddingInImages;
@synthesize heightPaddingInImages;


-(id)init{
    widthPaddingInImages = kWidthPaddingInImages;
    heightPaddingInImages = kHeightPaddingInImages;
    
    nsMutArrayPhotosDelegate = [[NSMutableArray alloc] init];
    
    imageWidth_ = 70.0f;
    imageHeight_ = 70.0f;
    
    [self setNsMutArrayPicsProduct:[[NSMutableArray alloc] init]];
    [self setNsMutArrayNames:[[NSMutableArray alloc] init]];


    
    
    
    
    return self;
}



- (void)deletePicsAtGallery:(UILongPressGestureRecognizer *)sender {
    
    if (buttonSaveProduct.enabled) {

    
   // if (sender.state == UIGestureRecognizerStateBegan) {
        [scrollView setUserInteractionEnabled:NO];
 
        UIImageView *imageViewDelete      = (UIImageView *)sender.view;
        
        
        [imageViewDelete setHidden:YES];
        
        
        UIImageView *imageView      = (UIImageView *)imageViewDelete.superview;

        
        
        //Remove imgViewDelete
        //        for (UIView *subview in [imageView subviews])
        //            if (subview.tag == 455)
        //                [subview removeFromSuperview];

        
        imageView.image = nil;
        
        UIImageView * animation = [[UIImageView alloc] init];
        
        [animation setFrame:CGRectMake(10,10, 40, 40)];
        
        
        
        
        animation.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed: @"iconEliminateItem1.png"],
                                     [UIImage imageNamed: @"iconEliminateItem2.png"],
                                     [UIImage imageNamed: @"iconEliminateItem3.png"],
                                     [UIImage imageNamed: @"iconEliminateItem4.png"]
                                     ,nil];
        [animation setAnimationRepeatCount:1];
        [animation setAnimationDuration:0.35];
        [animation startAnimating];
        [imageView addSubview:animation];
        [animation bringSubviewToFront:imageView];
        
        [UIView animateWithDuration:0.75 animations: ^{
            
            


            
            
            [self reconfigureImagesAfterRemoving:imageView];
        } completion:^(BOOL finished){
            
            NSArray *imageViews         = [scrollView subviews];
            int indexOfRemovedImageView = [imageViews indexOfObject:imageView];
            
            [imageView removeFromSuperview];
            
            if ([nsMutArrayPicsProduct count] == [nsMutArrayNames count])
                [nsMutArrayNames removeObjectAtIndex:indexOfRemovedImageView];
            
            
            [nsMutArrayPicsProduct removeObjectAtIndex:indexOfRemovedImageView];


            
    //        [self.delegate removedImageAtIndex:indexOfRemovedImageView];
            //            if ([nsMutArrayPicsProduct count]==0) {
            //                [self showNoPhotoAdded];
            //            }
        }];
        
        if ([nsMutArrayPicsProduct count] < 11)
            buttonAddPics.enabled = YES;
    }

    if (sender.state == UIGestureRecognizerStateEnded ||
        sender.state == UIGestureRecognizerStateCancelled ||
        sender.state == UIGestureRecognizerStateFailed)
        [scrollView setUserInteractionEnabled:YES];

        
        
  //  }
    
}

-(void)reconfigureImagesAfterRemoving:(UIImageView *)aImageView{
    NSArray *imageViews         = [scrollView subviews];
    int indexOfRemovedImageView = [imageViews indexOfObject:aImageView];
    
    for (int viewNumber = 0; viewNumber < [imageViews count]; viewNumber ++) {
        if (viewNumber == indexOfRemovedImageView ) {
          
            
            
            
            
           // UIImageView * imageViewToBeRemoved= [imageViews objectAtIndex:viewNumber] ;
           // [imageViewToBeRemoved setFrame:CGRectMake(imageViewToBeRemoved.frame.size.width/2+imageViewToBeRemoved.frame.origin.x,scrollView.frame.size.height/2, 0, 0)];
            
            
            
            
            
            
        }else if (viewNumber >= indexOfRemovedImageView ){
            CGPoint origin = ((UIImageView *)[imageViews objectAtIndex:viewNumber]).frame.origin;
            origin.x = origin.x - self.widthPaddingInImages - imageWidth_;
            origin.y = self.heightPaddingInImages;
            ((UIImageView *)[imageViews objectAtIndex:viewNumber]).frame = CGRectMake(origin.x, origin.y, imageWidth_, imageHeight_);
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
        }
    }

    
    //Reposition scrollViewPicsProduct to right
    if ([nsMutArrayPicsProduct count] < 4)
        [scrollView setFrame:CGRectMake((173/([nsMutArrayPicsProduct count]-1)) + self.widthPaddingInImages, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height)];
    
    CGSize size = scrollView.contentSize;
    size.width = size.width - imageWidth_ -self.widthPaddingInImages;
    scrollView.contentSize = size;
}


-(void)addImageToScrollView:(UIImage *)aImage photoReturn:(PhotoReturn *)photoReturn product:(Product *)product{
    
            UIImage     *imgDelete      = [UIImage imageNamed:@"iconDeletePicsAtGalleryProdAcc.png"];
            UIImageView *imgViewDelete  = [[UIImageView alloc] initWithImage:imgDelete];
            [imgViewDelete setFrame:CGRectMake(-5, -5, 25, 25)];
            //[uplImageDelegate.imageView setUserInteractionEnabled:YES];
            //[uplImageDelegate.imageView setExclusiveTouch:YES];
            [imgViewDelete setUserInteractionEnabled:YES];
    [imgViewDelete setMultipleTouchEnabled:YES];
    
    
    
   UIImageView *picViewAtGallery = [[UIImageView alloc] initWithImage:aImage];
    
    
    [picViewAtGallery addSubview:imgViewDelete];
    
    int newIndex = [nsMutArrayPicsProduct count];
    [nsMutArrayPicsProduct insertObject:picViewAtGallery atIndex:newIndex];
    [scrollView insertSubview:picViewAtGallery atIndex:newIndex];

    picViewAtGallery.frame = CGRectMake(scrollView.contentSize.width+7 ,
                                        self.heightPaddingInImages, imageWidth_, imageHeight_);

    if (photoReturn != nil)
        [picViewAtGallery setUserInteractionEnabled:YES];
    
    UploadImageDelegate *uplImageDelegate = [[UploadImageDelegate alloc] init];
    [nsMutArrayPhotosDelegate addObject:uplImageDelegate];
    [uplImageDelegate setImageView:picViewAtGallery];
    [uplImageDelegate setButtonSaveProduct:buttonSaveProduct];
    
    if (photoReturn != nil){
        [uplImageDelegate setPhotoReturn:photoReturn];
    
        [nsMutArrayNames insertObject:[uplImageDelegate.photoReturn valueForKey:@"name"] atIndex:newIndex];

    }
    
    UITapGestureRecognizer * deleteGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(deletePicsAtGallery:)];
    [deleteGesture addTarget:uplImageDelegate action:@selector(deletePhoto)];
    [deleteGesture setNumberOfTapsRequired:1];


    UITapGestureRecognizer *moveLeftGesture = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(animePicsGallery:)];
    [moveLeftGesture setNumberOfTapsRequired:1];

    [imgViewDelete addGestureRecognizer:deleteGesture];
    [uplImageDelegate.imageView addGestureRecognizer:moveLeftGesture];
    
    //[self createTiles:uplImageDelegate.imageView index:([nsMutArrayPicsProduct count]-1)];

    CGSize size = scrollView.contentSize;
    size.width = size.width + imageWidth_ + self.widthPaddingInImages;
    scrollView.contentSize = size;
    
    //Scrolling to show last ImageView add in scrollViewPicsProduct at right side of gallery
    [scrollView setContentOffset:CGPointMake(picViewAtGallery.frame.origin.x-190, scrollView.contentOffset.y) animated:YES];
    
    //Scrolling to show last ImageView add in scrollViewPicsProduct at Left side of gallery
    //[scrollViewPicsProduct setContentOffset:CGPointMake(0, scrollViewPicsProduct.contentOffset.y) animated:YES];
    
    if(photoReturn == nil && product != nil)
        [uplImageDelegate uploadPhotos:nsMutArrayPicsProduct idProduct:[product.id intValue]];
    else if (product == nil)
        [uplImageDelegate uploadPhotos:nsMutArrayPicsProduct idProduct:-1];
}

-(void)animePicsGallery:(UITapGestureRecognizer *)sender{
    @try {
     UIImageView *imageView      = (UIImageView *)sender.view;
     
     //Remove imgViewDelete
     //        for (UIView *subview in [imageView subviews])
     //            if (subview.tag == 455)
     //                [subview removeFromSuperview];
     
     NSArray *imageViews         = [scrollView subviews];
     int indexOfImageAtScroll_right = [imageViews indexOfObject:imageView];
     int indexOfImageAtScroll_left = [imageViews indexOfObject:imageView]-1;
        
    for (int x = 0; x < [nsMutArrayPhotosDelegate count]; x++)// {
        if ([[(UploadImageDelegate *)[nsMutArrayPhotosDelegate objectAtIndex:x] photoReturn] valueForKey:@"name"] == @"")
            [nsMutArrayPhotosDelegate removeObjectAtIndex:x];
    
    if ([nsMutArrayNames count] < [nsMutArrayPicsProduct count])
        for (int x = 0; x <= [nsMutArrayPicsProduct count]; x++)
            if (x >= [nsMutArrayNames count] && [nsMutArrayNames count] != [nsMutArrayPicsProduct count])
                [nsMutArrayNames insertObject:[[(UploadImageDelegate *)[nsMutArrayPhotosDelegate objectAtIndex:x] photoReturn] valueForKey:@"name"] atIndex:x];

        UIImageView *leftImgV = [[scrollView subviews] objectAtIndex:indexOfImageAtScroll_left];
        UIImageView *rightImgV = [[scrollView subviews] objectAtIndex:indexOfImageAtScroll_right];
    
        CGRect right = rightImgV.frame;
        CGRect left = leftImgV.frame;

        [nsMutArrayPicsProduct replaceObjectAtIndex:indexOfImageAtScroll_left withObject:rightImgV];
        [nsMutArrayPicsProduct replaceObjectAtIndex:indexOfImageAtScroll_right withObject:leftImgV];

        
        NSString *rightS = [nsMutArrayNames objectAtIndex:indexOfImageAtScroll_right];
        NSString *leftS = [nsMutArrayNames objectAtIndex:indexOfImageAtScroll_left];
        
        [nsMutArrayNames replaceObjectAtIndex:indexOfImageAtScroll_left withObject:rightS];
        [nsMutArrayNames replaceObjectAtIndex:indexOfImageAtScroll_right withObject:leftS];

         
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:0.3];
         [UIView setAnimationDelegate:self];
         [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];
         [(UIImageView *)[scrollView.subviews objectAtIndex:indexOfImageAtScroll_right] setFrame:left];
         [(UIImageView *)[scrollView.subviews objectAtIndex:indexOfImageAtScroll_left] setFrame:right];
        
//        if (indexOfImageAtScroll_left == 0){
//            [[(UIImageView *)[scrollView.subviews objectAtIndex:indexOfImageAtScroll_left] layer] setBorderColor:[[UIColor grayColor] CGColor] ];
//            [[(UIImageView *)[scrollView.subviews objectAtIndex:indexOfImageAtScroll_right] layer] setBorderWidth:5.0 ];
//               
//            [[(UIImageView *)[scrollView.subviews objectAtIndex:indexOfImageAtScroll_left] layer] setBorderColor:[[UIColor clearColor] CGColor] ];
//            [[(UIImageView *)[scrollView.subviews objectAtIndex:indexOfImageAtScroll_left] layer] setBorderWidth:0 ];
//        
//        }
    
       
            
            
        
        
         [UIView commitAnimations];


         [scrollView insertSubview:leftImgV atIndex:indexOfImageAtScroll_right];
         [scrollView insertSubview:rightImgV atIndex:indexOfImageAtScroll_left];

    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }
    
   

    
}


@end
