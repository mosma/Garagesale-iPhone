//
//  settingsAccountViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "settingsAccountViewController.h"

@interface settingsAccountViewController ()
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
- (void)setupKeyboardControls;
- (void)scrollViewToTextField:(id)textField;
@end

@implementation settingsAccountViewController
@synthesize labelCurrentPassword;
@synthesize labelNewPassword;
@synthesize labelRepeatPassword;
@synthesize txtFieldCurrentPassword;
@synthesize txtFieldNewPassword;
@synthesize txtFieldRepeatNewPassword;
@synthesize labelAddress;
@synthesize labelCity;
@synthesize labelDistrict;
@synthesize labelCountry;
@synthesize txtFieldAddress;
@synthesize txtFieldGarageName;
@synthesize txtFieldCity;
@synthesize txtFieldDistrict;
@synthesize txtFieldCountry;

@synthesize labelGarageName;
@synthesize labelYourName;
@synthesize labelEmail;
@synthesize labelAbout;
@synthesize labelAnyLink;
@synthesize scrollView;
@synthesize txtFieldYourName;
@synthesize txtFieldEmail;
@synthesize txtViewAbout;
@synthesize txtFieldAnyLink;
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)logout:(id)sender{
    /*

     Reset Token... Colocar isso no globalfuncionts
     

     */
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
    
    NSInteger i;
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        
        NSLog(@"quantidade : %i", i++);
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    ViewController *rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:rootVC animated:YES];

}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAttribsToComponents];
}

