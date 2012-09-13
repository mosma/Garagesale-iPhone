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
                                                                RKObjectLoaderDelegate,
                                                                UIScrollViewDelegate> {
    RKObjectManager         *RKObjManeger;
    NSMutableArray          *mutArrayProducts;
    NSMutableDictionary     *mutDictDataThumbs;
    NSString                *strLocalResourcePath;
    NSString                *strTextSearch;
    BOOL                    *isSearch;
    BOOL                    *isSegmentedControlChanged;
    IBOutlet OHAttributedLabel        *labelTitleResults;

    IBOutlet UISearchBar    *searchBarProduct;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *UIAIV_Main;
    __unsafe_unretained IBOutlet UISegmentedControl *segmentControl;
    //__unsafe_unretained IBOutlet productCustomViewCell *customCellViewLine;                                                            
    //__unsafe_unretained IBOutlet productCustomViewCell *customCellViewBlock;                                                 
}

@property (retain, nonatomic) RKObjectManager       *RKObjManeger;
@property (retain, nonatomic) NSMutableArray        *mutArrayProducts;
@property (retain, nonatomic) NSMutableDictionary   *mutDictDataThumbs;
@property (retain, nonatomic) NSString              *strLocalResourcePath;
@property (retain, nonatomic) NSString              *strTextSearch;

@property (nonatomic, retain) IBOutlet OHAttributedLabel      *labelTitleResults;
@property (nonatomic, retain) IBOutlet UISearchBar  *searchBarProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (unsafe_unretained, nonatomic) IBOutlet UISegmentedControl *segmentControl;
//@property (unsafe_unretained, nonatomic) IBOutlet productCustomViewCell *customCellViewLine; 
//@property (unsafe_unretained, nonatomic) IBOutlet productCustomViewCell *customCellViewBlock; 

-(void)setupProductMapping;
-(void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;
-(void)loadAttribsToComponents:(BOOL)isFromLoadObject;
-(IBAction)showSearch:(id)sender;
-(IBAction)changeSegControl;
@end
