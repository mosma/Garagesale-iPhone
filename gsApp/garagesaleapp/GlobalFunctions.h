//
//  GlobalFunctions.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 17/05/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "QuartzCore/QuartzCore.h"
#import "RestKit/RestKit.h"
#import "OHAttributedLabel.h"
#import "Category.h"
#import "Product.h"
#import "Caminho.h"
#import "productAccountViewController.h"

@interface GlobalFunctions : NSObject <RKObjectLoaderDelegate>{
    NSUserDefaults *getUserDefaults;
    int imageThumbsXorigin_Iphone;
    int imageThumbsYorigin_Iphone;
    int countColumnImageThumbs;
}

typedef enum {
	imageTypeIcon,
	imageTypeListing,
    imageTypeListingScaled,
    imageTypeMobile,
    imageTypeOriginal
} imageType;

typedef enum {
	tabPositionTop,
	tabPositionBottom
} tabPosition;

+(void)setSearchBarLayout:(UISearchBar *)searchBar;
+(NSString *)getUrlServicePath;
+(NSString *)getUrlApplication;
+(NSString *)getMIMEType;
+(NSUserDefaults *)getUserDefaults;
+(UIColor *)getColorRedNavComponets;
+(void)drawTagsButton:(NSArray *)tags scrollView:(UIScrollView *)scrollView viewController:(UIViewController *)viewController;
+(BOOL)isValidEmail:(NSString*) emailString;
+(BOOL)onlyNumberKey:(NSString *)string;
+(UIBarButtonItem *)getIconNavigationBar:(SEL)selector viewContr:(UIViewController *)viewContr imageNamed:(NSString *)imageNamed rect:(CGRect)rect;
+(NSMutableAttributedString *)getNamePerfil:(NSString *)garagem profileName:(NSString *)profileName;
+(void)hideTabBar:(UITabBarController *) tabbarcontroller animated:(BOOL)animated;
+(void)showTabBar:(UITabBarController *)tabbarcontroller;
+(UILabel *)getLabelTitleGaragesaleNavBar:(UITextAlignment *)textAlignment width:(int)width;
+(UILabel *)getLabelTitleNavBarGeneric:(UITextAlignment *)textAlignment text:(NSString *)text width:(int)width;
+(UIImage*)scaleToSize:(CGSize)size imageOrigin:(UIImage *)imageOrigin;
+(NSString *)getCurrencyByCode:(NSString*)currencyCode;
+(void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController;
+(void)setNavigationBarBackground:(UINavigationController *)navController;
+(NSString *)getUrlImagesProduct:(NSMutableArray *)product imageType:(imageType)imageType;
+(void)setActionSheetAddProduct:(UITabBarController *)tabBarController clickedButtonAtIndex:(NSInteger)buttonInder;
+(NSString *)formatAddressGarage:(NSArray *)array;

-(void)loadThumbs:(NSArray *)array;
-(UIView *)loadButtonsThumbsProduct:(NSArray *)arrayDetailProduct showEdit:(BOOL)showEdit showPrice:(BOOL)showPrice viewContr:(UIViewController *)viewContr;

//if istabTopPosition return topPosition else return tabBottomPosition
+(int)getTabPosition:(tabPosition)position;
+(int)getHomeProductsNumber;

@property (unsafe_unretained, nonatomic) int imageThumbsXorigin_Iphone;
@property (unsafe_unretained, nonatomic) int imageThumbsYorigin_Iphone;
@property (unsafe_unretained, nonatomic) int countColumnImageThumbs;

@end
