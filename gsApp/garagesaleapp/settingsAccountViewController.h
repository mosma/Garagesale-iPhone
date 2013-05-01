//
//  settingsAccountViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "OHAttributedLabel.h"
#import "MBProgressHUD.h"

@interface settingsAccountViewController : MasterViewController <UIScrollViewDelegate, 
                                                                RKObjectLoaderDelegate,
                                                                MBProgressHUDDelegate,
                                                                UITabBarDelegate> {
    
    //ViewNewPassword Labels                                                             
    __weak IBOutlet UILabel         *labelCurrentPassword;
    __weak IBOutlet UILabel         *labelNewPassword;
    __weak IBOutlet UILabel         *labelRepeatPassword;
    //ViewNewPassword TextFields                                                       
    __weak IBOutlet UITextField     *txtFieldCurrentPassword;
    __weak IBOutlet UITextField     *txtFieldNewPassword;
    __weak IBOutlet UITextField     *txtFieldRepeatNewPassword;
                                                                 
    //ViewAddress Labels
    __weak IBOutlet UILabel         *labelAddress;                         
    __weak IBOutlet UILabel         *labelCity;
    __weak IBOutlet UILabel         *labelDistrict;
    __weak IBOutlet UILabel         *labelCountry;                                                            
    //ViewAddress TxtFields                                            
    __weak IBOutlet UITextField     *txtFieldAddress;                                                       
    __weak IBOutlet UITextField     *txtFieldCity;
    __weak IBOutlet UITextField     *txtFieldDistrict;                                                            
    __weak IBOutlet UITextField     *txtFieldCountry;
                                                                 
    //ViewAccount Labels                                                            
    __weak IBOutlet UILabel         *labelGarageName;
    __weak IBOutlet UILabel         *labelYourName;
    __weak IBOutlet UILabel         *labelEmail;
    __weak IBOutlet UILabel         *labelAbout;
    __weak IBOutlet UILabel         *labelAnyLink;
    //ViewAccount TxtFields
    __weak IBOutlet UITextField     *txtFieldGarageName;
    __weak IBOutlet UITextField     *txtFieldYourName;
    __weak IBOutlet UITextField     *txtFieldEmail;
    __weak IBOutlet UITextView      *txtViewAbout;
    __weak IBOutlet UITextField     *txtFieldAnyLink;

    __weak IBOutlet UIScrollView    *scrollView;                                                   
    __weak IBOutlet UIImageView     *imageView;
    __weak IBOutlet OHAttributedLabel  *garageName;
    __weak IBOutlet UILabel         *city;
    
    __weak IBOutlet UIButton        *buttonAccount;
    __weak IBOutlet UIButton        *buttonPassword;
    __weak IBOutlet UIButton        *buttonAddress;
    __weak IBOutlet UIButton        *buttonLogout;
    __weak IBOutlet UIButton        *buttonSave;
                                                                 
    __weak IBOutlet UIButton        *buttonRightAbout;
    MBProgressHUD                   *HUD;
    RKObjectManager                 *RKObjManeger;
    NSUserDefaults                  *settingsAccount;

    __weak IBOutlet OHAttributedLabel  *labelTotalProducts;                             
    __weak IBOutlet OHAttributedLabel  *labelAboutAPP;

    NSString                        *nibId;
    BOOL                            isSaved;
    int                             totalProducts;
}
//ViewPassword Labels
@property (weak, nonatomic) IBOutlet UILabel        *labelCurrentPassword;
@property (weak, nonatomic) IBOutlet UILabel        *labelNewPassword;
@property (weak, nonatomic) IBOutlet UILabel        *labelRepeatPassword;
//ViewPassword TxtFields
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldCurrentPassword;
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldNewPassword;
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldRepeatNewPassword;

//ViewAddress Labels
@property (weak, nonatomic) IBOutlet UILabel        *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel        *labelCity;
@property (weak, nonatomic) IBOutlet UILabel        *labelDistrict;
@property (weak, nonatomic) IBOutlet UILabel        *labelCountry;
//ViewAddress TxtFields
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldAddress;
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldCity;
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldDistrict;
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldCountry;

//ViewAccount Labels  
@property (weak, nonatomic) IBOutlet UILabel        *labelGarageName;
@property (weak, nonatomic) IBOutlet UILabel        *labelYourName;
@property (weak, nonatomic) IBOutlet UILabel        *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel        *labelAbout;
@property (weak, nonatomic) IBOutlet UILabel        *labelAnyLink;
//ViewAccount TxtFields                                                             
@property (weak, nonatomic) IBOutlet UIScrollView   *scrollView;
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldGarageName;
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldYourName;
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldEmail;
@property (weak, nonatomic) IBOutlet UITextView     *txtViewAbout;
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldAnyLink;

@property (weak, nonatomic) IBOutlet UIButton       *buttonAccount;
@property (weak, nonatomic) IBOutlet UIButton       *buttonPassword;
@property (weak, nonatomic) IBOutlet UIButton       *buttonAddress;
@property (weak, nonatomic) IBOutlet UIButton       *buttonLogout;
@property (weak, nonatomic) IBOutlet UIButton       *buttonSave;


@property (weak, nonatomic) IBOutlet UIButton       *buttonRightAbout;

@property (retain, nonatomic) RKObjectManager       *RKObjManeger;
@property (retain, nonatomic) NSUserDefaults        *settingsAccount;

@property (nonatomic) int                           totalProducts;

@property (weak, nonatomic) IBOutlet OHAttributedLabel  *labelTotalProducts;
@property (weak, nonatomic) IBOutlet OHAttributedLabel  *labelAboutAPP;

-(IBAction)logout:(id)sender;
-(IBAction)dimissModal:(id)sender;
-(IBAction)trackAbout:(id)sender;
-(void)loadAttribsToComponents;
-(IBAction)saveSettings;
-(void)getResourcePathProfile;

@end
