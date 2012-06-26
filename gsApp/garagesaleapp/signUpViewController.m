//
//  signUpViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 05/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "signUpViewController.h"

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
@synthesize RKObjManeger;
@synthesize activityLogin;
@synthesize arrayGarage;
@synthesize arrayProfile;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAttributs];
	// Do any additional setup after loading the view.
}

-(void)loadAttributs{
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];

    NSLog(@"Available Font Families: %@", [UIFont familyNames]);

    [self setupKeyboardControls];
    
    self.scrollView.contentSize             = CGSizeMake(320,650);

    self.navigationItem.leftBarButtonItem = [GlobalFunctions getIconNavigationBar:
                                             @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];

    labelSignup.font        = [UIFont fontWithName:@"Droid Sans" size:16 ];
    labelGarageName.font    = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelPersonName.font    = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelEmail.font         = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelPassword.font      = [UIFont fontWithName:@"Droid Sans" size:13 ];

    [GlobalFunctions setTextFieldForm:textFieldGarageName];
    [GlobalFunctions setTextFieldForm:textFieldPersonName];
    [GlobalFunctions setTextFieldForm:textFieldEmail];
    [GlobalFunctions setTextFieldForm:textFieldPassword];
    [GlobalFunctions setTextFieldForm:textFieldUserName];
    [GlobalFunctions setTextFieldForm:textFieldUserPassword];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationItem.titleView = [GlobalFunctions getLabelTitleGaragesaleNavBar:UITextAlignmentCenter width:225];

}

- (void)setupLogin{
    //Configure Product Object Mapping
    RKObjectMapping *loginMapping = [RKObjectMapping mappingForClass:[Login class]];    
    [loginMapping mapKeyPath:@"idPerson"          toAttribute:@"idPerson"];
    [loginMapping mapKeyPath:@"token"     toAttribute:@"token"];
    
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat: @"/login/?user=%@&password=%@", 
                                                  textFieldUserName.text, textFieldUserPassword.text ] objectMapping:loginMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
}

- (void)setGarage:(NSArray *)objects{
    //Garage
    NSUserDefaults *loginDefaults = [NSUserDefaults standardUserDefaults];
    [loginDefaults setObject:[[objects objectAtIndex:0] link] forKey:@"link"];
    [loginDefaults setObject:[[objects objectAtIndex:0] about] forKey:@"about"];
    [loginDefaults setObject:[[objects objectAtIndex:0] country] forKey:@"country"];
    [loginDefaults setObject:[[objects objectAtIndex:0] district] forKey:@"district"];
    [loginDefaults setObject:[[objects objectAtIndex:0] city] forKey:@"city"];
    [loginDefaults setObject:[[objects objectAtIndex:0] address] forKey:@"address"];
    [loginDefaults setObject:[[objects objectAtIndex:0] localization] forKey:@"localization"];
    [loginDefaults setObject:[[objects objectAtIndex:0] idState] forKey:@"idState"];
    [loginDefaults synchronize];
    [activityLogin stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setProfile:(NSArray *)objects{
    //Profile
    NSUserDefaults *loginDefaults = [NSUserDefaults standardUserDefaults];
    [loginDefaults setObject:[[objects objectAtIndex:0] garagem] forKey:@"garagem"];
    [loginDefaults setObject:[[objects objectAtIndex:0] nome] forKey:@"nameProfile"];
    [loginDefaults setObject:[[objects objectAtIndex:0] email] forKey:@"email"];
    [loginDefaults setObject:[[objects objectAtIndex:0] senha] forKey:@"senha"];
    //Garage
    [loginDefaults synchronize];
}

- (void)setupGarageMapping {
    //Configure Garage Object Mapping
    RKObjectMapping *garageMapping = [RKObjectMapping mappingForClass:[Garage class]];    
    [garageMapping mapKeyPath:@"link"           toAttribute:@"link"];
    [garageMapping mapKeyPath:@"about"          toAttribute:@"about"];
    [garageMapping mapKeyPath:@"country"        toAttribute:@"country"];
    [garageMapping mapKeyPath:@"district"       toAttribute:@"district"];
    [garageMapping mapKeyPath:@"city"           toAttribute:@"city"];
    [garageMapping mapKeyPath:@"address"        toAttribute:@"address"];
    [garageMapping mapKeyPath:@"localization"   toAttribute:@"localization"];
    [garageMapping mapKeyPath:@"idState"        toAttribute:@"idState"];
    [garageMapping mapKeyPath:@"idPerson"       toAttribute:@"idPerson"];
    [garageMapping mapKeyPath:@"id"             toAttribute:@"id"];
    
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", [[self.arrayProfile objectAtIndex:0] garagem]] 
                                  objectMapping:garageMapping delegate:self];

    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];  
}

