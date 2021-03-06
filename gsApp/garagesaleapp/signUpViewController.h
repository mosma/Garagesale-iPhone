//
//  signUpViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 05/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "QuartzCore/QuartzCore.h"
#import "homeViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "viewHelper.h"

@interface signUpViewController : MasterViewController <UIScrollViewDelegate, 
                                                        RKObjectLoaderDelegate,
                                                        MBProgressHUDDelegate,
                                                        FBLoginViewDelegate>{
    //Sigup outlets
    __weak IBOutlet UILabel         *labelSignup;
    __weak IBOutlet UILabel         *labelLogin;
    __weak IBOutlet UILabel         *labelGarageName;
    __weak IBOutlet UILabel         *labelPersonName;
    __weak IBOutlet UILabel         *labelEmail;
    __weak IBOutlet UILabel         *labelPassword;
    __weak IBOutlet UITextField     *textFieldPersonName;
    __weak IBOutlet UITextField     *textFieldEmail;
    __weak IBOutlet UITextField     *textFieldGarageName;
    __weak IBOutlet UITextField     *textFieldPassword;
    __weak IBOutlet UIButton        *buttonRegister;
    __weak IBOutlet UIButton        *buttonLogin;
    __weak IBOutlet UIButton        *buttonRegisterNew;
    __weak IBOutlet UIButton        *buttonLostPassword;
    __weak IBOutlet UIScrollView    *scrollView;

    //Sigin outlets
    __weak IBOutlet UITextField     *textFieldUserName;
    __weak IBOutlet UITextField     *textFieldUserPassword;
    
    __weak IBOutlet UIView          *secondView;
                                                        
    //Recover Password
    __weak IBOutlet UITextField     *txtFieldEmailRecover;
    __weak IBOutlet UILabel         *labelPasswRecover;
    __weak IBOutlet UIButton        *buttonRecover;
                                                        
    //Others
    RKObjectManager                 *RKObjManeger;
    NSUserDefaults                  *settingsAccount;
    MBProgressHUD                   *HUD;
    viewHelper                      *vH;
    BOOL                            isLoadingDone;
    int                             flagError;
    NSTimer                         *timer;
                                                 
    NSString                        *garageNameWrited;
    NSString                        *emailWrited;
                                                            
}

//Sigup outlets
@property (weak, nonatomic) IBOutlet UILabel        *labelSignup;
@property (weak, nonatomic) IBOutlet UILabel        *labelLogin;
@property (weak, nonatomic) IBOutlet UITextField    *textFieldPersonName;
@property (weak, nonatomic) IBOutlet UITextField    *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField    *textFieldGarageName;
@property (weak, nonatomic) IBOutlet UITextField    *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIImageView    *imgFieldPassword;
@property (weak, nonatomic) IBOutlet UIImageView    *imgFieldEmail;
@property (weak, nonatomic) IBOutlet UIButton       *buttonRegister;
@property (weak, nonatomic) IBOutlet UIButton       *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton       *buttonRegisterNew;
@property (weak, nonatomic) IBOutlet UILabel        *labelGarageName;
@property (weak, nonatomic) IBOutlet UILabel        *labelPersonName;
@property (weak, nonatomic) IBOutlet UILabel        *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel        *labelPassword;
@property (weak, nonatomic) IBOutlet UIScrollView   *scrollView;

//Sigin outlets
@property (weak, nonatomic) IBOutlet UITextField    *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField    *textFieldUserPassword;

@property (weak, nonatomic) IBOutlet UIView         *secondView;

//Others
@property (nonatomic, retain) RKObjectManager       *RKObjManeger;
@property (nonatomic, retain) NSUserDefaults        *settingsAccount;

//FaceBook Login
@property (strong, nonatomic) IBOutlet UIButton     *buttonFaceBook;
@property (strong, nonatomic) NSString *FBGarageName;
@property (strong, nonatomic) NSString *FBName;
@property (strong, nonatomic) NSString *FBEmail;
@property (strong, nonatomic) NSString *FBLocale;
@property (strong, nonatomic) NSString *FBId;
@property (strong, nonatomic) NSString *FBToken;

@property (nonatomic) int qtdProducts;

//Actions and functions
-(void)loadAttribsToComponents;
-(void)setLogin:(NSArray *)objects;
-(void)getResourcePathGarage;
-(void)getResourcePathProfile;
-(IBAction)recoverPassword:(id)sender;
-(IBAction)trackRecoverPassword:(id)sender;
-(IBAction)setGarageNameWrited:(id)sender;
-(IBAction)setEmailWrited:(id)sender;
@end
