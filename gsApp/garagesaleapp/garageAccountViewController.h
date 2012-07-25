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

@interface garageAccountViewController : UIViewController <RKObjectLoaderDelegate> {
    RKObjectManager     *RKObjManeger;
    NSURL               *gravatarUrl;
    __unsafe_unretained IBOutlet UILabel        *emailLabel;
    __unsafe_unretained IBOutlet UIImageView    *imageView;
    __unsafe_unretained IBOutlet UILabel        *garageName;
    __unsafe_unretained IBOutlet UILabel        *description;
    __unsafe_unretained IBOutlet UILabel        *city;
    __unsafe_unretained IBOutlet UILabel        *link;
    __unsafe_unretained IBOutlet UIScrollView   *scrollView;
    __unsafe_unretained IBOutlet UIButton       *seeAllButton;
    __unsafe_unretained IBOutlet UISegmentedControl *segmentControl;
    __unsafe_unretained IBOutlet UIView *tableView;
    __unsafe_unretained IBOutlet UIView *blockView;
}

@property (retain, nonatomic) RKObjectManager   *RKObjManeger;
@property (retain, nonatomic) NSURL             *gravatarUrl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *emailLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView   *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *garageName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *description;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *city;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *link;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton      *seeAllButton;
@property (unsafe_unretained, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *blockView;

-(void)loadAttribsToComponents;
-(IBAction)changeSeg;

@end
