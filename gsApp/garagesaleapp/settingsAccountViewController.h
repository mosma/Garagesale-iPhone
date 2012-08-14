//
//  settingsAccountViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "BSKeyboardControls.h"
#import "MBProgressHUD.h"
#import "RestKit/RestKit.h"
#import "RestKit/RKJSONParserJSONKit.h"
#import "Garage.h"
#import "Profile.h"

@interface settingsAccountViewController : UIViewController <UITextFieldDelegate, 
                                                             UITextViewDelegate, 
                                                             BSKeyboardControlsDelegate,
                                                             UIScrollViewDelegate, 
                                                             RKObjectLoaderDelegate,
                                                             MBProgressHUDDelegate> {
    
    //ViewNewPassword Labels                                                             
    __weak IBOutlet UILabel     *labelCurrentPassword;
    __weak IBOutlet UILabel     *labelNewPassword;
    __weak IBOutlet UILabel     *labelRepeatPassword;
    //ViewNewPassword TextFields                                                       
    __weak IBOutlet UITextField *txtFieldCurrentPassword;
    __weak IBOutlet UITextField *txtFieldNewPassword;
    __weak IBOutlet UITextField *txtFieldRepeatNewPassword;
                                                                 
    //ViewAddress Labels
    __weak IBOutlet UILabel *labelAddress;                         
    __weak IBOutlet UILabel *labelCity;
    __weak IBOutlet UILabel *labelDistrict;
    __weak IBOutlet UILabel *labelCountry;                                                            
    //ViewAddress TxtFields                                            
    __weak IBOutlet UITextField *txtFieldAddress;                                                       
    __weak IBOutlet UITextField *txtFieldCity;
    __weak IBOutlet UITextField *txtFieldDistrict;                                                            
    __weak IBOutlet UITextField *txtFieldCountry;
                                                                 
    //ViewAccount Labels                                                            
    __weak IBOutlet UILabel *labelGarageName;
    __weak IBOutlet UILabel *labelYourName;
    __weak IBOutlet UILabel *labelEmail;
    __weak IBOutlet UILabel *labelAbout;
    __weak IBOutlet UILabel *labelAnyLink;
    //ViewAccount TxtFields                                                             
    __weak IBOutlet UITextField   *txtFieldGarageName;
    __weak IBOutlet UITextField   *txtFieldYourName;
    __weak IBOutlet UITextField   *txtFieldEmail;
    __weak IBOutlet UITextView    *txtViewAbout;
    __weak IBOutlet UITextField   *txtFieldAnyLink;

    __weak IBOutlet UIScrollView  *scrollView;
                                                                 
    __weak IBOutlet UIImageView   *imageView;
    __weak IBOutlet UILabel       *garageName;
    __weak IBOutlet UILabel       *city;
    
    MBProgressHUD                 *HUD;
    RKObjectManager               *RKObjManeger;

                                                                 
}
//ViewPassword Labels
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelNewPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelRepeatPassword;
//ViewPassword TxtFields
@property (weak, nonatomic) IBOutlet UITextField *txtFieldCurrentPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldRepeatNewPassword;

//ViewAddress Labels
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelCity;
@property (weak, nonatomic) IBOutlet UILabel *labelDistrict;
@property (weak, nonatomic) IBOutlet UILabel *labelCountry;
//ViewAddress TxtFields
@property (weak, nonatomic) IBOutlet UITextField *txtFieldAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldCity;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldDistrict;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldCountry;

//ViewAccount Labels  
@property (weak, nonatomic) IBOutlet UILabel *labelGarageName;
@property (weak, nonatomic) IBOutlet UILabel *labelYourName;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelAbout;
@property (weak, nonatomic) IBOutlet UILabel *labelAnyLink;
//ViewAccount TxtFields                                                             
@property (weak, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (weak, nonatomic) IBOutlet UITextField   *txtFieldGarageName;
@property (weak, nonatomic) IBOutlet UITextField   *txtFieldYourName;
@property (weak, nonatomic) IBOutlet UITextField   *txtFieldEmail;
@property (weak, nonatomic) IBOutlet UITextView    *txtViewAbout;
@property (weak, nonatomic) IBOutlet UITextField   *txtFieldAnyLink;

@property (retain, nonatomic) RKObjectManager      *RKObjManeger;

-(IBAction)logout:(id)sender;
-(void)loadAttribsToComponents;
-(IBAction)saveSettings;

@end
