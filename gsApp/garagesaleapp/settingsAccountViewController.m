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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    //Set SerializationMIMEType
    [RKObjManeger setAcceptMIMEType:RKMIMETypeJSON];
    [RKObjManeger setSerializationMIMEType:RKMIMETypeJSON];
    
    if ([nibId rangeOfString:@"Vnq-S3-BVF"].length != 0) //About ViewController
            IS_IPHONE_5 ? [self.view setFrame:CGRectMake(0, 20, 320, 548)] : [self.view setFrame:CGRectMake(0, 0, 320, 460)];
    else
            IS_IPHONE_5 ? [self.view setFrame:CGRectMake(0, 64, 320, 504)] : [self.view setFrame:CGRectMake(0, 0, 320, 416)];
}

- (void)loadAttribsToComponents{
    nibId = [[self.navigationController visibleViewController] nibName];
    [self.scrollView setContentSize:CGSizeMake(320,470)];

    if  ([nibId rangeOfString:@"5xi-Kh-5i5"].length != 0) { //Account ViewController{
        [self.navigationItem setTitleView:[GlobalFunctions getLabelTitleNavBarGeneric:
                                           UITextAlignmentCenter text:NSLocalizedString(@"account", @"") width:210]];
        [self setTrackedViewName:[NSString stringWithFormat:@"/%@/settings/account", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]]];
    } else if
        ([nibId rangeOfString:@"tbg-8m-otZ"].length != 0) { //Address ViewController
            [self.navigationItem setTitleView:[GlobalFunctions getLabelTitleNavBarGeneric:
                                               UITextAlignmentCenter text:NSLocalizedString(@"address", @"") width:210]];
        [self setTrackedViewName:[NSString stringWithFormat:@"/%@/settings/address", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]]];
    }else if
        ([nibId rangeOfString:@"K7a-eB-FnT"].length != 0) { //Password ViewController
            [self.navigationItem setTitleView:[GlobalFunctions getLabelTitleNavBarGeneric:
                                               UITextAlignmentCenter text:NSLocalizedString(@"password", @"") width:210]];
        [self setTrackedViewName:[NSString stringWithFormat:@"/%@/settings/password", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]]];
    }
    
    [imageView setImage:(UIImage*)[NSKeyedUnarchiver unarchiveObjectWithData:[[GlobalFunctions getUserDefaults]
                                                                              objectForKey:[NSString stringWithFormat:@"%@_AvatarImg", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]]]]];

    //set Navigation Title with OHAttributeLabel
    NSString *titleAbout = @"This app is developed and \n created by MoSMA. \r\n We love feedbacks! Report a \n bug or give some suggestion! \n contact@mosma.us";
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
        
    //theme information
    [self.buttonLogout.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14]];
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
    [labelTotalProducts setTextAlignment:UITextAlignmentLeft];
    
    [buttonAccount.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
    [buttonAddress.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
    [buttonPassword.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
    
    //Password ViewController
    [labelCurrentPassword setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    [labelNewPassword setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    [labelRepeatPassword setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    
    [txtFieldCurrentPassword    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldNewPassword        setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldRepeatNewPassword  setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    txtFieldCurrentPassword.text = [[GlobalFunctions getUserDefaults] objectForKey:@"senha"];
    
    //Address ViewController
    [labelAddress setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    [labelCity setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    [labelDistrict setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    [labelCountry setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    
    [txtFieldAddress    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldCity       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldDistrict   setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldCountry    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    [txtFieldAddress setText:[[GlobalFunctions getUserDefaults] objectForKey:@"address"]];
    [txtFieldCity setText:[[GlobalFunctions getUserDefaults] objectForKey:@"city"]];
    [txtFieldDistrict setText:[[GlobalFunctions getUserDefaults] objectForKey:@"district"]];
    [txtFieldCountry setText:[[GlobalFunctions getUserDefaults] objectForKey:@"country"]];
    
    //Account ViewController
    [labelGarageName setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    [labelEmail setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    [labelAbout setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    [labelYourName setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    
    [txtFieldGarageName setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldYourName   setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtViewAbout       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldEmail      setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldAnyLink    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    [txtFieldGarageName setPlaceholder:[[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]];
    [txtFieldYourName setText:[[GlobalFunctions getUserDefaults] objectForKey:@"nome"]];
    [txtViewAbout setText:[[GlobalFunctions getUserDefaults] objectForKey:@"about"]];
    [txtFieldEmail setPlaceholder:[[GlobalFunctions getUserDefaults] objectForKey:@"email"]];
    [txtFieldAnyLink setText:[[GlobalFunctions getUserDefaults] objectForKey:@"link"]];
    
    [city setFont:[UIFont fontWithName:@"Droid Sans" size:12 ]];
    [city setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
    
    [garageName setAttributedText:[GlobalFunctions
                                   getNamePerfil:[[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]
                                   profileName:[[GlobalFunctions getUserDefaults] objectForKey:@"nome"]]];
    
    [garageName setTextAlignment:UITextAlignmentLeft];
    
    NSString *cityConc = [[GlobalFunctions getUserDefaults] objectForKey:@"city"];
    NSString *district = [[GlobalFunctions getUserDefaults] objectForKey:@"district"];
    NSString *country = [[GlobalFunctions getUserDefaults] objectForKey:@"country"];
    
    [city setText:[GlobalFunctions formatAddressGarage:@[cityConc, district, country]]];

    UIBarButtonItem *barItem = [GlobalFunctions getIconNavigationBar:@selector(backPage)
                                                           viewContr:self
                                                          imageNamed:@"btBackNav.png" rect:CGRectMake(0, 0, 40, 30)];
    
    [self.save setTitle:NSLocalizedString(@"save", @"") forState:UIControlStateNormal];
    [self.save.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:13]];
    
    [self.cancel setTitle:NSLocalizedString(@"keyboard-cancel-btn", @"") forState:UIControlStateNormal];
    [self.cancel.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:13]];
    
    [self.navigationItem setLeftBarButtonItem:barItem];
    barItem = nil;
    cityConc = nil;
    district = nil;
    country = nil;
    total = nil;
    attrStrTotalProd = nil;
    titleAbout = nil;
    attrStr = nil;
    imageView = nil;
    
    [self setupKeyboardFields];
}

- (void)getResourcePathGarage {
    RKObjectMapping *garageMapping = [Mappings getGarageMapping];
    
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@",
                                             [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]]
                              objectMapping:garageMapping delegate:self];
    
    garageMapping = nil;
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathProfile {
    RKObjectMapping *profileMapping = [Mappings getProfileMapping];
    
    
    NSLog(@"%@", [NSString stringWithFormat:@"/profile/%@",
                [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"]]);
    
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@",
                                             [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"]]
                              objectMapping:profileMapping delegate:self];
    
    profileMapping = nil;
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if  ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
        [self setProfile:objects];
        [self getResourcePathGarage];
    }else if ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
        [self setGarage:objects];
        if (isSaved)
            [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)saveSettings{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if([nibId rangeOfString:@"5xi-Kh-5i5"].length != 0)  //Account ViewController{
        if (![self validateFormNameProfile]) return;
    if([nibId rangeOfString:@"K7a-eB-FnT"].length != 0)  //Password ViewController
         if (![self validateFormPassword]) return;
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Profile"
                                                     withAction:@"Save"
                                                      withLabel:@"Profile Saved"
                                                      withValue:nil];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *settingsParams = [[NSMutableDictionary alloc] init];

    if (txtFieldCity.text.length > 100)
        [txtFieldCity setText:[txtFieldCity.text substringWithRange:NSMakeRange(0, 100)]];
    if (txtFieldDistrict.text.length > 11)
        [txtFieldDistrict setText:[txtFieldDistrict.text substringWithRange:NSMakeRange(0, 11)]];
    if (txtFieldCountry.text.length > 200)
        [txtFieldCountry setText: [txtFieldCountry.text substringWithRange:NSMakeRange(0, 200)]];
    if (txtFieldAddress.text.length > 200)
        [txtFieldAddress setText:[txtFieldAddress.text substringWithRange:NSMakeRange(0, 200)]];
    if (txtFieldAnyLink.text.length > 200)
        [txtFieldAnyLink setText:[txtFieldAnyLink.text substringWithRange:NSMakeRange(0, 200)]];
    
    NSString *idPerson = [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"];
    [settingsParams setObject:txtFieldGarageName != nil ? txtFieldGarageName.placeholder : [[GlobalFunctions getUserDefaults]
                                                                                        objectForKey:@"garagem"]  forKey:@"garagem"];
    [settingsParams setObject:txtFieldCurrentPassword   != nil ? txtFieldCurrentPassword.text :        @""          forKey:@"oldPassword"];
    [settingsParams setObject:txtFieldNewPassword       != nil ? txtFieldNewPassword.text :            @""          forKey:@"newPassword"];
    [settingsParams setObject:txtFieldRepeatNewPassword != nil ? txtFieldRepeatNewPassword.text :      @""          forKey:@"newPassword2"];
    [settingsParams setObject:txtFieldYourName          != nil ? txtFieldYourName.text :[[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"nome"]     forKey:@"nome"];
    [settingsParams setObject:txtFieldEmail             != nil ? txtFieldEmail.placeholder : [[GlobalFunctions getUserDefaults]
                                                                                          objectForKey:@"email"]    forKey:@"email"];
    [settingsParams setObject:txtViewAbout              != nil ? txtViewAbout.text :    [[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"about"]    forKey:@"about"];
    [settingsParams setObject:txtFieldAnyLink           != nil ? txtFieldAnyLink.text : [[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"link"]     forKey:@"link"];
    [settingsParams setObject:txtFieldAddress           != nil ? txtFieldAddress.text : [[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"address"]   forKey:@"address"];
    [settingsParams setObject:txtFieldCity              != nil ? txtFieldCity.text :    [[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"city"]     forKey:@"city"];
    [settingsParams setObject:txtFieldCountry           != nil ? txtFieldCountry.text : [[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"country"]   forKey:@"country"];
    [settingsParams setObject:txtFieldDistrict          != nil ? txtFieldDistrict.text :[[GlobalFunctions getUserDefaults]
                                                                                     objectForKey:@"district"] forKey:@"district"];
    [settingsParams setObject:@""                               forKey:@"idState"];
    [settingsParams setObject:@""                               forKey:@"lang"];
    
    if (_isAddressChanged)
        [settingsParams setObject:@"0,0"                               forKey:@"localization"];
    else
        [settingsParams setObject:[[GlobalFunctions getUserDefaults]
                     objectForKey:@"localization"]                     forKey:@"localization"];


    //The server ask me for this format, so I set it here:
    [postData setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"] forKey:@"token"];
    [postData setObject:idPerson              forKey:@"idUser"];
    
    //Parsing prodParams to JSON!
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:[GlobalFunctions getMIMEType]];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:settingsParams error:&error];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
    
    //If no error we send the post, voila!
    if (!error){
        //Add ProductJson in postData for key profile
        [postData setObject:json forKey:@"profile"];
        [[[RKClient sharedClient] post:[NSString stringWithFormat:@"/profile/%i&iphoneApp=true", [[[GlobalFunctions getUserDefaults] objectForKey:@"id"] intValue]]  params:postData delegate:self] send];
        [postData setObject:json forKey:@"garage"];
        [[[RKClient sharedClient] post:[NSString stringWithFormat:@"/garage/%@", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]] params:postData delegate:self] send];
    }

    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Set determinate mode
	[HUD setMode:MBProgressHUDModeText];
	    
    [HUD setLabelFont:[UIFont fontWithName:@"Droid Sans" size:14]];
	[HUD setDelegate:self];
	[HUD setLabelText:@"Saving"];
	[HUD setColor:[UIColor clearColor]];
    [HUD setDimBackground:YES];
    
	[HUD showWhileExecuting:@selector(resultProgress) onTarget:self withObject:nil animated:YES];
    
    postData = nil;
    settingsParams = nil;
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
    [userDefaults setObject:@"YES" forKey:@"reloadHome"];
    [userDefaults setObject:@"YES" forKey:@"reloadProductAccount"];    
    [userDefaults synchronize];
    userDefaults = nil;
    
    [[[[self.tabBarController.viewControllers objectAtIndex:0] visibleViewController]
      navigationController] popToRootViewControllerAnimated:YES];
    
    self.tabBarController.selectedIndex = 0;
    
    defaultsDictionary = nil;
    userDefaults = nil;
    
    [[[[self.tabBarController.viewControllers objectAtIndex:2] visibleViewController]
      navigationController] popToRootViewControllerAnimated:NO];
    
    [[FBSession activeSession] closeAndClearTokenInformation];

}

-(void)backPage{
    [self releaseMemoryCache];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)releaseMemoryCache{
    HUD = nil;
    RKObjManeger = nil;
    settingsAccount = nil;
    nibId = nil;
    keyboardControls.delegate = nil;
    [super releaseMemoryCache];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentSize:CGSizeMake(320,700)];
    if ([keyboardControls.textFields containsObject:textField])
        keyboardControls.activeTextField = textField;
    [self scrollViewToTextField:textField];
    
    if ([nibId rangeOfString:@"tbg-8m-otZ"].length != 0) self.isAddressChanged = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.scrollView setContentSize:CGSizeMake(320,700)];
    if ([keyboardControls.textFields containsObject:textView])
        keyboardControls.activeTextField = textView;
    [self scrollViewToTextField:textView];
}

-(IBAction)textFieldEditingEnded:(id)sender{
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
	while (progress < 3.0f) {
		progress += 0.005f;
		[HUD setProgress:progress];
		usleep(10000);
        if (isSaved) break;
	}
    HUD.mode = MBProgressHUDModeCustomView;
    if (isSaved) {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        [HUD setCustomView:imgV];
        imgV = nil;
        [HUD setLabelText:@"Completed"];
    }else{
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconDeletePicsAtGalleryProdAcc.png"]];
        [HUD setCustomView:imgV];
        imgV = nil;
        [HUD setLabelText:@"Fail! Check your connection."];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
    rc.size.height = 340;
    [self.scrollView scrollRectToVisible:rc animated:YES];
    
    v = nil;
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

-(IBAction)trackAbout:(id)sender{
    settingsAccountViewController *about = [self.storyboard instantiateViewControllerWithIdentifier:@"about"];
    [self removeNoMessageFromSuperView];
    [about removeNoMessageFromSuperView];
    [self.navigationController presentModalViewController:about animated:YES];
    [self setTrackedViewName:@"/about"];
}

/*
 * The "Done" button was pressed
 * We want to close the keyboard
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [self.scrollView setContentSize:CGSizeMake(320,470)];
    [scrollView setContentOffset:CGPointZero animated:YES];
    [controls.activeTextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadAttribsToComponents];
}

- (void)viewWillUnload:(BOOL)animated
{
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    RKObjManeger = nil;
    [self setRKObjManeger:nil];
    labelTotalProducts = nil;
    [self setLabelTotalProducts:nil];
    labelAboutAPP = nil;
    [self setLabelAboutAPP:nil];
    settingsAccount = nil;
    [self setSettingsAccount:nil];
    scrollView = nil;
    [self setScrollView:nil];
    buttonAccount = nil;
    [self setButtonAccount:nil];
    buttonPassword = nil;
    [self setButtonPassword:nil];
    buttonAddress = nil;
    [self setButtonAddress:nil];
    buttonLogout = nil;
    [self setButtonLogout:nil];
    buttonRightAbout = nil;
    [self setButtonRightAbout:nil];
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
    [self setSave:nil];
    self.save = nil;
    [self setCancel:nil];
    self.cancel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
