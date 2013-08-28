//
//  MasterViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 02/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
- (void)setupKeyboardControls;
- (void)scrollViewToTextField:(id)textField;
@end

@implementation MasterViewController

@synthesize isReachability;
@synthesize keyboardControls;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNoMessage];
    [self setupKeyboardControls];
    [self setupActivityAnimation];
    [self setupActionSheet];
    [self reachability];
}

#pragma mark - No Message
-(void)setupNoMessage{
    self.nomessage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 192, 55)];
    [self.nomessage setCenter:CGPointMake(self.view.frame.size.width/2, -50)];
    //[self.navigationController.tabBarController.selectedViewController.view addSubview:self.nomessage];
    [self.view addSubview:self.nomessage];
}
-(void)showNoMessage:(NSString *)name{
    UIImage *img = [UIImage imageNamed:name];
    [self.nomessage setImage:img];
    
    //Animate CAKeyframeAnimation
    self.nomessage.layer.anchorPoint = CGPointMake(0.50, 1.0);
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.05],
                              [NSNumber numberWithFloat:1.08],
                              [NSNumber numberWithFloat:0.92],
                              [NSNumber numberWithFloat:1.0],
                              nil];
    
    bounceAnimation.duration = 0.3;
    [bounceAnimation setTimingFunctions:[NSArray arrayWithObjects:
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         nil]];
    bounceAnimation.removedOnCompletion = NO;
    [self.nomessage setCenter:self.navigationController.tabBarController.selectedViewController.view.center];
    [self.nomessage.layer addAnimation:bounceAnimation forKey:@"bounce"];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideNoMessage) userInfo:nil repeats:NO];
}
-(void)hideNoMessage{
    [UIView animateWithDuration:0.5 animations:^{
        [self.nomessage setCenter:CGPointMake(160, 800)];
    }];
}
-(void)removeNoMessageFromSuperView{
    for (UIView *view in [self.view subviews])
        if ([view isEqual:self.nomessage])
            [self.nomessage removeFromSuperview];
}

#pragma mark - isReachability
- (void)reachability {// Check if the network is available
    [[RKClient sharedClient] isNetworkAvailable];
    // Register for changes in network availability
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reachabilityDidChange:)
                   name:RKReachabilityDidChangeNotification object:nil];
    center = nil;
}
- (void)reachabilityDidChange:(NSNotification *)notification {
    overlay = [MTStatusBarOverlay sharedInstance];
    RKReachabilityObserver* observer = (RKReachabilityObserver *) [notification
                                                                   object];
    RKReachabilityNetworkStatus status = [observer networkStatus];
    if (RKReachabilityNotReachable == status) {
        isReachability = NO;
        //overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
        overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
        //overlay.delegate = self;
        //overlay.progress = 0.0;
        [overlay postMessage:NSLocalizedString(@"no-connection-string", nil) duration:10.0 animated:YES];
        //overlay.progress = 0.1;
        [self showNoMessage:@"nointernet"];
    } else if (RKReachabilityReachableViaWiFi == status) {
        //RKLogInfo(@"Online!");
        isReachability = YES;
        // [overlay postImmediateFinishMessage:@"" duration:0.1 animated:NO];
        //overlay.progress = 1.0;
    } else if (RKReachabilityReachableViaWWAN == status) {
        isReachability = YES;
        // [self showNotification:@"Online!"];
        //RKLogInfo(@"Online via Edge or 3G!");
    }
    overlay = nil;
    observer = nil;
}

#pragma mark -
#pragma mark BSKeyboardControls Delegate
/* Either "Previous" or "Next" was pressed
 * Here we usually want to scroll the view to the active text field
 * If we want to know which of the two was pressed, we can use the "direction" which will have one of the following values:
 * KeyboardControlsDirectionPrevious        "Previous" was pressed
 * KeyboardControlsDirectionNext            "Next" was pressed
 */
