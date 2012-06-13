//
//  signUpViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 05/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
#import "BSKeyboardControls.h"
#import "QuartzCore/QuartzCore.h"

@interface signUpViewController : UIViewController <UITextFieldDelegate, 
UITextViewDelegate, 
BSKeyboardControlsDelegate,
UIScrollViewDelegate,
RKObjectLoaderDelegate>{
    //Sigup outlets
    __weak IBOutlet UILabel *labelSignup;
    __weak IBOutlet UITextField *textFieldPersonName;
    __weak IBOutlet UITextField *textFieldEmail;
    __weak IBOutlet UITextField *textFieldGarageName;
    __weak IBOutlet UITextField *textFieldPassword;
    __weak IBOutlet UIButton    *buttonRegister;
    
    __weak IBOutlet UILabel *labelGarageName;
    __weak IBOutlet UILabel *labelPersonName;
    __weak IBOutlet UILabel *labelEmail;
    __weak IBOutlet UILabel *labelPassword;
    __weak IBOutlet UIScrollView *scrollView;
    
    //Sigin outlets
    __weak IBOutlet UITextField *textFieldUserName;
    __weak IBOutlet UITextField *textFieldUserPassword;
}

@property (weak, nonatomic) IBOutlet UILabel *labelSignup;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPersonName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGarageName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegister;

@property (weak, nonatomic) IBOutlet UILabel *labelGarageName;
@property (weak, nonatomic) IBOutlet UILabel *labelPersonName;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUserPassword;

-(void)loadAttributs;

@end
