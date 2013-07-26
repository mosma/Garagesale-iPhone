//
//  MasterViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 02/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "MTStatusBarOverlay.h"
#import "BSKeyboardControls.h"
#import "GlobalFunctions.h"
#import "GAI.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)

@interface MasterViewController : GAITrackedViewController <UITabBarControllerDelegate,
                                                            UIActionSheetDelegate,
                                                            UITextFieldDelegate,
                                                            BSKeyboardControlsDelegate>{
    //UIView              *viewMessageNet;
    UILabel             *labelNotification;
    BOOL                isReachability;
    MTStatusBarOverlay  *overlay;
    BSKeyboardControls  *keyboardControls;
    UIImageView         *activityImageView;
    UIActionSheet       *sheet;
}

@property (nonatomic) BOOL isReachability;
@property (strong, nonatomic) UIImageView *nomessage;


-(void)addKeyboardControlsAtFields;
-(void)releaseMemoryCache;
-(void)showNoMessage:(NSString *)name;
@end