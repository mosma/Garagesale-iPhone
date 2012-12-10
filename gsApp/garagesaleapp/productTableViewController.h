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

@interface productTableViewController : MasterViewController < UITableViewDelegate, 
                                                                UITableViewDataSource,
                                                                
                                                                RKObjectLoaderDelegate,
                                                                UIScrollViewDelegate,
                                                                UITabBarDelegate, NSURLConnectionDataDelegate> {

    BOOL                    *isSegmentedControlChanged;

    RKObjectManager         *RKObjManeger;
    NSMutableArray          *mutArrayProducts;
    NSString                *strLocalResourcePath;
    NSString                *strTextSearch;
    IBOutlet OHAttributedLabel *OHlabelTitleResults;
    __unsafe_unretained IBOutlet UISegmentedControl *segmentControl;
    __unsafe_unretained IBOutlet UITableView        *tableView;                                                          
    CGFloat _lastContentOffset;
    __unsafe_unretained IBOutlet UIView         *viewSearch;
    __unsafe_unretained IBOutlet UITextField    *txtFieldSearch;

}

@property (retain, nonatomic) RKObjectManager       *RKObjManeger;
@property (retain, nonatomic) NSMutableArray        *mutArrayProducts;
@property (retain, nonatomic) NSString              *strLocalResourcePath;
@property (retain, nonatomic) NSString              *strTextSearch;
@property (retain, nonatomic) IBOutlet OHAttributedLabel *OHlabelTitleResults;
@property (unsafe_unretained, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView        *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *viewSearch;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField   *txtFieldSearch;

@property (nonatomic, retain) NSArray *imageURLs;

-(void)getResourcePathProduct;
-(void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;
-(void)loadAttribsToComponents:(BOOL)isFromLoadObject;
-(IBAction)changeSegControl;
-(IBAction)showSearch:(id)sender;
@end
