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

@interface settingsAccountViewController : UIViewController <UITextFieldDelegate, 
                                                             UITextViewDelegate, 
                                                             BSKeyboardControlsDelegate,
                                                             UIScrollViewDelegate, 
                                                             RKObjectLoaderDelegate> {

                                                                 
    __weak IBOutlet UIScrollView  *scrollView;
    __weak IBOutlet UITextField   *txtFieldGarageName;
    __weak IBOutlet UITextField   *txtFieldYourName;
    __weak IBOutlet UITextField   *txtFieldEmail;
    __weak IBOutlet UITextView    *txtViewAbout;
    __weak IBOutlet UITextField   *txtFieldAnyLink;
}

@property (weak, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (weak, nonatomic) IBOutlet UITextField   *txtFieldGarageName;
@property (weak, nonatomic) IBOutlet UITextField   *txtFieldYourName;
@property (weak, nonatomic) IBOutlet UITextField   *txtFieldEmail;
@property (weak, nonatomic) IBOutlet UITextView    *txtViewAbout;
@property (weak, nonatomic) IBOutlet UITextField   *txtFieldAnyLink;

-(IBAction)logout:(id)sender;
-(void)loadAttribsToComponents;

@end
