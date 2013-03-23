//
//  signUpViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 05/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "signUpViewController.h"

@implementation signUpViewController

@synthesize labelSignup;
@synthesize labelLogin;
@synthesize textFieldPersonName;
@synthesize textFieldEmail;
@synthesize textFieldGarageName;
@synthesize textFieldPassword;
@synthesize buttonRegister;
@synthesize buttonLogin;
@synthesize buttonRegisterNew;
@synthesize labelGarageName;
@synthesize labelPersonName;
@synthesize labelEmail;
@synthesize labelPassword;
@synthesize scrollView;
@synthesize textFieldUserName;
@synthesize textFieldUserPassword;
@synthesize RKObjManeger;
@synthesize settingsAccount;
@synthesize secondView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    IS_IPHONE_5 ? [self.scrollView setFrame:CGRectMake(0, 64, 320, 504)] : [self.scrollView setFrame:CGRectMake(0, 64, 320, 416)];
    [self loadAttribsToComponents];
	// Do any additional setup after loading the view.
}

- (void)loadAttribsToComponents{
    
    //defining i18n
    [self.buttonRegister setTitle:NSLocalizedString(@"Register", @"") forState:UIControlStateNormal];
    [self.buttonLogin setTitle:NSLocalizedString(@"Login", @"") forState:UIControlStateNormal];
    [self.buttonRegisterNew setTitle:NSLocalizedString(@"Register", @"") forState:UIControlStateNormal];
    [buttonRecover setTitle:NSLocalizedString(@"recover-password", @"") forState:UIControlStateNormal];
    [buttonLostPassword setTitle:NSLocalizedString(@"lost-password", @"") forState:UIControlStateNormal];

    [self.labelSignup setText:NSLocalizedString(@"Sign-up", @"")];
    [self.labelLogin setText:NSLocalizedString(@"Sign-in", @"")];
    [labelPasswRecover setText:NSLocalizedString(@"recover-password", @"")];
    [self.textFieldGarageName setPlaceholder:NSLocalizedString(@"garageName", @"")];
    [self.textFieldPersonName setPlaceholder:NSLocalizedString(@"yourName", @"")];
    [self.textFieldEmail setPlaceholder:NSLocalizedString(@"yourEmail", @"")];
    [self.textFieldPassword setPlaceholder:NSLocalizedString(@"yourPassword", @"")];
    
    [self.textFieldUserName setPlaceholder:NSLocalizedString(@"loginUser", @"")];
    [self.textFieldUserPassword setPlaceholder:NSLocalizedString(@"yourPassword", @"")];
    
    //theme info
    [self.buttonRegister.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14]];
    [self.buttonLogin.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14]];
    [self.buttonRegisterNew.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14]];
    [buttonLostPassword.titleLabel setFont:[UIFont fontWithName:@"Droid Sans" size:14]];

    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];

    NSLog(@"Available Font Families: %@", [UIFont familyNames]);

    //set done at keyboard
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [numberToolbar setBarStyle:UIBarStyleBlackTranslucent];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle: NSLocalizedString(@"keyboard-cancel-btn" , nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancelSearchPad)],
                           nil];
    [numberToolbar sizeToFit];
    [txtFieldEmailRecover setInputAccessoryView:numberToolbar];
    
    [self setupKeyboardFields];
    
    self.navigationItem.leftBarButtonItem = [GlobalFunctions getIconNavigationBar:
                                             @selector(backPage) viewContr:self imageNamed:@"btBackNav.png" rect: CGRectMake(0, 0, 40, 30)];

    NSString *nibId = [[self.navigationController visibleViewController] nibName];
    if  ([nibId rangeOfString:@"fgR-qs-ekZ"].length != 0) {//Signup ViewController
        self.scrollView.contentSize = CGSizeMake(320,700);
        self.trackedViewName = @"/newGarage";
    }else if
        ([nibId rangeOfString:@"L0X-YO-oem"].length != 0){ //Login ViewController
        IS_IPHONE_5 ?   [self.secondView setFrame:CGRectMake(0, 0, 320, 811)]:
                        [self.secondView setFrame:CGRectMake(0, 0, 320, 670)];
        self.scrollView.contentSize = CGSizeMake(320,540);
        self.trackedViewName = @"/login";
    }else if
        ([nibId rangeOfString:@"SG7-S5-ObK"].length != 0){ //Recover ViewController
            IS_IPHONE_5 ?   [self.secondView setFrame:CGRectMake(0, 0, 320, 811)]:
                            [self.secondView setFrame:CGRectMake(0, 0, 320, 670)];
            self.scrollView.contentSize = CGSizeMake(320,540);
            self.trackedViewName = @"/login";
    }
    
    [labelSignup        setFont:[UIFont fontWithName:@"Droid Sans" size:16]];
    [labelLogin         setFont:[UIFont fontWithName:@"Droid Sans" size:16 ]];
    [labelPasswRecover  setFont:[UIFont fontWithName:@"Droid Sans" size:16 ]];
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
    
    vH = [[viewHelper alloc] init];
    
    [self.navigationController setNavigationBarHidden:NO];
    [textFieldUserName becomeFirstResponder];
    self.navigationItem.titleView = [GlobalFunctions getLabelTitleGaragesaleNavBar:UITextAlignmentCenter width:225];    
}

