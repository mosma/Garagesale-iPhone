//
//  settingsAccountViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "settingsAccountViewController.h"
#import "NSAttributedString+Attributes.h"
#import "Profile.h"

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
@synthesize settingsAccount;
@synthesize buttonAccount;
@synthesize buttonPassword;
@synthesize buttonAddress;
@synthesize buttonLogout;
@synthesize buttonRightAbout;
@synthesize labelAboutAPP;
@synthesize labelTotalProducts;
@synthesize totalProducts;
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
    
    if ([nibId rangeOfString:@"Vnq-S3-BVF"].length != 0) //About ViewController
            IS_IPHONE_5 ? [self.view setFrame:CGRectMake(0, 20, 320, 548)] : [self.view setFrame:CGRectMake(0, 0, 320, 460)];
    else
            IS_IPHONE_5 ? [self.view setFrame:CGRectMake(0, 64, 320, 504)] : [self.view setFrame:CGRectMake(0, 0, 320, 416)];
}

- (void)loadAttribsToComponents{
    nibId = [[self.navigationController visibleViewController] nibName];
    
    if  ([nibId rangeOfString:@"5xi-Kh-5i5"].length != 0) { //Account ViewController{
        self.navigationItem.titleView = [GlobalFunctions getLabelTitleNavBarGeneric:
                                         UITextAlignmentCenter text:NSLocalizedString(@"account", @"") width:210];
        self.scrollView.contentSize = CGSizeMake(320,700);
    } else if
        ([nibId rangeOfString:@"tbg-8m-otZ"].length != 0) { //Address ViewController
        self.navigationItem.titleView = [GlobalFunctions getLabelTitleNavBarGeneric:
                                         UITextAlignmentCenter text:NSLocalizedString(@"address", @"") width:210];
        self.scrollView.contentSize = CGSizeMake(320,585);
    }else if
        ([nibId rangeOfString:@"K7a-eB-FnT"].length != 0) { //Password ViewController
        self.navigationItem.titleView = [GlobalFunctions getLabelTitleNavBarGeneric:
                                         UITextAlignmentCenter text:NSLocalizedString(@"password", @"") width:210];
        self.scrollView.contentSize = CGSizeMake(320,525);
    }
    
    imageView.image = (UIImage*)[NSKeyedUnarchiver unarchiveObjectWithData:[[GlobalFunctions getUserDefaults]
                                                                           objectForKey:[NSString stringWithFormat:@"%@_AvatarImg", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]]]];
    
    
    //set Navigation Title with OHAttributeLabel
    NSString *titleAbout = @"This app is developed and created by MoSMA. \r\n\ Want to talk? \n contact@mosma.us";
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:titleAbout];
    [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [attrStr setTextColor:[UIColor grayColor]];
    [attrStr setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14] range:[titleAbout rangeOfString:@"MoSMA"]];
    
    [attrStr setLink:[NSURL URLWithString:@"http://mosma.us"] range:[titleAbout rangeOfString:@"MoSMA"]];
    
    [attrStr setLink:[NSURL URLWithString:@"mailto:contact@mosma.us"] range:[titleAbout rangeOfString:@"contact@mosma.us"]];  
    
    [attrStr setTextColor:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                    range:[titleAbout rangeOfString:@"MoSMA"]];
    
    [attrStr setTextColor:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                    range:[titleAbout rangeOfString:@"contact@mosma.us"]];
    
    [attrStr setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14] range:[titleAbout rangeOfString:@"contact@mosma.us"]];
    
    
    [self.buttonRightAbout setTitle:NSLocalizedString(@"about", @"") forState:UIControlStateNormal];
    [self.buttonRightAbout.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:13]];
    
    
    //setting i18n
    [self.buttonAccount setTitle:NSLocalizedString(@"account", @"") forState:UIControlStateNormal];
    [self.buttonPassword setTitle:NSLocalizedString(@"password", @"") forState:UIControlStateNormal];
    [self.buttonAddress setTitle:NSLocalizedString(@"address", @"") forState:UIControlStateNormal];
    [self.buttonLogout setTitle:NSLocalizedString(@"logout", @"") forState:UIControlStateNormal];
    
    [self.labelGarageName setText:NSLocalizedString(@"garageName", @"")];
    [self.labelYourName setText:NSLocalizedString(@"yourName", @"")];
    [self.labelEmail setText:NSLocalizedString(@"yourEmail", @"")];
    [self.labelAbout setText:NSLocalizedString(@"aboutYou", @"")];
    [self.labelAnyLink setText:NSLocalizedString(@"anyLink?", @"")];
    
    [self.txtFieldGarageName setPlaceholder: NSLocalizedString(@"garageName", @"")];
    [self.txtFieldYourName setPlaceholder: NSLocalizedString(@"yourName", @"")];
    [self.txtFieldEmail setPlaceholder: NSLocalizedString(@"yourEmail", @"")];
    [self.txtViewAbout setText: NSLocalizedString(@"aboutYou", @"")];
    [self.txtFieldAnyLink setPlaceholder: NSLocalizedString(@"anyLink?", @"")];
    
    
    [self.labelCurrentPassword setText:NSLocalizedString(@"currentPassw", @"")];
    [self.labelNewPassword setText:NSLocalizedString(@"newPassw", @"")];
    [self.labelRepeatPassword setText:NSLocalizedString(@"repeatPassw", @"")];
    [self.txtFieldCurrentPassword setPlaceholder: NSLocalizedString(@"******", @"")];
    [self.txtFieldNewPassword setPlaceholder: NSLocalizedString(@"******", @"")];
    [self.txtFieldRepeatNewPassword setPlaceholder: NSLocalizedString(@"******", @"")];
  
    
    [self.labelAddress setText:NSLocalizedString(@"currentAddress", @"")];
    [self.labelCity setText:NSLocalizedString(@"currentCity", @"")];
    [self.labelDistrict setText:NSLocalizedString(@"currentDistrict", @"")];
    [self.labelCountry setText:NSLocalizedString(@"currentCoutry", @"")];
    
    [self.txtFieldAddress setPlaceholder: NSLocalizedString(@"currentAddress", @"")];
    [self.txtFieldCity setPlaceholder: NSLocalizedString(@"currentCity", @"")];
    [self.txtFieldDistrict setPlaceholder: NSLocalizedString(@"currentDistrict", @"")];
    [self.txtFieldCountry setPlaceholder: NSLocalizedString(@"currentCoutry", @"")];
    
    
    
    [self.buttonSave setTitle:NSLocalizedString(@"save", @"") forState:UIControlStateNormal];
    
    
    
    //theme information
    [self.buttonLogout.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14]];
    [self.buttonSave.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14]];
    [self.labelAnyLink setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
    [self.txtFieldAnyLink setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    
    
    
    [labelAboutAPP setAttributedText:attrStr];
    [labelAboutAPP setTextAlignment:UITextAlignmentCenter];
    
    //Total Products from garageAccount.
    NSString *total = [NSString stringWithFormat:NSLocalizedString(@"x-products", @""), totalProducts];
    NSMutableAttributedString *attrStrTotalProd = [NSMutableAttributedString attributedStringWithString:total];
    
    [attrStrTotalProd setFont:[UIFont fontWithName:@"Droid Sans" size:20]];
    [attrStrTotalProd setTextColor:[UIColor colorWithRed:253.0/255.0
                                                   green:103.0/255.0
                                                    blue:102.0/255.0
                                                   alpha:1.f]
                             range:[total rangeOfString:[NSString stringWithFormat:@"%i", totalProducts]]];
    
    [attrStrTotalProd setTextColor:[UIColor colorWithRed:153.0/255.0
                                                   green:153.0/255.0
                                                    blue:153.0/255.0
                                                   alpha:1.f]
                             range:[total rangeOfString:NSLocalizedString(@"x-products-range", @"")]];
    
    [attrStrTotalProd setFont:[UIFont fontWithName:@"Droid Sans" size:13]
                        range:[total rangeOfString:NSLocalizedString(@"x-products-range", @"")]];
    
    [attrStrTotalProd setFont:[UIFont boldSystemFontOfSize:20]
                        range:[total rangeOfString:[NSString stringWithFormat:@"%i", totalProducts]]];
    labelTotalProducts.attributedText   = attrStrTotalProd;
    labelTotalProducts.textAlignment = UITextAlignmentLeft;
    
    [buttonAccount.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
    [buttonAddress.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
    [buttonPassword.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
    
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
    
    city.font              = [UIFont fontWithName:@"Droid Sans" size:12 ];
    [city setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
    
    garageName.attributedText  = [GlobalFunctions
                                  getNamePerfil:[[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]
                                  profileName:[[GlobalFunctions getUserDefaults] objectForKey:@"nome"]];
    
    garageName.textAlignment  = UITextAlignmentLeft;
    
    NSString *cityConc = [[GlobalFunctions getUserDefaults] objectForKey:@"city"];
    NSString *district = [[GlobalFunctions getUserDefaults] objectForKey:@"district"];
    NSString *country = [[GlobalFunctions getUserDefaults] objectForKey:@"country"];
    
    city.text = [GlobalFunctions formatAddressGarage:@[cityConc, district, country]];

    self.navigationItem.leftBarButtonItem = [GlobalFunctions getIconNavigationBar:
                                             @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"
                                                                             rect:CGRectMake(0, 0, 40, 30)];
    [self setupKeyboardFields];
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
    if([nibId rangeOfString:@"5xi-Kh-5i5"].length != 0)  //Account ViewController{
        if (![self validateFormNameProfile]) return;
    if([nibId rangeOfString:@"K7a-eB-FnT"].length != 0)  //Password ViewController
         if (![self validateFormPassword]) return;
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Profile"
                                                     withAction:@"Save"
                                                      withLabel:@"Profile Saved"
                                                      withValue:nil];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *prodParams = [[NSMutableDictionary alloc] init];

    if (txtFieldCity.text.length > 100)
        txtFieldCity.text = [txtFieldCity.text substringWithRange:NSMakeRange(0, 100)];
    if (txtFieldDistrict.text.length > 11)
        txtFieldDistrict.text = [txtFieldDistrict.text substringWithRange:NSMakeRange(0, 11)];
    if (txtFieldCountry.text.length > 200)
        txtFieldCountry.text = [txtFieldCountry.text substringWithRange:NSMakeRange(0, 200)];
    if (txtFieldAddress.text.length > 200)
        txtFieldAddress.text = [txtFieldAddress.text substringWithRange:NSMakeRange(0, 200)];
    if (txtFieldAnyLink.text.length > 200)
        txtFieldAnyLink.text = [txtFieldAnyLink.text substringWithRange:NSMakeRange(0, 200)];
    
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
        [[[RKClient sharedClient] post:[NSString stringWithFormat:@"/profile/%i", [[[GlobalFunctions getUserDefaults] objectForKey:@"id"] intValue]]  params:postData delegate:self] send];
        [postData setObject:json forKey:@"garage"];
        [[[RKClient sharedClient] post:[NSString stringWithFormat:@"/garage/%@", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]] params:postData delegate:self] send];
        
        self.trackedViewName = [NSString stringWithFormat:@"/%@/settings", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Set determinate mode
	HUD.mode = MBProgressHUDModeAnnularDeterminate;
	
    HUD. center = CGPointMake(0, 0);
    
    HUD.labelFont = [UIFont fontWithName:@"Droid Sans" size:14];
	HUD.delegate = self;
	HUD.labelText = @"Saving";
	HUD.color = [UIColor blackColor];
    HUD.dimBackground = YES;
    
	[HUD showWhileExecuting:@selector(resultProgress) onTarget:self withObject:nil animated:YES];
}

-(BOOL)validateFormPassword{
    BOOL isValid = YES;
    
    if ([txtFieldNewPassword.text length] < 6) {
        [txtFieldNewPassword setValue:[UIColor redColor]
                           forKeyPath:@"_placeholderLabel.textColor"];
        [txtFieldNewPassword setText:@""];
        [txtFieldNewPassword setPlaceholder:NSLocalizedString(@"form-invalid-email-caracter" , nil)];
        isValid = NO;
    }
    
    if ([txtFieldRepeatNewPassword.text length] < 6) {
        [txtFieldRepeatNewPassword setValue:[UIColor redColor]
                           forKeyPath:@"_placeholderLabel.textColor"];
        [txtFieldRepeatNewPassword setText:@""];
        [txtFieldRepeatNewPassword setPlaceholder:NSLocalizedString(@"form-invalid-email-caracter" , nil)];
        isValid = NO;
    }
    
    if (![txtFieldNewPassword.text isEqualToString:txtFieldRepeatNewPassword.text]) {
        [txtFieldRepeatNewPassword setValue:[UIColor redColor]
                                 forKeyPath:@"_placeholderLabel.textColor"];
        [txtFieldRepeatNewPassword setText:@""];
        [txtFieldRepeatNewPassword setPlaceholder:NSLocalizedString(@"form-invalid-email-match" , nil)];
        isValid = NO;
    }
    
    return isValid;
}

-(BOOL)validateFormNameProfile{
    BOOL isValid = YES;
    if ([txtFieldYourName.text length] < 3) {
        [txtFieldYourName setValue:[UIColor redColor]
                           forKeyPath:@"_placeholderLabel.textColor"];
        [txtFieldYourName setPlaceholder:@"Hey, you must tell us your name"];
        isValid = NO;
    }
    return isValid;
}


- (void)getResourcePathLogOut{
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/login/%@?invalidate=true", [[GlobalFunctions getUserDefaults] objectForKey:@"token"]] delegate:self];
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
    
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"isLogOut"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[[self.tabBarController.viewControllers objectAtIndex:0] visibleViewController]
      navigationController] popToRootViewControllerAnimated:YES];
    
    self.tabBarController.selectedIndex = 0;
    
    [[[[self.tabBarController.viewControllers objectAtIndex:2] visibleViewController]
      navigationController] popToRootViewControllerAnimated:NO];    
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([keyboardControls.textFields containsObject:textField])
        keyboardControls.activeTextField = textField;
    [self scrollViewToTextField:textField];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([keyboardControls.textFields containsObject:textView])
        keyboardControls.activeTextField = textView;
    [self scrollViewToTextField:textView];
}

-(IBAction)textFieldEditingEnded:(id)sender{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [sender resignFirstResponder];
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
    [settingsAccount setObject:@"YES" forKey:@"isSettingsChange"];
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
- (void)setupKeyboardFields
{
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    if  ([nibId rangeOfString:@"5xi-Kh-5i5"].length != 0) //Account ViewController
        keyboardControls.textFields = [NSArray arrayWithObjects: txtFieldYourName, txtViewAbout, txtFieldAnyLink, nil];
    else if  
        ([nibId rangeOfString:@"tbg-8m-otZ"].length != 0) //Address ViewController
        keyboardControls.textFields = [NSArray arrayWithObjects: txtFieldAddress, txtFieldCity, txtFieldDistrict, txtFieldCountry, nil];
    else if  
        ([nibId rangeOfString:@"K7a-eB-FnT"].length != 0) //Password ViewController
        keyboardControls.textFields = [NSArray arrayWithObjects: txtFieldCurrentPassword, txtFieldNewPassword, txtFieldRepeatNewPassword, nil];
    [super addKeyboardControlsAtFields];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:txtFieldCity]){
        int limit = 100;
        return !([textField.text length]>limit && [string length] > range.length);
    }else if ([textField isEqual:txtFieldDistrict]){
        int limit = 11;
        return !([textField.text length]>limit && [string length] > range.length);
    }
    else if ([textField isEqual:txtFieldCountry]
             || [textField isEqual:txtFieldAddress]
             || [textField isEqual:txtFieldAnyLink]){
        int limit = 200;
        return !([textField.text length]>limit && [string length] > range.length);
    }
    return YES;
}

-(IBAction)dimissModal:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    //Return to Root viewController to display garge Case User Add A new Product.
    if ([[[GlobalFunctions getUserDefaults] objectForKey:@"isNewOrRemoveProduct"] isEqual:@"YES"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
        [self loadAttribsToComponents];
}

- (void)viewWillUnload:(BOOL)animated
{
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
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
