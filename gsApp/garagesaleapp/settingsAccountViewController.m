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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAttribsToComponents];
}

- (void)loadAttribsToComponents{
    
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
    
    
    garageName.font        = [UIFont fontWithName:@"Droid Sans" size:22 ];
    
    city.font              = [UIFont fontWithName:@"Droid Sans" size:12 ];
    [city setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
    
    garageName.text  = [[GlobalFunctions getUserDefaults] objectForKey:@"nome"];
    city.text        = [NSString stringWithFormat:@"%@, %@, %@",
                        [[GlobalFunctions getUserDefaults] objectForKey:@"city"],
                        [[GlobalFunctions getUserDefaults] objectForKey:@"district"],
                        [[GlobalFunctions getUserDefaults] objectForKey:@"country"]];

    imageView.image  = [UIImage imageWithData: [NSData dataWithContentsOfURL:[GlobalFunctions getGravatarURL:[[GlobalFunctions getUserDefaults] objectForKey:@"email"]]]];

    
    self.scrollView.contentSize = CGSizeMake(320,700);
    self.navigationItem.leftBarButtonItem = [GlobalFunctions getIconNavigationBar:
                                             @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];
    
    //[self.navigationItem.titleView addSubview:[GlobalFunctions getLabelTitleNavBarGeneric:UITextAlignmentCenter width:300]];
    
    [self setupKeyboardControls];
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)saveSettings{
    
    
    
    //    
    //    @"garagem", @"garagem",
    //    @"senha", @"senha",
    //    @"nome", @"nome",
    //    @"email", @"email",
    //    @"idRole", @"idRole",
    //    @"idState", @"idState",
    //    @"id", @"id",
    //    
    //    @"link", @"link",
    //    @"about", @"about",
    //    @"country", @"country",
    //    @"district", @"district",
    //    @"city", @"city",
    //    @"address", @"address",
    //    @"localization", @"localization",
    //    @"idState", @"idState",
    //    @"idPerson", @"idPerson",
    //    @"id", @"id",
    //    

    
    
    
    
    //   NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *profileParams = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary *garageParams = [[NSMutableDictionary alloc] init];
//    
//    NSNumber *idPerson = [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"];
//    
//    [profileParams setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"] forKey:@"token"];
//    [profileParams setObject:idPerson               forKey:@"id"];
//    [profileParams setObject:txtFieldYourName.text  forKey:@"nome"];
//    
//    //[garageParams setObject:idPerson               forKey:@"id"];
//    //[garageParams setObject:txtFieldAnyLink.text   forKey:@"link"];
//    //[garageParams setObject:txtViewAbout.text      forKey:@"about"];
//    
//
//    
//    
//    Profile* contact2 = [[Profile alloc] init];
//    contact2.nome = txtFieldYourName.text;
//    contact2.id     = idPerson;
//    
//    [RKObjManeger putObject:contact2 delegate:self];
    
    
    
    
    
    
    
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *prodParams = [[NSMutableDictionary alloc] init];
    
    //User and password params
   // NSString *idPerson = [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"];
    [prodParams setObject:@"6"               forKey:@"id"];
    [prodParams setObject:txtFieldYourName.text  forKey:@"nome"];

   // [prodParams setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"]  forKey:@"token"];

    
    //The server ask me for this format, so I set it here:
    //[postData setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"] forKey:@"token"];
   // [postData setObject:idPerson              forKey:@"idUser"];
    
    //Parsing prodParams to JSON! 
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:@"text/html"];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:prodParams error:&error];    
    
    //Add ProductJson in postData for key product
    [postData setObject:json forKey:@"profile"];
    [postData setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"] forKey:@"token"];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    //If no error we send the post, voila!
    if (!error){
        //[[[RKClient sharedClient] put:[NSString stringWithFormat:@"/profile/%@", idPerson] params:postData delegate:self] send];
        [[[RKClient sharedClient] put:@"/profile/6/?XDEBUG_SESSION_START=ECLIPSE_DBGP&KEY=13448609458521" params:postData delegate:self] send];

    }
    
    


//    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
//
//    
//    RKObjManeger.acceptMIMEType = RKMIMETypeJSON;
//    RKObjManeger.serializationMIMEType = RKMIMETypeJSON; 
//    
//    
//    //Post Bid Sent
//    RKObjectMapping *patientSerializationMapping = [RKObjectMapping mappingForClass:[Profile class]];
//    [patientSerializationMapping mapKeyPath:@"nome"      toAttribute:@"nome"];
//    [patientSerializationMapping mapKeyPath:@"id"      toAttribute:@"id"];
//    [patientSerializationMapping mapKeyPath:@"iooioii" toAttribute:@"token"];
//
//    
//    [[RKObjManeger router] routeClass:[Profile class] toResourcePath:@"/profile/6/?XDEBUG_SESSION_START=ECLIPSE_DBGP&KEY=13448609458521"];
//    
//    [RKObjManeger.mappingProvider setSerializationMapping:[patientSerializationMapping inverseMapping] forClass:[Profile class]];    
//    
//    //Setting Bid Entity
//    Profile* bid = [[Profile alloc] init];  
//    bid.nome = txtFieldYourName.text;  
//    bid.id = [NSNumber numberWithInt:6];
//    
//    
//    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
//
//    [postData setObject:bid forKey:@"profile"];
//    [postData setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"] forKey:@"token"];
    
    
    // POST bid  
//        [RKObjManeger putObject:bid delegate:self];
    
    
    
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Set determinate mode
	HUD.mode = MBProgressHUDModeAnnularDeterminate;
	
    
    HUD.labelFont = [UIFont fontWithName:@"Droid Sans" size:14];
	HUD.delegate = self;
	HUD.labelText = @"Saving";
	HUD.color = [UIColor colorWithRed:219.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
    HUD.dimBackground = YES;
    
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];

    
    
    

    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"");
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
        
        
        NSLog(@"after posting to server, %@", [response bodyAsString]);
        
        //        NSError *error = nil;
        //        RKJSONParserJSONKit *parser = [RKJSONParserJSONKit new]; 
        //        NSDictionary *dictProduct = [parser objectFromString:[response bodyAsString] error:&error];
        
//        if (!isPostProduct) {
//            [self postProduct];
//            isPostProduct = !isPostProduct;
//        }else 
//            isPostProduct = !isPostProduct;
        
        // Handling POST /other.json        
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isPUT]) {
            NSLog(@"after posting to server, %@", [response bodyAsString]);

    } else if ([request isDELETE]) {
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}


- (void)myProgressTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(10000);
	}
    
    
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
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

    NSString *nibId = [[self.navigationController visibleViewController] nibName];
    
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
    
    rc.size.height = 350;
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
