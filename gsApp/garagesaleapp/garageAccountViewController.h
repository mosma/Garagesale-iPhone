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
#import "Category.h"
#import "GlobalFunctions.h"
#import "productCustomViewCell.h"
#import "settingsAccountViewController.h"

@interface garageAccountViewController : UIViewController <RKObjectLoaderDelegate, 
                                                        UITableViewDelegate,
                                                        UITableViewDataSource> {
    RKObjectManager     *RKObjManeger;
    NSURL               *gravatarUrl;
    NSMutableArray      *mutArrayProducts;
    NSMutableArray      *mutArrayDataThumbs;
    GlobalFunctions     *globalFunctions;
                                                           
    __unsafe_unretained IBOutlet UILabel        *emailLabel;
    __unsafe_unretained IBOutlet UIImageView    *imageView;
    __unsafe_unretained IBOutlet UILabel        *garageName;
    __unsafe_unretained IBOutlet UILabel        *description;
    __unsafe_unretained IBOutlet UILabel        *city;
    __unsafe_unretained IBOutlet UILabel        *link;
    __unsafe_unretained IBOutlet UIScrollView   *scrollViewProducts;
    __unsafe_unretained IBOutlet UITableView    *tableViewProducts;
    __unsafe_unretained IBOutlet UISegmentedControl *segmentControl;
}

@property (retain, nonatomic) RKObjectManager   *RKObjManeger;
@property (retain, nonatomic) NSURL             *gravatarUrl;
@property (retain, nonatomic) NSMutableArray    *mutArrayProducts;
@property (retain, nonatomic) NSMutableArray    *mutArrayDataThumbs;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *emailLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView   *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *garageName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *description;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *city;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *link;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView  *scrollViewProducts;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView   *tableViewProducts;
@property (unsafe_unretained, nonatomic) IBOutlet UISegmentedControl *segmentControl;

- (void)loadAttribsToComponents:(BOOL)isFromLoadObject;
- (IBAction)changeSegControl;

@end
