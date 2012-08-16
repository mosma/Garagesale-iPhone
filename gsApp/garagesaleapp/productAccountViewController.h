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
#import "QuartzCore/QuartzCore.h"
#import "MBProgressHUD.h"

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
                                                             UIScrollViewDelegate,
                                                             UITabBarControllerDelegate,
                                                             MBProgressHUDDelegate> {
    //Outlets
    __unsafe_unretained IBOutlet UIScrollView   *scrollViewPicsProduct;
    __unsafe_unretained IBOutlet UITextField    *txtFieldTitle;
    __unsafe_unretained IBOutlet UITextField    *txtFieldValue;
    __unsafe_unretained IBOutlet UITextField    *txtFieldState;   
    __unsafe_unretained IBOutlet UITextField    *txtFieldCurrency;                                                              
    __unsafe_unretained IBOutlet UIScrollView   *scrollView;
    __unsafe_unretained IBOutlet UITextView     *textViewDescription;
    __unsafe_unretained IBOutlet UILabel        *labelState;
    __unsafe_unretained IBOutlet UILabel        *labelTitle;
    __unsafe_unretained IBOutlet UILabel        *labelDescription;
    __unsafe_unretained IBOutlet UILabel        *labelValue;
    __unsafe_unretained IBOutlet UIView         *viewPicsControl;
                                                             
    //Others
    RKObjectManager         *RKObjManeger;
    NSMutableDictionary     *mutDictPicsProduct;
    NSMutableArray          *nsMutArrayPicsProduct;
    NSArray                 *nsArrayState;
    NSArray                 *nsArrayCurrency;
    UITapGestureRecognizer  *singleTap;
    UIView                  *shadowView;
    MBProgressHUD           *HUD;
    float imageWidth_;
    float imageHeight_;
    bool isPostProduct;
    BOOL isLoading;
}

@property (retain, nonatomic) id <PhotoScrollingViewDelegate>  delegate;

@property (retain, nonatomic) RKObjectManager                  *RKObjManeger;
@property (retain, nonatomic) NSMutableDictionary              *mutDictPicsProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollViewPicsProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldTitle;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldValue;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldState;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldCurrency;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView   *textViewDescription;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel      *labelState;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel      *labelTitle;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel      *labelDescription;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel      *labelValue;
@property (unsafe_unretained, nonatomic) IBOutlet UIView       *viewPicsControl;

@property (nonatomic) float widthPaddingInImages;
@property (nonatomic) float heightPaddingInImages;


-(void)loadAttributsToComponents;
-(IBAction)saveProduct;
-(IBAction)addProduct:(id)sender;
-(IBAction)isNumberKey:(UITextField *)textField;
-(IBAction)animationPicsControl;
-(IBAction)goBack:(id)sender;
-(IBAction)getPicsByCamera:(id)sender;
-(IBAction)getPicsByPhotosAlbum:(id)sender;
@end