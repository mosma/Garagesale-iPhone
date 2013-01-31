//
//  garageAccountViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productTableViewController.h"
//#import "QuartzCore/QuartzCore.h"
#import "GlobalFunctions.h"
#import "productCustomViewCell.h"
#import "productAccountViewController.h"
#import "settingsAccountViewController.h"
#import "OHAttributedLabel.h"
#import "MBProgressHUD.h"
#import "STSegmentedControl.h"

@interface garageAccountViewController : MasterViewController <RKObjectLoaderDelegate, 
                                                        UITableViewDelegate,
                                                        UITableViewDataSource,
                                                        UIScrollViewDelegate,
                                                        MBProgressHUDDelegate,
                                                        UITabBarControllerDelegate,UITabBarDelegate> {
    RKObjectManager     *RKObjManeger;
    NSURL               *gravatarUrl;
    NSMutableArray      *mutArrayProducts;
    NSMutableDictionary *mutDictDataThumbs;
    GlobalFunctions     *globalFunctions;
    MBProgressHUD       *HUD;
    settingsAccountViewController *settingsVC;
    //Instacied for Parent. Using in productDetailViewController, productTableViewController.
    Profile             *profile;
    Garage              *garage;
    CGFloat                                     _lastContentOffset;
    UIImage *imageGravatar;

    __unsafe_unretained IBOutlet UILabel            *emailLabel;
    __unsafe_unretained IBOutlet UIImageView        *imgGarageLogo;
    __unsafe_unretained IBOutlet UILabel            *garageName;
    __unsafe_unretained IBOutlet UILabel            *description;
    __unsafe_unretained IBOutlet UILabel            *city;
    __unsafe_unretained IBOutlet UILabel            *link;
    __unsafe_unretained IBOutlet OHAttributedLabel  *labelTotalProducts;
    __unsafe_unretained IBOutlet UIScrollView       *scrollViewMain;
    __unsafe_unretained IBOutlet UIScrollView       *scrollViewProducts;
    __unsafe_unretained IBOutlet UITableView        *tableViewProducts;
    STSegmentedControl *segmentControl;
    __unsafe_unretained IBOutlet UIView *viewSegmentArea;
    __unsafe_unretained IBOutlet UIView *viewTop;
    __weak IBOutlet UIView *viewNoProducts;
    __weak IBOutlet OHAttributedLabel *labelNoProduct;
}

@property (retain, nonatomic) RKObjectManager   *RKObjManeger;
@property (retain, nonatomic) NSURL             *gravatarUrl;
@property (retain, nonatomic) NSMutableArray    *mutArrayProducts;
@property (retain, nonatomic) NSMutableDictionary   *mutDictDataThumbs;
@property (retain, nonatomic) Profile           *profile;
@property (retain, nonatomic) Garage            *garage;
@property (retain, nonatomic) UIImage *imageGravatar;
@property (retain, nonatomic) NSString *garageNameSearch;
@property (nonatomic) BOOL isGenericGarage;
@property (weak, nonatomic) IBOutlet OHAttributedLabel *labelNoProduct;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel            *emailLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView        *imgGarageLogo;
@property (unsafe_unretained, nonatomic) IBOutlet OHAttributedLabel  *labelTotalProducts;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel            *garageName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel            *description;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel            *city;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel            *link;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView       *scrollViewMain;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView       *scrollViewProducts;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView        *tableViewProducts;
@property (retain, nonatomic) STSegmentedControl *segmentControl;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewSegmentArea;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewTop;

@property (nonatomic, retain) NSArray *imageURLs;
@property (weak, nonatomic) IBOutlet UIView *viewNoProducts;


- (void)loadAttribsToComponents:(BOOL)isFromLoadObject;
- (IBAction)reloadPage:(id)sender;

@end
