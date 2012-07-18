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
#import <RestKit/RKRequestSerialization.h>
#import "RestKit/RKJSONParserJSONKit.h"

@interface productAccountViewController : UIViewController <UIActionSheetDelegate, 
                                                             UINavigationControllerDelegate, 
                                                             UIImagePickerControllerDelegate,
                                                             RKObjectLoaderDelegate,
                                                             RKRequestDelegate,
                                                             UIPickerViewDataSource, 
                                                             UIPickerViewDelegate, 
                                                             UITextFieldDelegate> {
    //Outlets
    __unsafe_unretained IBOutlet UIScrollView   *scrollViewPicsProduct;
    __unsafe_unretained IBOutlet UITextField    *txtFieldTitle;
    __unsafe_unretained IBOutlet UITextField    *txtFieldValue;
    __unsafe_unretained IBOutlet UITextField    *txtFieldState;   
    __unsafe_unretained IBOutlet UITextField    *txtFieldCurrency;                                                              


    //Others
    RKObjectManager         *RKObjManeger;
    NSMutableArray          *mutArrayPicsProduct;
    NSArray                 *nsArrayState;
    NSArray                 *nsArrayCurrency;
    UIPickerView            *pickerViewState;
    UIPickerView            *pickerViewCurrency;
}

@property (retain, nonatomic) RKObjectManager                   *RKObjManeger;
@property (retain, nonatomic) NSMutableArray                    *mutArrayPicsProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView  *scrollViewPicsProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldTitle;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldValue;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldState;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField  *txtFieldCurrency;

-(void)loadAttributsToComponents;
-(IBAction)saveProduct;

@end
