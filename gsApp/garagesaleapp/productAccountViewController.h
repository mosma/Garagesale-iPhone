//
//  productAccountViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalFunctions.h"
#import "Product.h"
#import "BSKeyboardControls.h"
#import <RestKit/RKRequestSerialization.h>
#import "RestKit/RKJSONParserJSONKit.h"


@protocol PhotoScrollingViewDelegate
-(void)removedImageAtIndex:(int )aImageIndex;
@end

@interface productAccountViewController : UIViewController <UIActionSheetDelegate, 
                                                             UINavigationControllerDelegate, 
                                                             UIImagePickerControllerDelegate,
                                                             RKObjectLoaderDelegate,
                                                             RKRequestDelegate,
                                                             UIPickerViewDataSource, 
                                                             UIPickerViewDelegate, 
                                                             UITextFieldDelegate,
                                                             BSKeyboardControlsDelegate,
                                                             UIScrollViewDelegate> {
    //Outlets
    __unsafe_unretained IBOutlet UIScrollView   *scrollViewPicsProduct;
    __unsafe_unretained IBOutlet UITextField    *txtFieldTitle;
    __unsafe_unretained IBOutlet UITextField    *txtFieldValue;
    __unsafe_unretained IBOutlet UITextField    *txtFieldState;   
    __unsafe_unretained IBOutlet UITextField    *txtFieldCurrency;                                                              
    __weak IBOutlet UIScrollView    *scrollView;

                                                                 __weak IBOutlet UITextView *textViewDescription;
    //Others
    RKObjectManager         *RKObjManeger;
    NSMutableDictionary     *mutDictPicsProduct;
    NSMutableArray          *nsMutArrayPicsProduct;
    NSArray                 *nsArrayState;
    NSArray                 *nsArrayCurrency;
    UITapGestureRecognizer  *singleTap;
    float imageWidth_;
    float imageHeight_;
    bool isPostProduct;
}

@property (retain, nonatomic) id<PhotoScrollingViewDelegate>   delegate;
@property (retain, nonatomic) RKObjectManager                  *RKObjManeger;
@property (retain, nonatomic) NSMutableDictionary              *mutDictPicsProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollViewPicsProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldTitle;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldValue;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldState;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldCurrency;
@property (weak, nonatomic) IBOutlet UIScrollView   *scrollView;
@property (nonatomic) float widhtPaddingInImages;
@property (nonatomic) float heightPaddingInImages;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

-(void)loadAttributsToComponents;
-(IBAction)saveProduct;
-(IBAction)addProduct:(id)sender;

@end
