//
//  searchViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 07/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "productDetailViewController.h"
#import "searchCustomViewCell.h"
#import "OHAttributedLabel.h"
#import "STSegmentedControl.h"

@interface searchViewController : MasterViewController <UITableViewDelegate,
                                                        UITableViewDataSource,
                                                        UISearchBarDelegate,
                                                        RKObjectLoaderDelegate,
                                                        UIScrollViewDelegate,
                                                        UITabBarDelegate,
                                                        NSURLConnectionDataDelegate> {
    BOOL                        isSearchDisplayed;
    RKObjectManager             *RKObjManeger;
    NSMutableArray              *mutArrayProducts;
    NSMutableArray              *mutArrayViewHelpers;

    NSString                    *strLocalResourcePath;
    NSString                    *strTextSearch;
    IBOutlet OHAttributedLabel  *OHlabelTitleResults;
    UISearchBar                 *searchBarProduct;
    STSegmentedControl          *segmentControl;                                                       
    CGFloat                     _lastContentOffset;
    UIView                      *shadowSearch;
    __unsafe_unretained IBOutlet UIView         *viewSegmentArea;
    __unsafe_unretained IBOutlet UITableView    *tableView;
}

@property (retain, nonatomic) RKObjectManager               *RKObjManeger;
@property (retain, nonatomic) NSMutableArray                *mutArrayProducts;
@property (retain, nonatomic) NSMutableArray                *mutArrayViewHelpers;

@property (retain, nonatomic) NSString                      *strLocalResourcePath;
@property (retain, nonatomic) NSString                      *strTextSearch;
@property (retain, nonatomic) IBOutlet OHAttributedLabel    *OHlabelTitleResults;
@property (retain, nonatomic) UISearchBar                   *searchBarProduct;
@property (retain, nonatomic) STSegmentedControl            *segmentControl;
@property (unsafe_unretained, nonatomic) IBOutlet UIView    *viewSegmentArea;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView   *tableView;

@property (nonatomic, retain) NSArray *imageURLs;

-(void)getResourceSearch;
-(void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;
-(void)loadAttribsToComponents:(BOOL)isFromLoadObject;
-(IBAction)changeSegControl;
-(IBAction)showSearch:(id)sender;
@end
