//
//  productTableViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 07/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "productDetailViewController.h"
#import "productCustomViewCell.h"
#import "OHAttributedLabel.h"
#import "STSegmentedControl.h"

@interface productTableViewController : MasterViewController < UITableViewDelegate, 
                                                                UITableViewDataSource,
                                                                UISearchBarDelegate,
                                                                RKObjectLoaderDelegate,
                                                                UIScrollViewDelegate,
                                                                UITabBarDelegate, NSURLConnectionDataDelegate> {

    BOOL                    *isSearch;
    BOOL                    *isSegmentedControlChanged;

    RKObjectManager         *RKObjManeger;
    NSMutableArray          *mutArrayProducts;
    NSString                *strLocalResourcePath;
    NSString                *strTextSearch;
    IBOutlet OHAttributedLabel *OHlabelTitleResults;
    UISearchBar       *searchBarProduct;
    STSegmentedControl *segmentControl;
    __unsafe_unretained IBOutlet UIView *viewSegmentArea;
    __unsafe_unretained IBOutlet UITableView        *tableView;                                                          
    CGFloat _lastContentOffset;
}

@property (retain, nonatomic) RKObjectManager       *RKObjManeger;
@property (retain, nonatomic) NSMutableArray        *mutArrayProducts;
@property (retain, nonatomic) NSString              *strLocalResourcePath;
@property (retain, nonatomic) NSString              *strTextSearch;
@property (retain, nonatomic) IBOutlet OHAttributedLabel *OHlabelTitleResults;
@property (retain, nonatomic) UISearchBar       *searchBarProduct;
@property (retain, nonatomic) STSegmentedControl *segmentControl;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewSegmentArea;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView        *tableView;

@property (nonatomic, retain) NSArray *imageURLs;

-(void)getResourcePathProduct;
-(void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;
-(void)loadAttribsToComponents:(BOOL)isFromLoadObject;
-(IBAction)changeSegControl;
-(IBAction)showSearch:(id)sender;
@end
