//
//  MasterViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 02/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    viewMessageNet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [viewMessageNet setAlpha:0];
    [viewMessageNet setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0]];
    lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab setText:@"check your connection."];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setTextColor:[UIColor whiteColor]];
    [lab setFont:[UIFont fontWithName:@"Droid Sans" size:12]];
    [lab setAlpha:12.0];
    [self reachability];
	// Do any additional setup after loading the view.
}

- (void)reachability {// Check if the network is available
    [[RKClient sharedClient] isNetworkAvailable];
    // Register for changes in network availability
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reachabilityDidChange:)
                   name:RKReachabilityDidChangeNotification object:nil];
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    RKReachabilityObserver* observer = (RKReachabilityObserver *) [notification
                                                                   object];
    RKReachabilityNetworkStatus status = [observer networkStatus];
    if (RKReachabilityNotReachable == status) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.9];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
        [self.view addSubview:viewMessageNet];
        [viewMessageNet setAlpha:1.0];
        [viewMessageNet setFrame:CGRectMake(0, 0, 320, 22)];
        [viewMessageNet addSubview:lab];
        [UIView commitAnimations];
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideViewMessageNet) userInfo:viewMessageNet repeats:NO];

    } else if (RKReachabilityReachableViaWiFi == status) {
        RKLogInfo(@"Online via WiFi!");
    } else if (RKReachabilityReachableViaWWAN == status) {
        RKLogInfo(@"Online via Edge or 3G!");
    }
}

-(void)hideViewMessageNet{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
    [viewMessageNet setFrame:CGRectMake(0, 0, 320, 0)];
    [lab removeFromSuperview];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
