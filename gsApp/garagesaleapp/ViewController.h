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

@interface ViewController : UIViewController <RKObjectLoaderDelegate,UISearchBarDelegate>{
    IBOutlet UILabel     *labelTitleTop;
    RKObjectManager      *RKObjManeger;
    NSArray              *arrayTags;
    UISearchBar          *searcBarProduct;
    __unsafe_unretained IBOutlet UIScrollView *scrollView;
    __unsafe_unretained IBOutlet UIImageView  *imgViewLoading;
}

@property (nonatomic, retain) IBOutlet UILabel      *labelTitleTop;
@property (nonatomic, retain) RKObjectManager       *RKObjManeger;
@property (nonatomic, retain) NSArray               *arrayTags;
@property (nonatomic, retain) IBOutlet UISearchBar  *searcBarProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView   *imgViewLoading;

- (void)setupCategoryMapping;
- (void)reachability;
- (void)loadAttribsToComponents;
- (IBAction)reloadPage:(id)sender;
- (void)gotoProductTableVC:(id)sender;
- (void)setLoadAnimation;

@end
