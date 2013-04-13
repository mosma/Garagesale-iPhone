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
                                                        UITabBarDelegate
                                                        > {
    BOOL                        isSearchDisplayed;
    __weak RKObjectManager             *RKObjManeger;
     NSMutableArray              *mutArrayProducts;
     NSMutableArray              *mutArrayViewHelpers;
     NSString                    *strLocalResourcePath;
    NSString                    *strTextSearch;
    __weak IBOutlet OHAttributedLabel  *OHlabelTitleResults;
    UISearchBar                 *searchBarProduct;
    STSegmentedControl          *segmentControl;
    CGFloat                     _lastContentOffset;
    UIView                      *shadowSearch;
    IBOutlet UIView         *viewSegmentArea;
    __weak IBOutlet UITableView    *tableView;
    NSArray *imageURLs;
}

@property (weak, nonatomic) RKObjectManager               *RKObjManeger;
@property (strong, nonatomic) NSMutableArray                *mutArrayProducts;
@property (strong, nonatomic) NSMutableArray                *mutArrayViewHelpers;

@property (strong, nonatomic) NSString                      *strLocalResourcePath;
@property (strong, nonatomic) NSString                      *strTextSearch;
@property (weak, nonatomic) IBOutlet OHAttributedLabel    *OHlabelTitleResults;
@property (strong, nonatomic) STSegmentedControl            *segmentControl;
@property (strong, nonatomic) IBOutlet UIView    *viewSegmentArea;
@property (weak, nonatomic) IBOutlet UITableView   *tableView;
@property (strong, nonatomic) UIView                      *shadowSearch;

@property (strong, nonatomic) NSArray *imageURLs;

-(void)getResourceSearch;
-(void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;
-(void)loadAttribsToComponents:(BOOL)isFromLoadObject;
-(IBAction)changeSegControl;
-(IBAction)showSearch:(id)sender;
@end
