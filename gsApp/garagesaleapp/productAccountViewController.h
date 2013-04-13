//
//  productAccountViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RKRequestSerialization.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "QuartzCore/QuartzCore.h"
#import "ProductPhotos.h"
#import "MBProgressHUD.h"
#import "Product.h"
#import "JSON.h"

@interface productAccountViewController : MasterViewController <UINavigationControllerDelegate, 
                                                                UIImagePickerControllerDelegate,
                                                                RKObjectLoaderDelegate,
                                                                RKRequestDelegate,
                                                                UIPickerViewDataSource, 
                                                                UIPickerViewDelegate,
                                                                UIScrollViewDelegate,
                                                                MBProgressHUDDelegate> {
    //Outlets
    __weak IBOutlet UIScrollView   *scrollViewPicsProduct;
    __weak IBOutlet UITextField    *txtFieldTitle;
    __weak IBOutlet UITextField    *txtFieldValue;
    __weak IBOutlet UITextField    *txtFieldState;   
    __weak IBOutlet UITextField    *txtFieldCurrency;                                                              
    __weak IBOutlet UIScrollView   *scrollView;
    __weak IBOutlet UITextView     *textViewDescription;
    __weak IBOutlet UIView         *viewPicsControl;
    __weak IBOutlet UIButton       *buttonAddPics;
    __weak IBOutlet UIButton                    *buttonSaveProduct;

    //Others
    RKObjectManager             *RKObjManeger;
                                                                 
    NSArray                     *nsArrayState;
    NSMutableArray              *nsArrayCurrency;
    UITapGestureRecognizer      *singleTap;
    UIView                      *shadowView;
    MBProgressHUD               *HUD;
    Product                     *product;
    UILabel                     *waiting;
                                                                 
    //Flags at Post
    bool                        isImagesProductPosted;
    int                         countPicsPost;
    __weak IBOutlet UIButton    *buttonDeleteProduct;
    int                         countUploaded;
}

@property (retain, nonatomic) RKObjectManager                  *RKObjManeger;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewPicsProduct;
@property (weak, nonatomic) IBOutlet UITextField  *txtFieldTitle;
@property (weak, nonatomic) IBOutlet UITextField  *txtFieldValue;
@property (weak, nonatomic) IBOutlet UITextField  *txtFieldState;
@property (weak, nonatomic) IBOutlet UITextField  *txtFieldCurrency;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView   *textViewDescription;
@property (weak, nonatomic) IBOutlet UIView       *viewPicsControl;
@property (weak, nonatomic) IBOutlet UIButton     *buttonAddPics;
@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteProduct;
@property (weak, nonatomic) IBOutlet UIButton *buttonSaveProduct;

@property (nonatomic)           bool      isImagesProductPosted;
@property (retain, nonatomic)   Product   *product;
@property (readwrite,assign)    int       countUploaded;

-(void)loadAttributsToComponents;
-(IBAction)saveProduct;
-(IBAction)addProduct:(id)sender;
-(IBAction)isNumberKey:(UITextField *)textField;
-(IBAction)animationPicsControl;
//-(IBAction)goBack:(id)sender;
-(IBAction)getPicsByCamera:(id)sender;
-(IBAction)getPicsByPhotosAlbum:(id)sender;
-(IBAction)deleteProduct:(id)sender;
-(void)validateForm:(id)sender;
-(IBAction)deleteProduct:(id)sender;

@end
