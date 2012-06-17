//
//  signUpViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 05/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "signUpViewController.h"
#import "NSAttributedString+Attributes.h"

@interface signUpViewController ()
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
- (void)setupKeyboardControls;
- (void)scrollViewToTextField:(id)textField;
@end

@implementation signUpViewController
@synthesize labelSignup;
@synthesize textFieldPersonName;
@synthesize textFieldEmail;
@synthesize textFieldGarageName;
@synthesize textFieldPassword;
@synthesize buttonRegister;
@synthesize labelGarageName;
@synthesize labelPersonName;
@synthesize labelEmail;
@synthesize labelPassword;
@synthesize scrollView;
@synthesize keyboardControls;
@synthesize textFieldUserName;
@synthesize textFieldUserPassword;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAttributs];
	// Do any additional setup after loading the view.
}

-(void)loadAttributs{
    NSLog(@"Available Font Families: %@", [UIFont familyNames]);

    [self setupKeyboardControls];
    
    self.scrollView.contentSize             = CGSizeMake(320,650);

    self.navigationItem.leftBarButtonItem = [GlobalFunctions getIconNavigationBar:
                                             @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];

    labelSignup.font        = [UIFont fontWithName:@"Droid Sans" size:16 ];
    labelGarageName.font    = [UIFont fontWithName:@"Droid Sans" size:14 ];
    labelPersonName.font    = [UIFont fontWithName:@"Droid Sans" size:14 ];
    labelEmail.font         = [UIFont fontWithName:@"Droid Sans" size:14 ];
    labelPassword.font      = [UIFont fontWithName:@"Droid Sans" size:14 ];

    [GlobalFunctions setTextFieldForm:textFieldGarageName];
    [GlobalFunctions setTextFieldForm:textFieldPersonName];
    [GlobalFunctions setTextFieldForm:textFieldEmail];
    [GlobalFunctions setTextFieldForm:textFieldPassword];
    [GlobalFunctions setTextFieldForm:textFieldUserName];
    [GlobalFunctions setTextFieldForm:textFieldUserPassword];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    /* 
     set Navigation Title with OHAttributeLabel
     */
    NSString *titleNavItem = @"Garagesaleapp";
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:titleNavItem];
    [attrStr setFont:[UIFont fontWithName:@"Corben" size:17]];
    [attrStr setTextColor:[UIColor whiteColor]];
    [attrStr setTextColor:[UIColor colorWithRed:244.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.f]
                    range:[titleNavItem rangeOfString:@"app"]];
    
    [attrStr setFont:[UIFont fontWithName:@"Corben" size:15] range:[titleNavItem rangeOfString:@"app"]];
    
    CGRect frame = CGRectMake(0, 0, 200, 44);
    OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setShadowColor:[UIColor redColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    label.attributedText = attrStr;
    label.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    
    
    
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
    self.keyboardControls.textFields = [NSArray arrayWithObjects:textFieldGarageName,
                                        textFieldPersonName,textFieldEmail,textFieldPassword,nil];
    
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
    rc.origin.x = 0 ;
    rc.origin.y = 0 ;
    
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

#pragma mark -
#pragma mark UITextField Delegate

/* Editing began */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.keyboardControls.textFields containsObject:textField])
        self.keyboardControls.activeTextField = textField;
    [self scrollViewToTextField:textField];
}

#pragma mark -
#pragma mark UITextView Delegate

/* Editing began */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.keyboardControls.textFields containsObject:textView])
        self.keyboardControls.activeTextField = textView;
    [self scrollViewToTextField:textView];
}

-(IBAction)textFieldEditingEnded:(id)sender{
    [sender resignFirstResponder];
}
/* 
 *
 End Setup the keyboard controls 
 *
 */


- (void)viewDidUnload
{
    [self setTextFieldGarageName:nil];
    [self setTextFieldPersonName:nil];
    [self setTextFieldEmail:nil];
    textFieldPassword = nil;
    [self setTextFieldPassword:nil];
    buttonRegister = nil;
    [self setButtonRegister:nil];
    labelGarageName = nil;
    labelPersonName = nil;
    labelEmail = nil;
    labelPassword = nil;
    [self setLabelGarageName:nil];
    [self setLabelPersonName:nil];
    [self setLabelEmail:nil];
    [self setLabelPassword:nil];
    labelSignup = nil;
    [self setLabelSignup:nil];
    scrollView = nil;
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
