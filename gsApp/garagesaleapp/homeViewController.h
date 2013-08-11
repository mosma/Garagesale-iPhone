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
#import "CKRefreshControl.h"

@interface viewSearchArea : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton       *btCancelSearch;
@property (weak, nonatomic) IBOutlet UIImageView    *imgTxtField;
@property (weak, nonatomic) IBOutlet UITextField    *txtFieldSearch;
@property (strong, nonatomic)     UIViewController *parentVC;
-(void)setSettings;

@end

@interface homeViewController : MasterViewController <RKObjectLoaderDelegate,
                                                    UISearchBarDelegate,
                                                    OHAttributedLabelDelegate,
                                                    UIScrollViewDelegate> {

    BOOL                         *isTopViewShowing;
    BOOL                         *isUserLoged;
    BOOL                         *isAnimationLogo;
    BOOL                         isFromSignUp;
    GlobalFunctions              *globalFunctions;
    UIButton                     *buttonLogo;
    CGFloat                      _lastContentOffset;
    int                          countLoads;
    RKObjectManager              *RKObjManeger;
    NSMutableArray               *mutArrayProducts;
    __weak IBOutlet UIScrollView *scrollViewMain;
    __weak IBOutlet UIView       *viewTopPage;
    __weak IBOutlet viewSearchArea *viewSearchFront;
    __strong IBOutlet viewSearchArea *viewSearchFooter;
    UISearchBar                  *searchBarProduct;
//    __weak IBOutlet UITextField  *txtFieldSearch;
    UIView                       *shadowSearch;
//    __weak IBOutlet UIButton     *btCancelSearch;

    __weak IBOutlet UIButton     *buttonSignUp;
    __weak IBOutlet UIButton     *buttonSignIn;
//    __weak IBOutlet UIImageView  *imgTxtField;
}

@property (nonatomic, retain) RKObjectManager     *RKObjManeger;
@property (nonatomic, retain) NSMutableArray      *mutArrayProducts;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIView       *viewTopPage;

@property (strong, nonatomic) UISearchBar         *searchBarProduct;
@property (nonatomic) BOOL                        isFromSignUp;

@property (weak, nonatomic) IBOutlet UIButton     *buttonSignUp;
@property (weak, nonatomic) IBOutlet UIButton     *buttonSignIn;

@property (strong, nonatomic) CKRefreshControl    *refreshControl;

@property (weak, nonatomic) IBOutlet viewSearchArea *viewSearchFront;
@property (strong, nonatomic) IBOutlet viewSearchArea *viewSearchFooter;

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