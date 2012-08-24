//
//  productTableViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 07/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "productDetailViewController.h"
#import "productCustomViewCell.h"
#import "OHAttributedLabel.h"
#import "Product.h"
#import "Photo.h"
#import "QuartzCore/QuartzCore.h"

@interface productTableViewController : UITableViewController < UITableViewDelegate, 
                                                                UITableViewDataSource,
                                                                UISearchBarDelegate,
                                                                RKObjectLoaderDelegate> {
    RKObjectManager         *RKObjManeger;
    NSMutableArray          *mutArrayProducts;
    NSMutableArray          *mutArrayDataThumbs;
    NSString                *strLocalResourcePath;
    NSString                *strTextSearch;
    BOOL                    *isSearch;
    IBOutlet UILabel        *labelTitleResults;

    IBOutlet UISearchBar    *searchBarProduct;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *UIAIV_Main;
}

@property (retain, nonatomic) RKObjectManager       *RKObjManeger;
@property (retain, nonatomic) NSMutableArray        *mutArrayProducts;
@property (retain, nonatomic) NSMutableArray        *mutArrayDataThumbs;
@property (retain, nonatomic) NSString              *strLocalResourcePath;
@property (retain, nonatomic) NSString              *strTextSearch;

@property (nonatomic, retain) IBOutlet UILabel      *labelTitleResults;
@property (nonatomic, retain) IBOutlet UISearchBar  *searchBarProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)setupProductMapping;
- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;
- (void)loadAttribsToComponents:(BOOL)isFromLoadObject;
- (IBAction)showSearch:(id)sender;

@end
