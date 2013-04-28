//
//  homeViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 03/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "productAccountViewController.h"
#import "searchViewController.h"
#import "signUpViewController.h"

@interface homeViewController : MasterViewController <RKObjectLoaderDelegate,
                                                    UISearchBarDelegate,
                                                    OHAttributedLabelDelegate,
                                                    UIScrollViewDelegate> {

    BOOL                                        *isTopViewShowing;
    BOOL                                        *isUserLoged;
    BOOL                                        *isAnimationLogo;
    BOOL                                        isFromSignUp;
    GlobalFunctions                             *globalFunctions;
    UIButton                                    *buttonLogo;
    CGFloat                                     _lastContentOffset;
    int                                         countLoads;
    RKObjectManager                             *RKObjManeger;
    NSMutableArray                              *mutArrayProducts;
    __weak IBOutlet UIScrollView   *scrollViewMain;
    __weak IBOutlet UIView         *viewTopPage;
    __weak IBOutlet UIView         *viewSearch;
    UISearchBar                    *searchBarProduct;
    __weak IBOutlet UITextField    *txtFieldSearch;
    UIView                                      *shadowSearch;
    __weak IBOutlet UIButton *btCancelSearch;

    __weak IBOutlet UIButton                    *buttonSignUp;
    __weak IBOutlet UIButton                    *buttonSignIn;
    __weak IBOutlet UIImageView *imgTxtField;
}

@property (nonatomic, retain) RKObjectManager                   *RKObjManeger;
@property (nonatomic, retain) NSMutableArray                    *mutArrayProducts;
@property (weak, nonatomic) IBOutlet UIScrollView  *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIView        *viewTopPage;
@property (weak, nonatomic) IBOutlet UIView        *viewSearch;
@property (strong, nonatomic) UISearchBar                       *searchBarProduct;
@property (weak, nonatomic) IBOutlet UITextField   *txtFieldSearch;
@property (nonatomic) BOOL                   isFromSignUp;

@property (weak, nonatomic) IBOutlet UIButton   *buttonSignUp;
@property (weak, nonatomic) IBOutlet UIButton   *buttonSignIn;
@property (weak, nonatomic) IBOutlet UIImageView *imgTxtField;
@property (weak, nonatomic) IBOutlet UIButton *btCancelSearch;

- (void)getResourcePathProduct;
- (void)reachability;
- (void)loadAttribsToComponents;
- (IBAction)reloadPage:(id)sender;
- (void)gotoProductDetailVC:(id)sender;
//Control searchBarProduct when no have user session.
- (IBAction)showHideTopPage:(id)sender;
- (IBAction)showHideViewSearch:(id)sender;
//Control searchBarProduct at session user.
//- (IBAction)showSearchLoged:(id)sender;
-(void)controlSearchArea;
@end
