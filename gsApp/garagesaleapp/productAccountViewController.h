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
#import "ProductPhotos.h"
#import "BSKeyboardControls.h"
#import <RestKit/RKRequestSerialization.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "QuartzCore/QuartzCore.h"
#import "MBProgressHUD.h"
#import "JSON.h"

@interface productAccountViewController : MasterViewController <UIActionSheetDelegate, 
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
    __unsafe_unretained IBOutlet UIView         *viewPicsControl;
    __unsafe_unretained IBOutlet UIButton       *buttonAddPics;
    __weak IBOutlet UIButton *buttonSaveProduct;

    //Others
    RKObjectManager             *RKObjManeger;
                                                                 
    NSArray                     *nsArrayState;
    NSArray                     *nsArrayCurrency;
    UITapGestureRecognizer      *singleTap;
    UIView                      *shadowView;
    MBProgressHUD               *HUD;
    Product                     *product;
    UILabel                     *waiting;
                                                                 
    //Flags at Post
    bool isImagesProductPosted;
    int countPicsPost;
    __weak IBOutlet UIButton *buttonDeleteProduct;
}

@property (retain, nonatomic) RKObjectManager                  *RKObjManeger;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollViewPicsProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldTitle;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldValue;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldState;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldCurrency;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView   *textViewDescription;
@property (unsafe_unretained, nonatomic) IBOutlet UIView       *viewPicsControl;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton     *buttonAddPics;
@property (weak, nonatomic) IBOutlet UIButton *buttonSaveProduct;
@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteProduct;

@property (nonatomic)     bool isImagesProductPosted;
@property (retain, nonatomic) Product                          *product;


-(void)loadAttributsToComponents;
-(IBAction)saveProduct;
-(IBAction)addProduct:(id)sender;
-(IBAction)isNumberKey:(UITextField *)textField;
-(IBAction)animationPicsControl;
-(IBAction)goBack:(id)sender;
-(IBAction)getPicsByCamera:(id)sender;
-(IBAction)getPicsByPhotosAlbum:(id)sender;
-(IBAction)deleteProduct:(id)sender;
-(void)validateForm:(id)sender;
-(IBAction)deleteProduct:(id)sender;

@end