-(void)cancelSearchPad{
    [txtFieldEmailRecover resignFirstResponder];
}

- (void)getResourcePathLogin{
    flagViewControllers = 0;
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [timer invalidate];
    if ([objects count] > 0) {
        if ([[objects objectAtIndex:0] isKindOfClass:[Login class]]){
            [self setLogin:objects];
        }else if  ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
            [self setProfile:objects];
            [self getResourcePathGarage];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            homeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            [home setIsFromSignUp:YES];
            [self.navigationController pushViewController:home animated:YES];
            [self setGarage:objects];
            //reset previous viewControllers.
            self.navigationController.viewControllers = [[NSArray alloc] initWithObjects:home, nil];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[GarageNameValidate class]]){
            //if ([(GarageNameValidate *)[objects objectAtIndex:0] message] == @"valid")
        }else if ([[objects objectAtIndex:0] isKindOfClass:[EmailValidate class]]){
            //if ([(EmailValidate *)[objects objectAtIndex:0] message] == @"valid")
        }else if ([[objects objectAtIndex:0] isKindOfClass:[RecoverPassword class]]){
            if ([[[objects objectAtIndex:0] message] isEqualToString:@"true"]) {
                UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"yourPassword",nil)
                                  message:NSLocalizedString(@"form-recover-password",nil)
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
                [alert show];
                [buttonRecover setEnabled:YES];
                [txtFieldEmailRecover setText:@""];
            }
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (flagViewControllers == 0){
        [textFieldUserPassword setValue:[UIColor redColor]
                           forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldUserPassword setPlaceholder: NSLocalizedString(@"form-invalid-email-password",nil)];
        textFieldUserPassword.text = @"";        
    } else if (flagViewControllers == 1){
        [textFieldGarageName setValue:[UIColor redColor]
                      forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldGarageName setPlaceholder:[NSString stringWithFormat: NSLocalizedString( @"form-invalid-email-exists",nil), textFieldGarageName.text]];
        textFieldGarageName.text = @"";
    } else if (flagViewControllers == 2) {
        [textFieldEmail setValue:[UIColor redColor]
                      forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldEmail setPlaceholder: NSLocalizedString(@"form-invalid-email-or-invalid",nil)];
        textFieldEmail.text = @"";
    } else if (flagViewControllers == 3) {
        [buttonRecover setEnabled:YES];
        [txtFieldEmailRecover setValue:[UIColor redColor]
                            forKeyPath:@"_placeholderLabel.textColor"];
        [txtFieldEmailRecover setPlaceholder: NSLocalizedString(@"form-invalid-email", nil)];
        txtFieldEmailRecover.text = @"";
    }
    [timer invalidate];
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
    [timer invalidate];
    NSLog(@"Retrieved XML: %@", [response bodyAsString]);

    if ([request isGET]) {
        // Handling GET /foo.xml
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
    } else if ([request isPOST]) {
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
        
        timer = [NSTimer scheduledTimerWithTimeInterval:45.0 target:self selector:@selector(cancelRequest) userInfo:nil repeats:NO];
    }
}

-(void)setEnableRegisterButton:(BOOL)enable{
    [buttonRegister setEnabled:enable];
    if (enable) [buttonRegister setAlpha:1.0]; else [buttonRegister setAlpha:0.3];
}

