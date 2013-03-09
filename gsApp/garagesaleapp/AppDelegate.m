//
//  AppDelegate.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 03/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "RestKit/RestKit.h"
#import "AppDelegate.h"
#import "GAITracker.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Optional: automatically track uncaught exceptions with Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = NO;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = NO;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-27377582-3"];
    [self setLayoutTabBarController];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)setLayoutTabBarController{
    self.tabBarController = (UITabBarController *)self.window.rootViewController;
    
    UIImage         *selectedImage0     = [UIImage imageNamed:@"homeOver.png"];
    UIImage         *unselectedImage0   = [UIImage imageNamed:@"home.png"];
    UIImage         *selectedImage1     = [UIImage imageNamed:@"addOver.png"];
    UIImage         *unselectedImage1   = [UIImage imageNamed:@"add.png"];
    UIImage         *selectedImage2     = [UIImage imageNamed:@"personOver.png"];
    UIImage         *unselectedImage2   = [UIImage imageNamed:@"person.png"];
    
    UITabBar        *tabBar             = self.tabBarController.tabBar;
    UITabBarItem    *item0              = [tabBar.items objectAtIndex:0];
    UITabBarItem    *item1              = [tabBar.items objectAtIndex:1];
    UITabBarItem    *item2              = [tabBar.items objectAtIndex:2];
    
    [tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"barItemBackOver.png"]];
    [tabBar setBackgroundImage:[UIImage imageNamed:@"barItemBack.png"]];
    
    [item0 setTitle: NSLocalizedString( @"menu-explore", nil)];
    [item1 setTitle: NSLocalizedString( @"menu-add-product", nil)];
    [item2 setTitle: NSLocalizedString( @"menu-my-garage", nil)];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                                       UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:62.0/255.0 green:114.0/255.0 blue:39.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor, [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                   UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:67.0/255.0 green:129.0/255.0 blue:40.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor,nil] forState:UIControlStateSelected];
    
    [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor, [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                   UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor, [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                   UITextAttributeFont, nil] forState:UIControlStateSelected];
    
    [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor, [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                   UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor, [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                   UITextAttributeFont, nil] forState:UIControlStateSelected];
    
    item0.titlePositionAdjustment = UIOffsetMake(0, -2);
    item1.titlePositionAdjustment = UIOffsetMake(0, -2);
    item2.titlePositionAdjustment = UIOffsetMake(0, -2);
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
}

@end