-(void)setupKeyboardControls{
    // Initialize the keyboard controls
    BSKeyboardControls *bsKeyB = [[BSKeyboardControls alloc] init];
    
    [self setKeyboardControls:bsKeyB];
    
    // Set the delegate of the keyboard controls
    [keyboardControls setDelegate:self];
    
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    
    // Set the style of the bar. Default is UIBarStyleBlackTranslucent.
    [self.keyboardControls setBarStyle:UIBarStyleBlackTranslucent];
    
    // Set the tint color of the "Previous" and "Next" button. Default is black.
    [self.keyboardControls setPreviousNextTintColor:[UIColor blackColor]];
    
    // Set the tint color of the done button. Default is a color which looks a lot like the original blue color for a "Done" butotn
    [self.keyboardControls setDoneTintColor:[UIColor colorWithRed:34.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    // Set title for the "Previous" button. Default is "Previous".
    [self.keyboardControls setPreviousTitle:NSLocalizedString(@"keyboard-previous-btn", nil)];
    
    // Set title for the "Next button". Default is "Next".
    [self.keyboardControls setNextTitle:NSLocalizedString(@"keyboard-next-btn", nil)];
    bsKeyB = nil;
}
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    [textField becomeFirstResponder];
    [self scrollViewToTextField:textField];
}
-(void)addKeyboardControlsAtFields{
    // Add the keyboard control as accessory view for all of the text fields
    // Also set the delegate of all the text fields to self
    for (id textField in self.keyboardControls.textFields)
    {
        if ([textField isKindOfClass:[UITextField class]])
        {
            ((UITextField *) textField).inputAccessoryView = self.keyboardControls;
            ((UITextField *) textField).delegate = self;
        }
        else if ([textField isKindOfClass:[UITextView class]])
        {
            ((UITextView *) textField).inputAccessoryView = self.keyboardControls;
            ((UITextView *) textField).delegate = self;
        }
    }
	// Do any additional setup after loading the view.
}
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls{}

#pragma mark - Others Setups
-(void)setupActionSheet{
    sheet = [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:nil
                               cancelButtonTitle:NSLocalizedString(@"keyboard-cancel-btn" , nil)
                          destructiveButtonTitle:nil
                               otherButtonTitles:NSLocalizedString(@"sheet-camera-item" , nil),
             NSLocalizedString(@"sheet-library-item" , nil),
             NSLocalizedString(@"sheet-no-pic-item" , nil), nil];
}

-(void)setupActivityAnimation{
    UIImage *statusImage = [UIImage imageNamed:@"ActivityHome00.png"];
    activityImageView = [[UIImageView alloc] initWithImage:statusImage];
    
    [activityImageView setAnimationImages:[NSArray arrayWithObjects:
                                           [UIImage imageNamed:@"ActivityHome00.png"],
                                           [UIImage imageNamed:@"ActivityHome01.png"],
                                           [UIImage imageNamed:@"ActivityHome02.png"],
                                           [UIImage imageNamed:@"ActivityHome03.png"],
                                           [UIImage imageNamed:@"ActivityHome04.png"],
                                           [UIImage imageNamed:@"ActivityHome05.png"],
                                           [UIImage imageNamed:@"ActivityHome06.png"],
                                           [UIImage imageNamed:@"ActivityHome07.png"],
                                           [UIImage imageNamed:@"ActivityHome00.png"],
                                           nil]];
    [activityImageView setAnimationDuration:1.0];
    statusImage = nil;
}

#pragma mark - Delegates
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
    if (indexOfTab == 1 && ![[[GlobalFunctions getUserDefaults] objectForKey:@"isProductDisplayed"] boolValue]) {
        [sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
        [sheet setDelegate:self];
        [sheet showInView:self.view];
        [sheet showFromTabBar:self.tabBarController.tabBar];
        return NO;
    } else {
        return YES;
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [GlobalFunctions setActionSheetAddProduct:self.tabBarController clickedButtonAtIndex:buttonIndex];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    isReachability = nil;
    [self setIsReachability:nil];
    keyboardControls = nil;
    [self setKeyboardControls:nil];
    [self setNomessage:nil];
    self.nomessage = nil;
}

-(void)releaseMemoryCache{
    //viewMessageNet = nil;
    labelNotification = nil;
    isReachability = nil;
    overlay = nil;
    //keyboardControls.delegate = nil;
    keyboardControls = nil;
    activityImageView = nil;
    sheet.delegate = nil;
    sheet = nil;
}

@end
