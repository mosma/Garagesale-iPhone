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
@synthesize labelLogin;
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
@synthesize settingsAccount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAttribsToComponents];
	// Do any additional setup after loading the view.
}

- (void)loadAttribsToComponents{
    
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];

    NSLog(@"Available Font Families: %@", [UIFont familyNames]);

    [self setupKeyboardControls];
    
    self.navigationItem.leftBarButtonItem = [GlobalFunctions getIconNavigationBar:
                                             @selector(backPage) viewContr:self imageNamed:@"btBackNav.png" rect: CGRectMake(0, 0, 40, 30)];

    NSString *nibId = [[self.navigationController visibleViewController] nibName];
    if  ([nibId rangeOfString:@"fgR-qs-ekZ"].length != 0) {//Signup ViewController
        self.scrollView.contentSize = CGSizeMake(320,700);
        self.trackedViewName = @"/newGarage";
    }else if
        ([nibId rangeOfString:@"L0X-YO-oem"].length != 0){ //Login ViewController
        self.scrollView.contentSize = CGSizeMake(320,540);
        self.trackedViewName = @"/login";
    }

    [labelSignup        setFont:[UIFont fontWithName:@"Droid Sans" size:16]];
    [labelLogin         setFont:[UIFont fontWithName:@"Droid Sans" size:16 ]];
    [labelGarageName    setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
    [labelPersonName    setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
    [labelEmail         setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
    [labelPassword      setFont:[UIFont fontWithName:@"Droid Sans" size:13]];

    [textFieldGarageName    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [textFieldPersonName    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [textFieldEmail         setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [textFieldPassword      setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [textFieldUserName      setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [textFieldUserPassword  setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    [GlobalFunctions setNavigationBarBackground:self.navigationController];
    
    [self.navigationController setNavigationBarHidden:NO];
    [textFieldUserName becomeFirstResponder];
    self.navigationItem.titleView = [GlobalFunctions getLabelTitleGaragesaleNavBar:UITextAlignmentCenter width:225];    
}

- (void)getResourcePathLogin{
    validatorFlag = 0;
    RKObjectMapping *loginMapping = [Mappings getLoginMapping];
    
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat: @"/login/?user=%@&password=%@", 
                                                  textFieldUserName.text, textFieldUserPassword.text ] objectMapping:loginMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathGarage {
    RKObjectMapping *garageMapping = [Mappings getGarageMapping];
    
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]] objectMapping:garageMapping delegate:self];
    
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathProfile {
    RKObjectMapping *prolileMapping = [Mappings getProfileMapping];
    
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@",
                                             [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"]]
                              objectMapping:prolileMapping delegate:self];
    
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objects count] > 0) {
        if ([[objects objectAtIndex:0] isKindOfClass:[Login class]]){
            [self setLogin:objects];
        }else if  ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
            [self setProfile:objects];
            [self getResourcePathGarage];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
            
            ViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            
            
            
            [self.navigationController pushViewController:home animated:YES];
            
            
            
            [self setGarage:objects];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[GarageNameValidate class]]){
            //if ([(GarageNameValidate *)[objects objectAtIndex:0] message] == @"valid")
        }else if ([[objects objectAtIndex:0] isKindOfClass:[EmailValidate class]]){
            //if ([(EmailValidate *)[objects objectAtIndex:0] message] == @"valid")
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
    if (validatorFlag == 0){
        [textFieldUserPassword setValue:[UIColor redColor]
                           forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldUserPassword setPlaceholder:@"Invalid Password or Email"];
        textFieldUserPassword.text = @"";        
    } else if (validatorFlag == 1){
        [textFieldGarageName setValue:[UIColor redColor]
                      forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldGarageName setPlaceholder:[NSString stringWithFormat:@"Hey, %@ already exist!", textFieldGarageName.text]];
        textFieldGarageName.text = @"";
    } else if (validatorFlag == 2) {
        [textFieldEmail setValue:[UIColor redColor]
                      forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldEmail setPlaceholder:@"Hey, Email already exist or not is valid!"];
        textFieldEmail.text = @"";
    }
    isLoadingDone = YES;
}

-(void)setValuesResponseToVC:(NSString *)response{
    NSDictionary *newGarageReturn = [response JSONValue];

    settingsAccount = [NSUserDefaults standardUserDefaults];
    [settingsAccount setObject:[newGarageReturn valueForKeyPath:@"session.idPerson"] forKey:@"idPerson"];
    [settingsAccount setObject:[newGarageReturn valueForKeyPath:@"session.token"] forKey:@"token"];
    [self getResourcePathProfile];
    
    [self.tabBarController setSelectedIndex:0];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    [self setEnableRegisterButton:YES];
    NSLog(@"Retrieved XML: %@", [response bodyAsString]);

    if ([request isGET]) {
        // Handling GET /foo.xml
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
    } else if ([request isPOST]) {
        isLoadingDone = YES;
        
        @try {
            [self setValuesResponseToVC:[response bodyAsString]];
        }
        @catch (NSException *exception) {
            NSLog(@"Response Not is A JSON : %@", response);
        }
        
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

-(IBAction)postNewGarage:(id)sender {
    if ([self validateFormNewGarage]) {
        
        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Garage"
                                                         withAction:@"Register"
                                                          withLabel:@"Register new Garage"
                                                          withValue:nil];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.dimBackground = YES;
        
        // Regiser for HUD callbacks so we can remove it from the window at the right time
        HUD.delegate = self;
        isLoadingDone = NO;
        
        // Show the HUD while the provided method executes in a new thread
        [HUD showWhileExecuting:@selector(waitingTask) onTarget:self withObject:nil animated:YES];

        NSMutableDictionary *garageParams = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];

        if (textFieldGarageName.text.length > 20)
            textFieldGarageName.text = [textFieldGarageName.text substringWithRange:NSMakeRange(0, 20)];
        
        //User and password params
        [garageParams setObject:@"1"                        forKey:@"idState"];
        [garageParams setObject:@"pt"                       forKey:@"lang"];
        [garageParams setObject:textFieldGarageName.text    forKey:@"garagem"];
        [garageParams setObject:textFieldPersonName.text    forKey:@"nome"];
        [garageParams setObject:textFieldEmail.text         forKey:@"email"];
        [garageParams setObject:textFieldPassword.text      forKey:@"senha"];
        [garageParams setObject:@"true"                     forKey:@"agree"];

        id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:[GlobalFunctions getMIMEType]];
        NSError *error = nil;
        NSString *json = [parser stringFromObject:garageParams error:&error];
            
        [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
        
        //If no error we send the post, voila!
        if (!error){
            //Add ProductJson in postData for key profile
            [postData setObject:json forKey:@"garage"];
        }
        
        [[[RKClient sharedClient] post:@"/garage" params:postData delegate:self] send];
    }
}

-(void)setEnableRegisterButton:(BOOL)enable{
    [buttonRegister setEnabled:enable];
    if (enable) [buttonRegister setAlpha:1.0]; else [buttonRegister setAlpha:0.3];
}

-(IBAction)getValidGarageName:(id)sender {
    [self setEnableRegisterButton:NO];
    validatorFlag = 1;
    RKObjectMapping *mapping = [Mappings getValidGarageNameMapping];
    [RKObjManeger  loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@?validate=true", textFieldGarageName.text] objectMapping:mapping delegate:self];
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

-(IBAction)getValidEmail:(id)sender {
    [self setEnableRegisterButton:NO];
    validatorFlag = 2;
    if (![GlobalFunctions isValidEmail:textFieldEmail.text]){
        [textFieldEmail setValue:[UIColor redColor]
                       forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldEmail setPlaceholder:@"Hey, this is not a valid email!"];
        textFieldEmail.text = @"";
    } else {
        RKObjectMapping *mapping = [Mappings getValidEmailMapping];
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@?validate=true", textFieldEmail.text] objectMapping:mapping delegate:self];
        [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
    }
}

-(BOOL)validateFormNewGarage{
    BOOL isValid = YES;
    
    if ([textFieldGarageName.text length] < 3) {
        [textFieldGarageName setValue:[UIColor redColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldGarageName setPlaceholder:@"Hey, this is not a valid Garage Name!"];
        isValid = NO;
    }
    
    if ([textFieldPersonName.text length] < 3) {
        [textFieldPersonName setValue:[UIColor redColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldPersonName setPlaceholder:@"Hey, this is not a valid Name!"];
        isValid = NO;
    }
    
    if ([textFieldEmail.text length] == 0) {
        [textFieldEmail setValue:[UIColor redColor]
                           forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldEmail setPlaceholder:@"Hey, Email can not be empty!"];
        isValid = NO;
    }
    
    if ([textFieldPassword.text length] < 5) {
        [textFieldPassword setValue:[UIColor redColor]
                           forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldPassword setPlaceholder:@"Hey, this is not a valid Password!"];
        isValid = NO;
    }
    
    return isValid;
}

- (void)setGarage:(NSArray *)objects{
    //Garage
    [settingsAccount setObject:[[objects objectAtIndex:0] link]           forKey:@"link"];
    [settingsAccount setObject:[[objects objectAtIndex:0] about]          forKey:@"about"];
    [settingsAccount setObject:[[objects objectAtIndex:0] country]        forKey:@"country"];
    [settingsAccount setObject:[[objects objectAtIndex:0] district]       forKey:@"district"];
    [settingsAccount setObject:[[objects objectAtIndex:0] city]           forKey:@"city"];
    [settingsAccount setObject:[[objects objectAtIndex:0] address]        forKey:@"address"];
    [settingsAccount setObject:[[objects objectAtIndex:0] localization]   forKey:@"localization"];
    [settingsAccount setObject:[[objects objectAtIndex:0] idState]        forKey:@"idState"];

    [settingsAccount synchronize];
    
    isLoadingDone = YES;
}

- (void)setProfile:(NSArray *)objects{
    //Profile
    [settingsAccount setObject:[[objects objectAtIndex:0] garagem]  forKey:@"garagem"];
    [settingsAccount setObject:[[objects objectAtIndex:0] nome]     forKey:@"nome"];
    [settingsAccount setObject:[[objects objectAtIndex:0] email]    forKey:@"email"];
    [settingsAccount setObject:[[objects objectAtIndex:0] senha]    forKey:@"senha"];
    [settingsAccount setObject:[[objects objectAtIndex:0] idRole]   forKey:@"idRole"];
    [settingsAccount setObject:[[objects objectAtIndex:0] idState]  forKey:@"idState"];
    [settingsAccount setObject:[[objects objectAtIndex:0] id]       forKey:@"id"];
    
    [settingsAccount setObject:@"YES"       forKey:@"isSettingsChange"];
    [settingsAccount setObject:@"YES"       forKey:@"isNewOrRemoveProduct"];

    NSURL *gravatar = [GlobalFunctions getGravatarURL:[[objects objectAtIndex:0] email]];
    NSData  *imageData  = [NSData dataWithContentsOfURL:gravatar];
    UIImage *image      = [[UIImage alloc] initWithData:imageData];
    
    NSData *imageData2 = [NSKeyedArchiver archivedDataWithRootObject:image];
    [settingsAccount setObject:imageData2 forKey:@"imageGravatar"];

    [settingsAccount synchronize];    
}

-(IBAction)checkLogin:(id)sender{
    [self.textFieldUserPassword resignFirstResponder];
    [self.textFieldUserName resignFirstResponder];

    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.dimBackground = YES;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	isLoadingDone = NO;
    
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(waitingTask) onTarget:self withObject:nil animated:YES];
    
    [self getResourcePathLogin];
}

-(void)waitingTask{
    while (!isLoadingDone)
        NSLog(@"isLoading");
}

-(void)setLogin:(NSArray *)objects{
    settingsAccount = [NSUserDefaults standardUserDefaults];
    [settingsAccount setObject:[[objects objectAtIndex:0] idPerson] forKey:@"idPerson"];
    [settingsAccount setObject:[[objects objectAtIndex:0] token] forKey:@"token"];
    [self getResourcePathProfile];
    
    [self.tabBarController setSelectedIndex:0];
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

    NSString *nibId = [[self.navigationController visibleViewController] nibName];
        
    if  ([nibId rangeOfString:@"fgR-qs-ekZ"].length != 0) //Signup ViewController
        self.keyboardControls.textFields = [NSArray arrayWithObjects:textFieldGarageName,
                                            textFieldPersonName,textFieldEmail,textFieldPassword,nil];
    else if  
        ([nibId rangeOfString:@"L0X-YO-oem"].length != 0) //Login ViewController
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

    rc.size.height = 383;
    
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



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:textFieldGarageName]){
        int limit = 20;
        return !([textField.text length]>limit && [string length] > range.length);
    }
    return YES;
}

#pragma mark -
#pragma mark BSKeyboardControls Delegate

/* 
 * The "Done" button was pressed
 * We want to close the keyboard
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [scrollView setContentOffset:CGPointZero animated:YES];
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

-(IBAction)textFieldEditingEnded:(id)sender{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [sender resignFirstResponder];
}

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
    labelLogin = nil;
    [self setLabelLogin:nil];
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
