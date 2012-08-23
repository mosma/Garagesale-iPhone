//
//  ViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 03/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RestKit.h"
#import "RestKit/RKJSONParserJSONKit.h"
#import "productTableViewController.h"
#import "signUpViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Product.h"

@interface ViewController : UIViewController <RKObjectLoaderDelegate,
                                              UISearchBarDelegate,
                                              OHAttributedLabelDelegate,
                                              UITabBarControllerDelegate>{

    RKObjectManager                             *RKObjManeger;
    NSMutableArray                              *nsArrayProducts;
    BOOL                                        *isSearch;
    GlobalFunctions                             *globalFunctions;
    UIButton                                    *logoButton;
    __unsafe_unretained IBOutlet UIScrollView   *scrollView;
    __unsafe_unretained IBOutlet UIView         *viewTopPage;
    __unsafe_unretained IBOutlet UIView         *viewSearch;
    __unsafe_unretained IBOutlet UILabel        *labelSearch;
    __unsafe_unretained IBOutlet UISearchBar    *searchBarProduct;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *activityLoadProducts;
    __unsafe_unretained IBOutlet UITextField    *txtFieldSearch;
}

@property (nonatomic, retain) RKObjectManager                   *RKObjManeger;
@property (nonatomic, retain) NSMutableArray                    *nsArrayProducts;

@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *viewTopPage;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *viewSearch;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *labelSearch;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar   *searchBarProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *activityLoadProducts;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField   *txtFieldSearch;

- (void)setupProductMapping;
- (void)reachability;
- (void)loadAttribsToComponents;
- (IBAction)reloadPage:(id)sender;
- (void)gotoProductDetailVC:(id)sender;
- (IBAction)showSearch:(id)sender;

@end
