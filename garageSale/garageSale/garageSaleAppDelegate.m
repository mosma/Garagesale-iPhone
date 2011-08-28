#import "NavigatorController.h"
#import "garageSaleAppDelegate.h"
#import "garageSaleViewController.h"

@implementation garageSaleAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    NavigationController* home = [[[NavigationController alloc] initWithNibName:nil bundle:nil] autorelease];
    home.tabBarItem.title = @"Home";
    home.tabBarItem.image = [UIImage imageNamed:@"home"];
    
    NavigationController* garage = [[[NavigationController alloc] initWithNibName:nil bundle:nil] autorelease];
    garage.tabBarItem.title = @"My Garage";
    garage.tabBarItem.image = [UIImage imageNamed:@"mygarage"];    
    
    NavigationController* search = [[[NavigationController alloc] initWithNibName:nil bundle:nil] autorelease];
    search.tabBarItem.title = @"Search";
    search.tabBarItem.image = [UIImage imageNamed:@"search"];    
    
    UITabBarController* tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    tabBarController.viewControllers = [NSArray arrayWithObjects: home, garage, search, nil];
    
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
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

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
