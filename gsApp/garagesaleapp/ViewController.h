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
#import "aboutViewController.h"
#import "Product.h"

@interface ViewController : UIViewController <RKObjectLoaderDelegate,UISearchBarDelegate,OHAttributedLabelDelegate>{
    RKObjectManager      *RKObjManeger;
    NSArray              *arrayProducts;
    BOOL                 *isSearch;
    GlobalFunctions      *globalFunctions;
    __unsafe_unretained IBOutlet UIScrollView *scrollView;
    __unsafe_unretained IBOutlet UIView       *viewTopPage;
    __unsafe_unretained IBOutlet UIView       *viewSearch;
    __unsafe_unretained IBOutlet UILabel      *labelSearch;
    __unsafe_unretained IBOutlet UISearchBar *searchBarProduct;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *activityMain;
}

@property (nonatomic, retain) RKObjectManager       *RKObjManeger;
@property (nonatomic, retain) NSArray               *arrayProducts;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView       *viewTopPage;
@property (unsafe_unretained, nonatomic) IBOutlet UIView       *viewSearch;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel      *labelSearch;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *searchBarProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *activityMain;

- (void)setupProductMapping;
- (void)reachability;
- (void)loadAttribsToComponents;
- (IBAction)reloadPage:(id)sender;
- (void)gotoProductDetailVC:(id)sender;
//- (void)loadImage:(NSString *)urlImage;
- (void)displayImage:(UIImage *)image;
- (IBAction)showSearch:(id)sender;

@end
