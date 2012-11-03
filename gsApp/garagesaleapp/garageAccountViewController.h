//
//  garageAccountViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productTableViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "GlobalFunctions.h"
#import "productCustomViewCell.h"
#import "productAccountViewController.h"
#import "settingsAccountViewController.h"
#import "OHAttributedLabel.h"
#import "MBProgressHUD.h"

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
    //Instacied for Parent. Using in productDetailViewController, productTableViewController.
    Profile             *profile;
    Garage              *garage;
    BOOL                isLoadingDone;
                                                            
    __unsafe_unretained IBOutlet UILabel            *emailLabel;
    __unsafe_unretained IBOutlet UIButton           *buttonGarageLogo;
    __unsafe_unretained IBOutlet UILabel            *garageName;
    __unsafe_unretained IBOutlet UILabel            *description;
    __unsafe_unretained IBOutlet UILabel            *city;
    __unsafe_unretained IBOutlet UILabel            *link;
    __unsafe_unretained IBOutlet OHAttributedLabel  *labelTotalProducts;
    __unsafe_unretained IBOutlet UIScrollView       *scrollViewMain;
    __unsafe_unretained IBOutlet UIScrollView       *scrollViewProducts;
    __unsafe_unretained IBOutlet UITableView        *tableViewProducts;
    __unsafe_unretained IBOutlet UISegmentedControl *segmentControl;
    __unsafe_unretained IBOutlet UIView *viewTop;
}

@property (retain, nonatomic) RKObjectManager   *RKObjManeger;
@property (retain, nonatomic) NSURL             *gravatarUrl;
@property (retain, nonatomic) NSMutableArray    *mutArrayProducts;
@property (retain, nonatomic) NSMutableDictionary   *mutDictDataThumbs;
@property (nonatomic) BOOL                      isFromParent;
@property (retain, nonatomic) Profile           *profile;
@property (retain, nonatomic) Garage            *garage;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel            *emailLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton           *buttonGarageLogo;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel            *garageName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel            *description;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel            *city;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel            *link;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView       *scrollViewMain;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView       *scrollViewProducts;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView        *tableViewProducts;
@property (unsafe_unretained, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewTop;

- (void)loadAttribsToComponents:(BOOL)isFromLoadObject;
- (IBAction)changeSegControl;
- (IBAction)reloadPage:(id)sender;

@end
