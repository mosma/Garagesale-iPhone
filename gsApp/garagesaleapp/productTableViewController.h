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

@interface productTableViewController : UITableViewController < UITableViewDelegate, 
                                                                UITableViewDataSource,
                                                                UISearchBarDelegate,
                                                                RKObjectLoaderDelegate> {
    RKObjectManager         *manager;
    NSMutableArray          *products;
    NSMutableArray          *thumbsDataArray;
    NSString                *localResourcePath;
    NSString                *textSearch;
    IBOutlet UISearchBar    *productSearchBar;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (retain, nonatomic) RKObjectManager *manager;
@property (retain, nonatomic) NSMutableArray *products;
@property (retain, nonatomic) NSMutableArray *thumbsDataArray;
@property (retain, nonatomic) NSString *localResourcePath;
@property (retain, nonatomic) NSString *textSearch;
@property (nonatomic, retain) IBOutlet UISearchBar *productSearchBar;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)setupProductMapping;
- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;
- (void)loadAttributesSettings;
- (IBAction)reloadProducts:(id)sender;

@end