- (void)setupProfileMapping {
    //Configure Profile Object Mapping
    RKObjectMapping *prolileMapping = [RKObjectMapping mappingForClass:[Profile class]];    
    [prolileMapping mapKeyPath:@"garagem"   toAttribute:@"garagem"];
    [prolileMapping mapKeyPath:@"senha"     toAttribute:@"senha"];
    [prolileMapping mapKeyPath:@"nome"      toAttribute:@"nome"];
    [prolileMapping mapKeyPath:@"email"     toAttribute:@"email"];
    [prolileMapping mapKeyPath:@"idRole"    toAttribute:@"idRole"];    
    [prolileMapping mapKeyPath:@"idState"   toAttribute:@"idState"];
    [prolileMapping mapKeyPath:@"id"        toAttribute:@"id"];

    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", 
                                            [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"]] 
                                  objectMapping:prolileMapping delegate:self];

    
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];  
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objects count] > 0) {
        if ([[objects objectAtIndex:0] isKindOfClass:[Login class]]){
            [self setUserDefaults:objects];
        }else if  ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
            self.arrayProfile = objects;
            [self setProfile:objects];
            [self setupGarageMapping];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
            self.arrayGarage = objects;
            [self setGarage:objects];
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
    
   //if ([objectLoader isKindOfClass:[Login class]]){
      UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error Login"
                                                      message:@"check your values."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [message show];
      [activityLogin stopAnimating];
    //}
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    if ([request isGET]) {
        // Handling GET /foo.xml
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
    } else if ([request isPOST]) {
        
        // Handling POST /other.json        
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

-(IBAction)checkLogin:(id)sender{
    [activityLogin startAnimating];
    [self setupLogin];
}

-(void)setUserDefaults:(NSArray *)objects{
    NSUserDefaults *loginDefaults = [NSUserDefaults standardUserDefaults];
    [loginDefaults setObject:[[objects objectAtIndex:0] idPerson] forKey:@"idPerson"];
    [loginDefaults setObject:[[objects objectAtIndex:0] token] forKey:@"token"];
    [loginDefaults synchronize];
    [self setupProfileMapping];
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
    
    if([self.title isEqualToString:@"SignUp"])
        self.keyboardControls.textFields = [NSArray arrayWithObjects:textFieldGarageName,
                                            textFieldPersonName,textFieldEmail,textFieldPassword,nil];
    else
        self.keyboardControls.textFields = [NSArray arrayWithObjects:textFieldUserName,
                                            textFieldUserPassword,nil];

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
    
    
    if (textFieldGarageName.isEditing)
        rc.origin.x = -400 ;
    else 
        rc.origin.x = 0 ;
    
    rc.origin.y = 0 ;
    
    if([self.title isEqualToString:@"SignUp"]){
        if (textFieldPersonName.isEditing)
            rc.size.height = 500;
        else
            rc.size.height = 700;
    }
    else
        rc.size.height = 500;
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
    activityLogin = nil;
    [self setActivityLogin:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