-(IBAction)getValidGarageName:(id)sender {
    [self setEnableRegisterButton:NO];
    flagViewControllers = 1;
    RKObjectMapping *mapping = [Mappings getValidGarageNameMapping];
    [RKObjManeger  loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@?validate=true", textFieldGarageName.text] objectMapping:mapping delegate:self];
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(IBAction)recoverPassword:(id)sender {
    if (![GlobalFunctions isValidEmail:txtFieldEmailRecover.text]){
        [txtFieldEmailRecover setValue:[UIColor redColor]
                      forKeyPath:@"_placeholderLabel.textColor"];
        [txtFieldEmailRecover setPlaceholder: NSLocalizedString(@"form-invalid-email", nil)];
        txtFieldEmailRecover.text = @"";
    } else {
        flagViewControllers = 3;
        [buttonRecover setEnabled:NO];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [txtFieldEmailRecover resignFirstResponder];
        RKObjectMapping *mapping = [Mappings getRecoverPassword];
        [RKObjManeger  loadObjectsAtResourcePath:[NSString stringWithFormat:@"/login/recover?email=%@", txtFieldEmailRecover.text] objectMapping:mapping delegate:self];
        [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
    }
}

-(IBAction)getValidEmail:(id)sender {
    [self setEnableRegisterButton:NO];
    flagViewControllers = 2;
    if (![GlobalFunctions isValidEmail:textFieldEmail.text]){
        [textFieldEmail setValue:[UIColor redColor]
                       forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldEmail setPlaceholder: NSLocalizedString(@"form-invalid-email", nil)];
        textFieldEmail.text = @"";
    } else {
        RKObjectMapping *mapping = [Mappings getValidEmailMapping];
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@?validate=true", textFieldEmail.text] objectMapping:mapping delegate:self];
        [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

-(BOOL)validateFormNewGarage{
    BOOL isValid = YES;
    
    if ([textFieldGarageName.text length] < 3) {
        [textFieldGarageName setValue:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                     forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldGarageName setPlaceholder: NSLocalizedString(@"form-invalid-garage-name", nil)];
        isValid = NO;
    }
    
    if ([textFieldPersonName.text length] < 3) {
        [textFieldPersonName setValue:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                     forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldPersonName setPlaceholder: NSLocalizedString(@"form-invalid-name", nil)];
        isValid = NO;
    }
    
    if ([textFieldEmail.text length] == 0) {
        [textFieldEmail setValue:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                           forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldEmail setPlaceholder: NSLocalizedString(@"form-empty-email", nil)];
        isValid = NO;
    }
    
    if ([textFieldPassword.text length] < 5) {
        [textFieldPassword setValue:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                           forKeyPath:@"_placeholderLabel.textColor"];
        [textFieldPassword setPlaceholder: NSLocalizedString(@"form-invalid-password", nil)];
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
    [settingsAccount setObject:@"YES"       forKey:@"reloadGarage"];

    NSString *avatarName = [NSString stringWithFormat:@"%@_AvatarImg",
                            [[objects objectAtIndex:0] garagem]];
    vH.avatarName = avatarName;
    [vH getGarageAvatar:objects];
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
    
    timer = [NSTimer scheduledTimerWithTimeInterval:45.0 target:self selector:@selector(cancelRequest) userInfo:nil repeats:NO];
    
    [self getResourcePathLogin];
}

-(void)waitingTask{
    while (!isLoadingDone)
        NSLog(@"isLoading");
    [timer invalidate];
}

-(void)cancelRequest{
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconDeletePicsAtGalleryProdAcc.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = NSLocalizedString(@"image-upload-error-check", nil);
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(finished) userInfo:nil repeats:NO];
}

-(void)finished{
    isLoadingDone = YES;
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
- (void)setupKeyboardFields
{
    NSString *nibId = [[self.navigationController visibleViewController] nibName];
    if  ([nibId rangeOfString:@"fgR-qs-ekZ"].length != 0) //Signup ViewController
        keyboardControls.textFields = [NSArray arrayWithObjects:textFieldGarageName,
                                            textFieldPersonName,textFieldEmail,textFieldPassword,nil];
    else if  
        ([nibId rangeOfString:@"L0X-YO-oem"].length != 0) //Login ViewController
        keyboardControls.textFields = [NSArray arrayWithObjects:textFieldUserName,
                                            textFieldUserPassword,nil];
    [super addKeyboardControlsAtFields];
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

/* 
 * The "Done" button was pressed
 * We want to close the keyboard
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [controls.activeTextField resignFirstResponder];
}

#pragma mark -
#pragma mark UITextField Delegate

/* Editing began */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([keyboardControls.textFields containsObject:textField])
        keyboardControls.activeTextField = textField;
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
    txtFieldEmailRecover = nil;
    labelPasswRecover = nil;
    buttonRecover = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
