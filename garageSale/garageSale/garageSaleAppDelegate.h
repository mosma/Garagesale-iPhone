//
//  garageSaleAppDelegate.h
//  garageSale
//
//  Created by Pedro Ivo B Gimenes on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class garageSaleViewController;

@interface garageSaleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet garageSaleViewController *viewController;

@end
