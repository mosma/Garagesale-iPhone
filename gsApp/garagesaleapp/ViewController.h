//
//  ViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 03/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "productTableViewController.h"
#import "signUpViewController.h"
#import "productAccountViewController.h"

@interface ViewController : MasterViewController <RKObjectLoaderDelegate,
                                              UISearchBarDelegate,
                                              OHAttributedLabelDelegate,
                                              UITabBarControllerDelegate,
                                              UIScrollViewDelegate,
                                              UIActionSheetDelegate> {

    BOOL                                        *isSearchDisplayed;
    BOOL                                        *isUserLoged;
    BOOL                                        *isAnimationLogo;
    GlobalFunctions                             *globalFunctions;
    UIButton                                    *buttonLogo;
    CGFloat                                     _lastContentOffset;
    int                                         countLoads;                     
    RKObjectManager                             *RKObjManeger;
    NSMutableArray                              *mutArrayProducts;
    __unsafe_unretained IBOutlet UIScrollView   *scrollViewMain;
    __unsafe_unretained IBOutlet UIView         *viewTopPage;
    __unsafe_unretained IBOutlet UIView         *viewSearch;
    UISearchBar    *searchBarProduct;
    __unsafe_unretained IBOutlet UITextField    *txtFieldSearch;
    UIImageView *activityImageView;
    UIView *shadowSearch;
                                                  
}

@property (nonatomic, retain) RKObjectManager                   *RKObjManeger;
@property (nonatomic, retain) NSMutableArray                    *mutArrayProducts;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView  *scrollViewMain;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *viewTopPage;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *viewSearch;
@property (retain, nonatomic) UISearchBar   *searchBarProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField   *txtFieldSearch;

@property (unsafe_unretained, nonatomic) UIImageView *activityImageView;

- (void)getResourcePathProduct;
- (void)reachability;
- (void)loadAttribsToComponents;
- (IBAction)reloadPage:(id)sender;
- (void)gotoProductDetailVC:(id)sender;
//Control searchBarProduct when no have user session.
- (IBAction)showSearch:(id)sender;
//Control searchBarProduct at session user.
- (IBAction)showSearchLoged:(id)sender;
-(void)controlSearchArea;
@end
