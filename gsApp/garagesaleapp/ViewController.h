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
#import "QuartzCore/QuartzCore.h"
#import "aboutViewController.h"
#import "GlobalFunctions.h"
#import "Product.h"

@interface ViewController : UIViewController <RKObjectLoaderDelegate,UISearchBarDelegate,OHAttributedLabelDelegate>{
    IBOutlet UILabel     *labelTitleTop;
    RKObjectManager      *RKObjManeger;
    NSArray              *arrayProducts;
    BOOL                 *isSearch;
    int imageXPostion;
    int imageYPostion; 
    int countColumn; 
    __unsafe_unretained IBOutlet UIScrollView *scrollView;
    __unsafe_unretained IBOutlet UIView       *viewTopPage;
    __unsafe_unretained IBOutlet UISearchBar *searchBarProduct;
}

@property (nonatomic, retain) IBOutlet UILabel      *labelTitleTop;
@property (nonatomic, retain) RKObjectManager       *RKObjManeger;
@property (nonatomic, retain) NSArray               *arrayProducts;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView       *viewTopPage;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *searchBarProduct;

- (void)setupProductMapping;
- (void)reachability;
- (void)loadAttribsToComponents;
- (IBAction)reloadPage:(id)sender;
- (void)gotoProductDetailVC:(id)sender;
- (void)loadImage:(NSString *)urlImage;
- (void)displayImage:(UIImage *)image;
- (IBAction)showSearch:(id)sender;

@end
