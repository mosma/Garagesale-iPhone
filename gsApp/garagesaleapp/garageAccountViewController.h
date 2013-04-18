//
//  garageAccountViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchViewController.h"
#import "searchCustomViewCell.h"
#import "productAccountViewController.h"
#import "settingsAccountViewController.h"
#import "OHAttributedLabel.h"
#import "STSegmentedControl.h"

@interface garageAccountViewController : MasterViewController <RKObjectLoaderDelegate, 
                                                                UITableViewDelegate,
                                                                UITableViewDataSource,
                                                                UIScrollViewDelegate,
                                                                UITabBarDelegate> {
    settingsAccountViewController *settingsVC;
    RKObjectManager     *RKObjManeger;
    NSMutableArray      *mutArrayProducts;
    STSegmentedControl  *segmentControl;

    //Instacied for Parent. Using in productDetailViewController, productTableViewController.
    Profile             *profile;
    Garage              *garage;
    CGFloat             _lastContentOffset;
    UIImage             *imageGravatar;

    __weak IBOutlet UILabel            *emailLabel;
    __weak IBOutlet UIImageView        *imgGarageLogo;
    __weak IBOutlet OHAttributedLabel  *garageName;
    __weak IBOutlet OHAttributedLabel  *labelTotalProducts;
    __weak IBOutlet UILabel            *description;
    __weak IBOutlet UILabel            *city;
    __weak IBOutlet UILabel            *link;
    __weak IBOutlet UIScrollView       *scrollViewMain;
    __weak IBOutlet UIScrollView       *scrollViewProducts;
    __weak IBOutlet UITableView        *tableViewProducts;
    __weak IBOutlet UIView             *viewSegmentArea;
    __weak IBOutlet UIView             *viewTop;
    __weak IBOutlet UIView                          *viewNoProducts;
    __weak IBOutlet OHAttributedLabel               *labelNoProduct;
}

@property (strong, nonatomic) RKObjectManager       *RKObjManeger;
@property (strong, nonatomic) NSMutableArray        *mutArrayProducts;
@property (strong, nonatomic) Profile               *profile;
@property (strong, nonatomic) Garage                *garage;
@property (strong, nonatomic) UIImage               *imageGravatar;
@property (strong, nonatomic) NSString              *garageNameSearch;
@property (strong, nonatomic) STSegmentedControl *segmentControl;
@property (strong, nonatomic) NSArray *imageURLs;

@property (nonatomic) BOOL isGenericGarage;

@property (weak, nonatomic) IBOutlet OHAttributedLabel  *labelNoProduct;
@property (weak, nonatomic) IBOutlet OHAttributedLabel  *labelTotalProducts;
@property (weak, nonatomic) IBOutlet OHAttributedLabel  *garageName;
@property (weak, nonatomic) IBOutlet UILabel            *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *imgGarageLogo;
@property (weak, nonatomic) IBOutlet UILabel            *description;
@property (weak, nonatomic) IBOutlet UILabel            *city;
@property (weak, nonatomic) IBOutlet UILabel            *link;
@property (weak, nonatomic) IBOutlet UIScrollView       *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIScrollView       *scrollViewProducts;
@property (weak, nonatomic) IBOutlet UITableView        *tableViewProducts;
@property (weak, nonatomic) IBOutlet UIView             *viewSegmentArea;
@property (weak, nonatomic) IBOutlet UIView             *viewTop;
@property (weak, nonatomic) IBOutlet UIView             *viewNoProducts;


- (void)loadAttribsToComponents:(BOOL)isFromLoadObject;
- (IBAction)reloadPage:(id)sender;

@end
