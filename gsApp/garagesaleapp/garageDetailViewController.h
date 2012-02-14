//
//  garageDetailViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 09/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface garageDetailViewController : UIViewController <RKObjectLoaderDelegate> {
    RKObjectManager *manager;    
    NSArray *garage;
    NSArray *profile;
    NSArray *tags;    
    NSURL *gravatarUrl;
    __unsafe_unretained IBOutlet UILabel        *emailLabel;
    __unsafe_unretained IBOutlet UIImageView    *imageView;
    __unsafe_unretained IBOutlet UILabel        *garageName;
    __unsafe_unretained IBOutlet UILabel        *description;
    __unsafe_unretained IBOutlet UILabel        *city;
    __unsafe_unretained IBOutlet UILabel        *link;
    __unsafe_unretained IBOutlet UIScrollView   *scrollView;
    __unsafe_unretained IBOutlet UIScrollView   *tagsScrollView;
    __unsafe_unretained IBOutlet UIButton *seeAllButton;
}

@property (retain, nonatomic) RKObjectManager *manager;
@property (retain, nonatomic) NSArray *garage;
@property (retain, nonatomic) NSArray *profile;
@property (retain, nonatomic) NSArray *tags;
@property (retain, nonatomic) NSURL *gravatarUrl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *emailLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *garageName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *description;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *city;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *link;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *tagsScrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *seeAllButton;

- (void)loadAttributesSettings;
- (IBAction)gotoUserProductTableVC;
- (void)gotoProductTableVC:(UIButton *)sender;
- (void)drawTagsButton;
- (void)setupCategoryMapping;

@end
