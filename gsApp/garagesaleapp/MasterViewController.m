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
    [self setNotification];
    [self reachability];
    overlay = [MTStatusBarOverlay sharedInstance];
    [self setupKeyboardControls];
    [self setupActivityAnimation];
    self.tabBarController.delegate = self;
}

-(void)setupActivityAnimation{
    UIImage *statusImage = [UIImage imageNamed:@"ActivityHome00.png"];
    activityImageView = [[UIImageView alloc] initWithImage:statusImage];
    
    activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"ActivityHome00.png"],
                                         [UIImage imageNamed:@"ActivityHome01.png"],
                                         [UIImage imageNamed:@"ActivityHome02.png"],
                                         [UIImage imageNamed:@"ActivityHome03.png"],
                                         [UIImage imageNamed:@"ActivityHome04.png"],
                                         [UIImage imageNamed:@"ActivityHome05.png"],
                                         [UIImage imageNamed:@"ActivityHome06.png"],
                                         [UIImage imageNamed:@"ActivityHome07.png"],
                                         [UIImage imageNamed:@"ActivityHome00.png"],
                                         nil];
    activityImageView.animationDuration = 1.0;
}

-(void)setupKeyboardControls{
    // Initialize the keyboard controls
    self.keyboardControls = [[BSKeyboardControls alloc] init];

    // Set the delegate of the keyboard controls
    keyboardControls.delegate = self;

    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"

    // Set the style of the bar. Default is UIBarStyleBlackTranslucent.
    self.keyboardControls.barStyle = UIBarStyleBlackTranslucent;

    // Set the tint color of the "Previous" and "Next" button. Default is black.
    self.keyboardControls.previousNextTintColor = [UIColor blackColor];

    // Set the tint color of the done button. Default is a color which looks a lot like the original blue color for a "Done" butotn
    self.keyboardControls.doneTintColor = [UIColor colorWithRed:34.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0];

    // Set title for the "Previous" button. Default is "Previous".
    self.keyboardControls.previousTitle = NSLocalizedString(@"keyboard-previous-btn", nil);

    // Set title for the "Next button". Default is "Next".
    self.keyboardControls.nextTitle = NSLocalizedString(@"keyboard-next-btn", nil);
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

#pragma mark -
#pragma mark BSKeyboardControls Delegate

/* Either "Previous" or "Next" was pressed
 * Here we usually want to scroll the view to the active text field
 * If we want to know which of the two was pressed, we can use the "direction" which will have one of the following values:
 * KeyboardControlsDirectionPrevious        "Previous" was pressed
 * KeyboardControlsDirectionNext            "Next" was pressed
 */
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    [textField becomeFirstResponder];
    [self scrollViewToTextField:textField];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls{}

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
        //overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
        overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
        //overlay.delegate = self;
        //overlay.progress = 0.0;
        [overlay postMessage:NSLocalizedString(@"no-connection-string", nil) duration:10.0 animated:YES];
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
    if (indexOfTab == 1 && ![[[GlobalFunctions getUserDefaults] objectForKey:@"isProductDisplayed"] boolValue]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"keyboard-cancel-btn" , nil)
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"sheet-camera-item" , nil),
                                NSLocalizedString(@"sheet-library-item" , nil),
                                NSLocalizedString(@"sheet-no-pic-item" , nil), nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        sheet.delegate = self;
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

@end
