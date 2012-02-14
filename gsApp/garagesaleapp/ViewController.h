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
#import "Category.h"
#import "productTableViewController.h"

@interface ViewController : UIViewController <RKRequestDelegate,UISearchBarDelegate>{
    IBOutlet UILabel     *titleAPP;
    RKObjectManager      *manager;
    NSArray              *tags;
    UISearchBar          *productSearchBar;
    __unsafe_unretained IBOutlet UIScrollView *scrollView;
    __unsafe_unretained IBOutlet UIImageView  *imageLoad;
}

@property (nonatomic, retain) IBOutlet UILabel *titleAPP;
@property (nonatomic, retain) RKObjectManager *manager;
@property (nonatomic, retain) NSArray *tags;
@property (nonatomic, retain) IBOutlet UISearchBar *productSearchBar;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageLoad;

- (void)setupCategoryMapping;
- (void)reachability;
- (void)loadAttributesSettings;
- (IBAction)reloadPage:(id)sender;
- (void)gotoProductTableVC:(id)sender;
- (void)drawTagsButton;
- (void)setLoadAnimation;
@end
