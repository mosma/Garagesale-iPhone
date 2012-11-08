//
//  settingsAccountViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "settingsAccountViewController.h"
#import "Profile.h"

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
@synthesize settingsAccount;

@synthesize RKObjManeger;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    //Set SerializationMIMEType
    RKObjManeger.acceptMIMEType          = RKMIMETypeJSON;
    RKObjManeger.serializationMIMEType   = RKMIMETypeJSON;
}

- (void)loadAttribsToComponents{

    nibId = [[self.navigationController visibleViewController] nibName];
    
    if  ([nibId rangeOfString:@"5xi-Kh-5i5"].length != 0) { //Account ViewController{
        self.navigationItem.titleView = [GlobalFunctions getLabelTitleNavBarGeneric:
                                         UITextAlignmentCenter text:@"Account" width:210];
        self.scrollView.contentSize = CGSizeMake(320,700);
    } else if
        ([nibId rangeOfString:@"tbg-8m-otZ"].length != 0) { //Address ViewController
        self.navigationItem.titleView = [GlobalFunctions getLabelTitleNavBarGeneric:
                                         UITextAlignmentCenter text:@"Address" width:210];
        self.scrollView.contentSize = CGSizeMake(320,585);
    }else if
        ([nibId rangeOfString:@"K7a-eB-FnT"].length != 0) { //Password ViewController
        self.navigationItem.titleView = [GlobalFunctions getLabelTitleNavBarGeneric:
                                         UITextAlignmentCenter text:@"Password" width:210];
        self.scrollView.contentSize = CGSizeMake(320,525);
    }
    //Password ViewController
    labelCurrentPassword.font   = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelNewPassword.font       = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelRepeatPassword.font    = [UIFont fontWithName:@"Droid Sans" size:13 ];
    
    [txtFieldCurrentPassword    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldNewPassword        setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldRepeatNewPassword  setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    txtFieldCurrentPassword.text = [[GlobalFunctions getUserDefaults] objectForKey:@"senha"];
    
    //Address ViewController
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
    
    //Account ViewController
    labelGarageName.font    = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelEmail.font         = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelAbout.font         = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelYourName.font      = [UIFont fontWithName:@"Droid Sans" size:13 ];
    
    [txtFieldGarageName setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldYourName   setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtViewAbout       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldEmail      setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldAnyLink    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    txtFieldGarageName.placeholder = [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"];
    txtFieldYourName.text   = [[GlobalFunctions getUserDefaults] objectForKey:@"nome"];
    txtViewAbout.text       = [[GlobalFunctions getUserDefaults] objectForKey:@"about"];
    txtFieldEmail.placeholder = [[GlobalFunctions getUserDefaults] objectForKey:@"email"];
    txtFieldAnyLink.text    = [[GlobalFunctions getUserDefaults] objectForKey:@"link"];
    
    
    garageName.font        = [UIFont fontWithName:@"DroidSans-Bold" size:22 ];
    
    city.font              = [UIFont fontWithName:@"Droid Sans" size:12 ];
    [city setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
    
    garageName.text  = [[GlobalFunctions getUserDefaults] objectForKey:@"nome"];
    city.text        = [NSString stringWithFormat:@"%@, %@, %@",
                        [[GlobalFunctions getUserDefaults] objectForKey:@"city"],
                        [[GlobalFunctions getUserDefaults] objectForKey:@"district"],
                        [[GlobalFunctions getUserDefaults] objectForKey:@"country"]];
    
    imageView.image  = [UIImage imageWithData: [NSData dataWithContentsOfURL:[GlobalFunctions getGravatarURL:[[GlobalFunctions getUserDefaults] objectForKey:@"email"]]]];
    
    

    self.navigationItem.leftBarButtonItem = [GlobalFunctions getIconNavigationBar:
                                             @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];
    [self setupKeyboardControls];
}

- (void)getResourcePathGarage {
    RKObjectMapping *garageMapping = [Mappings getGarageMapping];
    
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@",
                                             [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]]
                              objectMapping:garageMapping delegate:self];
    
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathProfile {
    RKObjectMapping *profileMapping = [Mappings getProfileMapping];
    
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@",
                                             [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"]]
                              objectMapping:profileMapping delegate:self];
    
    
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if  ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
        [self setProfile:objects];
        [self getResourcePathGarage];
    }else if ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
        [self setGarage:objects];
    }
}

-(IBAction)saveSettings{
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *prodParams = [[NSMutableDictionary alloc] init];
    
    NSString *idPerson = [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"];
    [prodParams setObject:txtFieldGarageName != nil ? txtFieldGarageName.placeholder : [[GlobalFunctions getUserDefaults]
                                                                                        objectForKey:@"garagem"]  forKey:@"garagem"];
    [prodParams setObject:txtFieldCurrentPassword   != nil ? txtFieldCurrentPassword.text :        @""          forKey:@"oldPassword"];
    [prodParams setObject:txtFieldNewPassword       != nil ? txtFieldNewPassword.text :            @""          forKey:@"newPassword"];
    [prodParams setObject:txtFieldRepeatNewPassword != nil ? txtFieldRepeatNewPassword.text :      @""          forKey:@"newPassword2"];
    [prodParams setObject:txtFieldYourName          != nil ? txtFieldYourName.text :[[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"nome"]     forKey:@"nome"];
    [prodParams setObject:txtFieldEmail             != nil ? txtFieldEmail.placeholder : [[GlobalFunctions getUserDefaults]
                                                                                          objectForKey:@"email"]    forKey:@"email"];
    [prodParams setObject:txtViewAbout              != nil ? txtViewAbout.text :    [[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"about"]    forKey:@"about"];
    [prodParams setObject:txtFieldAnyLink           != nil ? txtFieldAnyLink.text : [[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"link"]     forKey:@"link"];
    [prodParams setObject:txtFieldAddress           != nil ? txtFieldAddress.text : [[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"address"]   forKey:@"address"];
    [prodParams setObject:txtFieldCity              != nil ? txtFieldCity.text :    [[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"city"]     forKey:@"city"];
    [prodParams setObject:txtFieldCountry           != nil ? txtFieldCountry.text : [[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"country"]   forKey:@"country"];
    [prodParams setObject:txtFieldDistrict          != nil ? txtFieldDistrict.text :[[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"district"] forKey:@"district"];
    [prodParams setObject:@""                               forKey:@"idState"];
    [prodParams setObject:@""                               forKey:@"lang"];
    [prodParams setObject:@""                               forKey:@"localization"];
    
    //The server ask me for this format, so I set it here:
    [postData setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"] forKey:@"token"];
    [postData setObject:idPerson              forKey:@"idUser"];
    
    //Parsing prodParams to JSON!
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:[GlobalFunctions getMIMEType]];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:prodParams error:&error];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
    
    //If no error we send the post, voila!
    if (!error){
        
        //Add ProductJson in postData for key profile
        [postData setObject:json forKey:@"profile"];
        [[[RKClient sharedClient] post:[NSString stringWithFormat:@"/profile/%i/?XDEBUG_SESSION_START=ECLIPSE_DBGP&KEY=13488512403312", 6]  params:postData delegate:self] send];
        [postData setObject:json forKey:@"garage"];
        [[[RKClient sharedClient] post:@"/garage/turcoloco/?XDEBUG_SESSION_START=ECLIPSE_DBGP&KEY=13488512403312" params:postData delegate:self] send];
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Set determinate mode
	HUD.mode = MBProgressHUDModeAnnularDeterminate;
	
    HUD. center = CGPointMake(0, 0);
    
    HUD.labelFont = [UIFont fontWithName:@"Droid Sans" size:14];
	HUD.delegate = self;
	HUD.labelText = @"Saving";
	HUD.color = [UIColor colorWithRed:219.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
    HUD.dimBackground = YES;
    
	[HUD showWhileExecuting:@selector(resultProgress) onTarget:self withObject:nil animated:YES];
}

- (void)getResourcePathLogOut{
    [[[RKClient sharedClient] delete:[NSString stringWithFormat:@"/login/%@", [[GlobalFunctions getUserDefaults] objectForKey:@"token"]] delegate:self] send];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
        
    } else if ([request isPOST]) {
        
        [self getResourcePathProfile];
        isSaved = YES;
        NSLog(@"after posting to server, %@", [response bodyAsString]);
        
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isPUT]) {
        NSLog(@"after posting to server, %@", [response bodyAsString]);
        
    } else if ([request isDELETE]) {
        // Handling DELETE /missing_resource.txt
        NSLog(@"DELETE Response : %@", [response bodyAsString]);
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}


/**
 * Sent when a request has failed due to an error
 */
- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    isSaved = NO;
}


-(void)logout:(id)sender{
    /*
     Reset Token... Colocar isso no globalfuncionts
     */
    
    [self getResourcePathLogOut];
    
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
    
    NSInteger i;
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        
        NSLog(@"quantidade : %i", i++);
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    for (UIViewController *vc in self.tabBarController.viewControllers)
    {
//        UIViewController *vc = v;
//        if ([vc isKindOfClass:[ViewController class]])
//        {
//            [vc.navigationController popToRootViewControllerAnimated:YES];
//        }
//        
//        if ([vc isKindOfClass:[productDetailViewController class]])
//        {
//            [vc.navigationController popToRootViewControllerAnimated:YES];
//        }
//        
//        if ([vc isKindOfClass:[garageAccountViewController class]])
//        {
//            [[(garageAccountViewController *)vc mutArrayProducts] removeAllObjects];
//        }
      //  vc.view = nil;
       // [vc viewDidLoad];
    
    }
    
    [[[[self.tabBarController.viewControllers objectAtIndex:0] visibleViewController]
      navigationController] popToRootViewControllerAnimated:YES];
    
    self.tabBarController.selectedIndex = 0;
    
    [[[[self.tabBarController.viewControllers objectAtIndex:2] visibleViewController]
      navigationController] popToRootViewControllerAnimated:NO];
    
    [[[self.tabBarController.viewControllers objectAtIndex:1] visibleViewController] viewDidLoad];
    
    [[self.tabBarController.viewControllers objectAtIndex:1] visibleViewController].view = nil;
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.keyboardControls.textFields containsObject:textField])
        self.keyboardControls.activeTextField = textField;
    [self scrollViewToTextField:textField];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.keyboardControls.textFields containsObject:textView])
        self.keyboardControls.activeTextField = textView;
    [self scrollViewToTextField:textView];
}

-(IBAction)textFieldEditingEnded:(id)sender{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [sender resignFirstResponder];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
    if (indexOfTab == 1 && ![[[GlobalFunctions getUserDefaults] objectForKey:@"isProductDisplayed"] boolValue]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Camera", @"Library", @"Produto Sem Foto", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        sheet.delegate = self;
        [sheet showFromTabBar:self.tabBarController.tabBar];
        return NO;
    } else {
        return YES;
    }
}

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    [GlobalFunctions setActionSheetAddProduct:self.tabBarController clickedButtonAtIndex:buttonIndex];
//}

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
}

- (void)setProfile:(NSArray *)objects{
    //Profile
    settingsAccount = [NSUserDefaults standardUserDefaults];
    [settingsAccount setObject:[[objects objectAtIndex:0] garagem]  forKey:@"garagem"];
    [settingsAccount setObject:[[objects objectAtIndex:0] nome]     forKey:@"nome"];
    [settingsAccount setObject:[[objects objectAtIndex:0] email]    forKey:@"email"];
    [settingsAccount setObject:[[objects objectAtIndex:0] senha]    forKey:@"senha"];
    [settingsAccount setObject:[[objects objectAtIndex:0] idRole]   forKey:@"idRole"];
    [settingsAccount setObject:[[objects objectAtIndex:0] idState]  forKey:@"idState"];
    [settingsAccount setObject:[[objects objectAtIndex:0] id]       forKey:@"id"];
}

- (void)resultProgress{
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(10000);
	}
    HUD.mode = MBProgressHUDModeCustomView;
    if (isSaved) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.labelText = @"Completed";
    }else{
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconDeletePicsAtGalleryProdAcc.png"]];
        HUD.labelText = @"Fail! Check your connection.";
    }
    sleep(2);
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
        
    if  ([nibId rangeOfString:@"5xi-Kh-5i5"].length != 0) //Account ViewController
        self.keyboardControls.textFields = [NSArray arrayWithObjects: txtFieldYourName, txtViewAbout, txtFieldAnyLink, nil];
    else if  
        ([nibId rangeOfString:@"tbg-8m-otZ"].length != 0) //Address ViewController
        self.keyboardControls.textFields = [NSArray arrayWithObjects: txtFieldAddress, txtFieldCity, txtFieldDistrict, txtFieldCountry, nil];
    else if  
        ([nibId rangeOfString:@"K7a-eB-FnT"].length != 0) //Password ViewController
        self.keyboardControls.textFields = [NSArray arrayWithObjects: txtFieldCurrentPassword, txtFieldNewPassword, txtFieldRepeatNewPassword, nil];
    
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
    //rc.origin.y = 0;
    
    rc.size.height = 340;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([[[GlobalFunctions getUserDefaults] objectForKey:@"isProductRecorded"] isEqual:@"YES"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self loadAttribsToComponents];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
