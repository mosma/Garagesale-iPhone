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

@synthesize isReachability;

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
    [self setNotification];
    [self reachability];
    overlay = [MTStatusBarOverlay sharedInstance];

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
        isReachability = NO;
       // [self showNotification:@"No connection."];
        
        //overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
        overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
        //overlay.delegate = self;
        //overlay.progress = 0.0;
        [overlay postMessage:@"Check your Network Connection." duration:10.0 animated:YES];
        //overlay.progress = 0.1;
        
        
        
    } else if (RKReachabilityReachableViaWiFi == status) {
        RKLogInfo(@"Online!"); 
        isReachability = YES;
       // [overlay postImmediateFinishMessage:@"" duration:0.1 animated:NO];
        //overlay.progress = 1.0;
    } else if (RKReachabilityReachableViaWWAN == status) {
        isReachability = YES;
       // [self showNotification:@"Online!"];
        RKLogInfo(@"Online via Edge or 3G!");
    }
}

-(void)setNotification{
    viewMessageNet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [viewMessageNet setAlpha:0];
    [viewMessageNet setBackgroundColor:[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:0.9]];
    labelNotification = [[UILabel alloc] initWithFrame:CGRectMake(13, 11, 307, 22)];
    [labelNotification setTextAlignment:NSTextAlignmentLeft];
    [labelNotification setBackgroundColor:[UIColor clearColor]];
    [labelNotification setTextColor:[UIColor blackColor]];
    [labelNotification setFont:[UIFont fontWithName:@"DroidSans-Bold" size:12.0f]];
    [labelNotification setAlpha:12.0];
}

-(void)showNotification:(NSString *)notification{
    [labelNotification setText:notification];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
    [self.view addSubview:viewMessageNet];
    [viewMessageNet setAlpha:1.0];
    [viewMessageNet setFrame:CGRectMake(0, 0, 320, 47)];
    [viewMessageNet addSubview:labelNotification];
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideViewMessageNet) userInfo:viewMessageNet repeats:NO];
}

-(void)hideViewMessageNet{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
    [viewMessageNet setFrame:CGRectMake(0, 0, 320, 0)];
    [labelNotification removeFromSuperview];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
