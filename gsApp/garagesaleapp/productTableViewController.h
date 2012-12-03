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
//#import "QuartzCore/QuartzCore.h"

@interface productTableViewController : UITableViewController < UITableViewDelegate, 
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
    IBOutlet UISearchBar       *searchBarProduct;
    __unsafe_unretained IBOutlet UISegmentedControl *segmentControl;
                                                                    
    CGFloat _lastContentOffset;
}

@property (retain, nonatomic) RKObjectManager       *RKObjManeger;
@property (retain, nonatomic) NSMutableArray        *mutArrayProducts;
//@property (retain, nonatomic) NSMutableDictionary   *mutDictDataThumbs;
@property (retain, nonatomic) NSString              *strLocalResourcePath;
@property (retain, nonatomic) NSString              *strTextSearch;
@property (retain, nonatomic) IBOutlet OHAttributedLabel *OHlabelTitleResults;
@property (retain, nonatomic) IBOutlet UISearchBar       *searchBarProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, retain) NSArray *imageURLs;


-(void)getResourcePathProduct;
-(void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;
-(void)loadAttribsToComponents:(BOOL)isFromLoadObject;
-(IBAction)showSearch:(id)sender;
-(IBAction)changeSegControl;
@end