- (void)loadAttribsToComponents{
    
    //ViewPassword
    labelCurrentPassword.font   = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelNewPassword.font       = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelRepeatPassword.font    = [UIFont fontWithName:@"Droid Sans" size:13 ];
    
    [txtFieldCurrentPassword    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldNewPassword        setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldRepeatNewPassword  setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    txtFieldCurrentPassword.text = [[GlobalFunctions getUserDefaults] objectForKey:@"senha"];
    
    //ViewAddress
    labelAddress.font       = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelCity.font          = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelDistrict.font      = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelCountry.font       = [UIFont fontWithName:@"Droid Sans" size:13 ];
    
    [txtFieldAddress    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldCity       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldDistrict   setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldCountry    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    txtFieldAddress.text    = [[GlobalFunctions getUserDefaults] objectForKey:@"address"];
    txtFieldCity.text       = [[GlobalFunctions getUserDefaults] objectForKey:@"city"];
    txtFieldDistrict.text   = [[GlobalFunctions getUserDefaults] objectForKey:@"district"];
    txtFieldCountry.text    = [[GlobalFunctions getUserDefaults] objectForKey:@"country"];
    
    //ViewAccount
    labelGarageName.font    = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelEmail.font         = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelAbout.font         = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelYourName.font      = [UIFont fontWithName:@"Droid Sans" size:13 ];

    [txtFieldGarageName setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldYourName   setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtViewAbout       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldEmail      setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldAnyLink    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    txtFieldGarageName.text = [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"];
    txtFieldYourName.text   = [[GlobalFunctions getUserDefaults] objectForKey:@"nome"];
    txtViewAbout.text       = [[GlobalFunctions getUserDefaults] objectForKey:@"about"];
    txtFieldEmail.text      = [[GlobalFunctions getUserDefaults] objectForKey:@"email"];
    txtFieldAnyLink.text    = [[GlobalFunctions getUserDefaults] objectForKey:@"link"];
    
    self.scrollView.contentSize = CGSizeMake(320,700);
    self.navigationItem.leftBarButtonItem = [GlobalFunctions getIconNavigationBar:
                                             @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];
    
    //[self.navigationItem.titleView addSubview:[GlobalFunctions getLabelTitleNavBarGeneric:UITextAlignmentCenter width:300]];
    
    [self setupKeyboardControls];
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

/* Setup the keyboard controls BSKeyboardControls.h */
- (void)setupKeyboardControls
{
    // Initialize the keyboard controls
    self.keyboardControls = [[BSKeyboardControls alloc] init];
    
    // Set the delegate of the keyboard controls
    self.keyboardControls.delegate = self;
    
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    
    self.keyboardControls.textFields = [NSArray arrayWithObjects:txtFieldGarageName, txtFieldYourName, txtFieldEmail, txtViewAbout, txtFieldAnyLink, nil];
    
    // Set the style of the bar. Default is UIBarStyleBlackTranslucent.
    self.keyboardControls.barStyle = UIBarStyleBlackTranslucent;
    
    // Set the tint color of the "Previous" and "Next" button. Default is black.
    self.keyboardControls.previousNextTintColor = [UIColor blackColor];
    
    // Set the tint color of the done button. Default is a color which looks a lot like the original blue color for a "Done" butotn
    self.keyboardControls.doneTintColor = [UIColor colorWithRed:34.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    // Set title for the "Previous" button. Default is "Previous".
    self.keyboardControls.previousTitle = @"Previous";
    
    // Set title for the "Next button". Default is "Next".
    self.keyboardControls.nextTitle = @"Next";
    
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
}

/* Scroll the view to the active text field */
- (void)scrollViewToTextField:(id)textField
{
    UIScrollView* v = (UIScrollView*) self.scrollView;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:v];
    
    //rc.origin.x = 0 ;
    //rc.origin.y = 0 ;
    
    rc.size.height = 700;
    [self.scrollView scrollRectToVisible:rc animated:YES];
    
    /* 
     Use this block case use UITableView
     
     UITableViewCell *cell = nil;
     if ([textField isKindOfClass:[UITextField class]])
     cell = (UITableViewCell *) ((UITextField *) textField).superview.superview;
     else if ([textField isKindOfClass:[UITextView class]])
     cell = (UITableViewCell *) ((UITextView *) textField).superview.superview;
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
     [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
     */
}

#pragma mark -
#pragma mark BSKeyboardControls Delegate

/* 
 * The "Done" button was pressed
 * We want to close the keyboard
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [controls.activeTextField resignFirstResponder];
}

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


- (void)viewDidUnload
{
    txtFieldGarageName = nil;
    [self setTxtFieldGarageName:nil];
    txtFieldYourName = nil;
    [self setTxtFieldYourName:nil];
    txtViewAbout = nil;
    [self setTxtViewAbout:nil];
    txtFieldAnyLink = nil;
    [self setTxtFieldAnyLink:nil];
    txtFieldEmail = nil;
    [self setTxtFieldEmail:nil];
    labelEmail = nil;
    labelAbout = nil;
    labelAnyLink = nil;
    [self setLabelEmail:nil];
    [self setLabelAbout:nil];
    [self setLabelAnyLink:nil];
    labelYourName = nil;
    labelGarageName = nil;
    [self setLabelYourName:nil];
    [self setLabelGarageName:nil];
    labelCity = nil;
    labelDistrict = nil;
    labelCountry = nil;
    txtFieldAddress = nil;
    labelAddress = nil;
    txtFieldCity = nil;
    txtFieldDistrict = nil;
    txtFieldCountry = nil;
    [self setLabelAddress:nil];
    [self setLabelCity:nil];
    [self setLabelDistrict:nil];
    [self setLabelCountry:nil];
    [self setTxtFieldCity:nil];
    [self setTxtFieldDistrict:nil];
    [self setTxtFieldCountry:nil];
    [self setTxtFieldAddress:nil];
    labelCurrentPassword = nil;
    labelNewPassword = nil;
    [self setLabelCurrentPassword:nil];
    [self setLabelNewPassword:nil];
    labelRepeatPassword = nil;
    [self setLabelRepeatPassword:nil];
    txtFieldCurrentPassword = nil;
    txtFieldNewPassword = nil;
    txtFieldRepeatNewPassword = nil;
    [self setTxtFieldCurrentPassword:nil];
    [self setTxtFieldNewPassword:nil];
    [self setTxtFieldRepeatNewPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
