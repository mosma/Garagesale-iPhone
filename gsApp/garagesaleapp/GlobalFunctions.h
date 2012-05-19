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

+(NSString *)getUrlServicePath;
+(void)drawTagsButton:(NSArray *)tags scrollView:(UIScrollView *)scrollView viewController:(UIViewController *)viewController;
+(BOOL)isValidEmail:(NSString*) emailString;
+(void)onlyNumberKey:(UITextField *)textField;

//+(void)setProductMapping:(RKObjectMapping *)productMapping;

@end
