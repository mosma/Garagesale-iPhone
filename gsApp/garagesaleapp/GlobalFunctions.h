//
//  GlobalFunctions.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 17/05/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"
#import "QuartzCore/QuartzCore.h"
#import "RestKit/RestKit.h"

@interface GlobalFunctions : NSObject{
    NSString *getUrlServicePath;
}

+(void)setSearchBarLayout:(UISearchBar *)searchBar;
+(NSString *)getUrlServicePath;
+(UIColor *)getColorRedNavComponets;
+(void)drawTagsButton:(NSArray *)tags scrollView:(UIScrollView *)scrollView viewController:(UIViewController *)viewController;
+(BOOL)isValidEmail:(NSString*) emailString;
+(void)onlyNumberKey:(UITextField *)textField;
+(void)roundedLayer:(CALayer *)viewLayer radius:(float)r shadow:(BOOL)s;
+(UIBarButtonItem *)getIconNavigationBar:(SEL)selector viewContr:(UIViewController *)viewContr imageNamed:(NSString *)imageNamed;
//+(void)setProductMapping:(RKObjectMapping *)productMapping;
+(void)setTextFieldForm:(UITextField *)textField;
@end
