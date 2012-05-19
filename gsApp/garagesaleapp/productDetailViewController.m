//
//  productDetailViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 08/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "productDetailViewController.h"
#import <CommonCrypto/CommonDigest.h> //CC_MD5

@interface productDetailViewController ()
- (void)configureView;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
- (void)setupKeyboardControls;
- (void)scrollViewToTextField:(id)textField;
@end

@implementation productDetailViewController

@synthesize detailItem = _detailItem;
@synthesize RKObjManeger;
@synthesize product;
@synthesize arrayGarage;
@synthesize arrayTags;
@synthesize isIdPersonNumber;
@synthesize arrayProfile;
@synthesize bidButton;
@synthesize emailTextField;
@synthesize offerTextField;
@synthesize commentTextView;
@synthesize nomeLabel;
@synthesize descricaoLabel;
@synthesize currencyLabel;
@synthesize valorEsperadoLabel;
@synthesize scrollView;
@synthesize imageView;
@synthesize nameProfile;
@synthesize cityProfile;
@synthesize emailProfile;
@synthesize imgProfile;
@synthesize showPicsButton;
@synthesize garageDetailButton;
@synthesize seeAllButton;
@synthesize imgViewLoading;
@synthesize offerLabel;
@synthesize descriptionLabel;
@synthesize msgBidSentLabel;
@synthesize secondView;
@synthesize garageDetailView;
@synthesize keyboardControls;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //Initializing the Object Manager
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    
    //Show Navigation Bar
    [self.navigationController setNavigationBarHidden:YES];
    
    //Setup Scroll animate to TextFields
    [self setupKeyboardControls];
    
    //Set SerializationMIMEType
    RKObjManeger.acceptMIMEType          = RKMIMETypeJSON;
    RKObjManeger.serializationMIMEType   = RKMIMETypeJSON;
    self.navigationItem.hidesBackButton = YES;
    [self setLoadAnimation];
    [self.imgViewLoading startAnimating];
    
    self.isIdPersonNumber = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[self.product.idPessoa characterAtIndex:0]];
    
    //Check if Flag isIdPersonNumber is name or number
    if (isIdPersonNumber) {
        [self setupProfileMapping];
    } else
        [self setupGarageMapping];
    
    [super viewDidLoad];
    
    //Custom Title Back Bar Button Item
    self.navigationController.navigationBar.backItem.title = NSLocalizedString(@"back", @"");
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [self.detailItem description];
    }
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
    
    if (self.isIdPersonNumber)
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", [[self.arrayProfile objectAtIndex:0] garagem]] 
                             objectMapping:garageMapping delegate:self];
    else
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", self.product.idPessoa] 
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
    
    if (self.isIdPersonNumber)
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", self.product.idPessoa] 
                             objectMapping:prolileMapping delegate:self];
    else 
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", [[self.arrayGarage objectAtIndex:0] idPerson]] 
                             objectMapping:prolileMapping delegate:self];

    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];  
}

- (void)setupProductMapping{
    //Configure Product Object Mapping
    RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[Product class]];    
    [productMapping mapKeyPath:@"sold"          toAttribute:@"sold"];
    [productMapping mapKeyPath:@"showPrice"     toAttribute:@"showPrice"];
    [productMapping mapKeyPath:@"currency"      toAttribute:@"currency"];
    [productMapping mapKeyPath:@"categorias"    toAttribute:@"categorias"];
    [productMapping mapKeyPath:@"valorEsperado" toAttribute:@"valorEsperado"];    
    [productMapping mapKeyPath:@"descricao"     toAttribute:@"descricao"];
    [productMapping mapKeyPath:@"nome"          toAttribute:@"nome"];
    [productMapping mapKeyPath:@"idEstado"      toAttribute:@"idEstado"];
    [productMapping mapKeyPath:@"idPessoa"      toAttribute:@"idPessoa"];
    [productMapping mapKeyPath:@"id"            toAttribute:@"id"];
    
    //LoadUrlResourcePath
    if (self.isIdPersonNumber)
        [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat: @"/product/%@?idProduct=%@", 
                                                 [[self.arrayGarage objectAtIndex:0] idPerson], self.product.id ] objectMapping:productMapping delegate:self];
    else
        [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat: @"/product/%@?idProduct=%@", 
                                                 self.product.idPessoa, self.product.id ] objectMapping:productMapping delegate:self];

    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objects count] > 0) {
        if ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
            self.arrayGarage = objects;
            if (!self.isIdPersonNumber)
                [self setupProfileMapping];
        }else if  ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
            self.arrayProfile = objects;
            if (self.isIdPersonNumber)
                [self setupGarageMapping];
            [self setupProductMapping];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[Product class]]){
            self.arrayTags = [(Product *)[objects objectAtIndex:0] categorias];
            self.product.descricao = [(Product *)[objects objectAtIndex:0] descricao];
            [self loadAttribsToComponents];
        }
    }
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
        
        // Handling POST /other.json        
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
        //Settings to Bid Sent
        [UIView beginAnimations:@"buttonFades" context:nil];
        [UIView setAnimationDuration:0.5];
        [bidButton setEnabled:YES];
        [bidButton setAlpha:1.0];
        [msgBidSentLabel setAlpha:1.0];
        [UIView commitAnimations];
        
        msgBidSentLabel.text = NSLocalizedString(@"bidSent", @"");
        emailTextField.text  = @"";
        offerTextField.text  = @"";
        commentTextView.text  = @"";

        //Set Delay to Hide msgBidSentLabel
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideMsgBidSent) userInfo:nil repeats:NO];
        
    } else if ([request isDELETE]) {
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

- (void)loadAttribsToComponents{
    bidButton.layer.cornerRadius            = 5.0f;
    garageDetailButton.layer.cornerRadius   = 5.0f;
    seeAllButton.layer.cornerRadius         = 5.0f;
    
    //Show Navigation bar
    [self.navigationController setNavigationBarHidden:NO];
    
    [seeAllButton setTitle: NSLocalizedString(@"seeAllProducts", @"") forState:UIControlStateNormal];
    [bidButton setTitle: NSLocalizedString(@"bid", @"") forState:UIControlStateNormal];
    
    // Grab the reference to the router from the manager
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    
    @try {
        [router routeClass:[Bid class] toResourcePath:@"/bid" forMethod:RKRequestMethodPOST];
    }
    @catch (NSException *exception) {
        NSLog(@"Object Exist...");
    }
    
    //Set Labels, titles, TextView...
    nomeLabel.text            = [self.product nome];
    valorEsperadoLabel.text   = [self.product valorEsperado];
    currencyLabel.text        = [self.product currency];
    offerLabel.text           = NSLocalizedString(@"offer", @"");
    descriptionLabel.text     = NSLocalizedString(@"description", @"");
    
    self.navigationItem.title = NSLocalizedString(@"detailProduct", @"");
    
    //Set Image Main Image Detail to show
    if ([[[self.product fotos] caminho] length] != 0){
        UIImage *imageSet = [UIImage imageWithData: [NSData dataWithContentsOfURL: 
                                                     [NSURL URLWithString:[NSString stringWithFormat:@"http://www.garagesaleapp.me/%@", 
                                                                           [[self.product fotos] caminho]]]]];
        
        imageView.image = imageSet;
        //Set proporcional image, center.
        //        if (imageSet.size.width < 320 ){
        imageView.frame = CGRectMake(((320-imageSet.size.width)/2), 0, imageSet.size.width, 265);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        }
        showPicsButton.hidden = NO;
    }
    else
        imageView.image = [UIImage imageNamed:@"nopicture.png"];
    
    nameProfile.text    = [[self.arrayProfile objectAtIndex:0] nome];
    cityProfile.text    = [[self.arrayGarage objectAtIndex:0] city];
    emailProfile.text   = [[self.arrayProfile objectAtIndex:0] email];
    imgProfile.image    = [UIImage imageWithData: [NSData dataWithContentsOfURL:
                                                   [self getGravatarURL:[[self.arrayProfile objectAtIndex:0] email]]]];
    
    self.navigationItem.hidesBackButton = NO;
    
    //configure addthis -- (this step is optional)
	[AddThisSDK setNavigationBarColor:[UIColor blueColor]];
	[AddThisSDK setToolBarColor:[UIColor whiteColor]];
	[AddThisSDK setSearchBarColor:[UIColor lightGrayColor]];
	
	//Facebook connect settings
	//CHANGE THIS FACEBOOK API KEY TO YOUR OWN!!
	[AddThisSDK setFacebookAPIKey:@"280819525292258"];
	[AddThisSDK setFacebookAuthenticationMode:ATFacebookAuthenticationTypeFBConnect];
    
    [AddThisSDK shouldAutoRotate:NO];
    [AddThisSDK setInterfaceOrientation:UIInterfaceOrientationPortrait];
    
    [AddThisSDK setAddThisPubId:@"ra-4f9585050fbd99b4"];
    //[AddThisSDK setAddThisApplicationId:@""];
    
    addThisButton = [AddThisSDK showAddThisButtonInView:self.view
                                              withFrame:CGRectMake(225, 305, 80, 25)
                                               forImage:imageView.image
                                              withTitle:@"Product Send from Garagesaleapp.me"
                                            description:descricaoLabel.text];
    
    addThisButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
	[AddThisSDK canUserEditServiceMenu:YES];
	[AddThisSDK canUserReOrderServiceMenu:YES];
	[AddThisSDK setDelegate:self];
    [secondView addSubview:addThisButton];
    
    //Calculate resize DescricaoLabel 
    descricaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 615, 307, 0)];
    [descricaoLabel setFont:[UIFont systemFontOfSize:14]];
    descricaoLabel.text = self.product.descricao;
    descricaoLabel.lineBreakMode = UILineBreakModeWordWrap; 
    descricaoLabel.numberOfLines = 0; 
    [descricaoLabel sizeToFit];
    secondView.frame = CGRectMake(0,0,320,960+descricaoLabel.frame.size.height);
    garageDetailView.frame = CGRectMake(0, descricaoLabel.frame.origin.y+descricaoLabel.frame.size.height, 320, 180);
    //[self.tagsScrollView initWithFrame:CGRectMake(13,  garageDetailView.frame.origin.y+garageDetailView.frame.size.height+100, 307, 200)];
    [secondView addSubview:descricaoLabel];
    // [secondView addSubview:tagsScrollView];
    [secondView addSubview:garageDetailView];
    self.scrollView.contentSize             = CGSizeMake(320,960+descricaoLabel.frame.size.height);
    
    [self.imgViewLoading stopAnimating];
    [self.imgViewLoading setHidden:YES];
    
    // [GlobalFunctions drawTagsButton:self.tags scrollView:self.scrollview viewController:self];
    
}

-(void) hideMsgBidSent {
    [UIView beginAnimations:@"msgFade" context:nil];
    [UIView setAnimationDuration:0.5];
    [msgBidSentLabel setAlpha:0.0];
    [UIView commitAnimations];
}

- (NSURL*) getGravatarURL:(NSString*) emailAddress {
	NSString *curatedEmail = [[emailAddress stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceCharacterSet]]
							  lowercaseString];
    
	const char *cStr = [curatedEmail UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    
	NSString *md5email = [NSString stringWithFormat:
                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15]
                          ];
	NSString *gravatarEndPoint = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=512", md5email];
    
	return [NSURL URLWithString:gravatarEndPoint];
}

- (void)setLoadAnimation{
    NSArray *imageArray;
    
    imageArray = [[NSArray alloc] initWithObjects:
                  [UIImage imageNamed:@"load-frame1.png"],
                  [UIImage imageNamed:@"load-frame2.png"],
                  [UIImage imageNamed:@"load-frame3.png"],
                  [UIImage imageNamed:@"load-frame4.png"],nil];
    
    self.imgViewLoading.animationImages = imageArray;
    self.imgViewLoading.animationDuration = 0.9;
}

- (IBAction)gotoGalleryScrollVC{
    galleryScrollViewController *galleryScrollVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryProduct"];
    galleryScrollVC.idPessoa = [[self.arrayProfile objectAtIndex:0] garagem];
    galleryScrollVC.idProduto = self.product.id;
    [self.navigationController pushViewController:galleryScrollVC animated:YES];
}

- (IBAction)gotoGarageDetailVC{
    garageDetailViewController *garageDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GarageDetail"];
    garageDetailVC.garage = self.arrayGarage;
    garageDetailVC.profile = self.arrayProfile;
    garageDetailVC.gravatarUrl = [self getGravatarURL:[[self.arrayProfile objectAtIndex:0] email]];
    [self.navigationController pushViewController:garageDetailVC animated:YES];
    
    //Custom Title Back Bar Button Item
    self.navigationController.navigationBar.backItem.title = NSLocalizedString(@"back", @"");
}

- (IBAction)gotoUserProductTableVC{
    productTableViewController *prdTabVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    prdTabVC.strLocalResourcePath = [NSString stringWithFormat:@"/product/%@", [[self.arrayProfile objectAtIndex:0] garagem]];
    [self.navigationController pushViewController:prdTabVC animated:YES];
}

- (void)gotoProductTableVC:(UIButton *)sender{
    productTableViewController *prdTbl = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    //filter by Category
    prdTbl.strLocalResourcePath = [NSString stringWithFormat:@"/product?category=%@", [[sender titleLabel] text] ];
    [self.navigationController pushViewController:prdTbl animated:YES];
}

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

- (IBAction)actionEmailComposer {
    //Validate fields
    if (([self.commentTextView.text length] == 0)) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"fieldsRequired", @"") message:NSLocalizedString(@"enterValueProduct", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    } else if([self.emailTextField.text length] == 0 || ![GlobalFunctions isValidEmail:self.emailTextField.text]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"fieldsRequired", @"") message:NSLocalizedString(@"enterEmail", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //Post Bid Sent
    RKObjectMapping *patientSerializationMapping = [RKObjectMapping mappingForClass:[Bid class]];
    [patientSerializationMapping mapKeyPath:@"email"      toAttribute:@"email"];
    [patientSerializationMapping mapKeyPath:@"value"      toAttribute:@"value"];
    [patientSerializationMapping mapKeyPath:@"comment"    toAttribute:@"comment"];
    [patientSerializationMapping mapKeyPath:@"idProduct"  toAttribute:@"idProduct"];
    
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[patientSerializationMapping inverseMapping] forClass:[Bid class]];    
    
    //Setting Bid Entity
    Bid* bid = [[Bid alloc] init];  
    bid.email = self.emailTextField.text;  
    bid.value = [[NSNumber alloc] initWithInt:[self.commentTextView.text floatValue]];
    bid.comment = self.commentTextView.text;
    bid.idProduct =  [[NSNumber alloc] initWithInt:[self.product.id intValue]]; 
    
    // POST bid  
    [[RKObjectManager sharedManager] postObject:bid delegate:self];
     
    //Animate bidButton
    [UIView beginAnimations:@"buttonFades" context:nil];
    [UIView setAnimationDuration:0.5];
    [bidButton setEnabled:NO];
    [bidButton setAlpha:0.3];
    [UIView commitAnimations];
}

- (IBAction)isNumberKey:(UITextField *)textField{
    [GlobalFunctions onlyNumberKey:textField];
}

/* 
 *
 Setup the keyboard controls BSKeyboardControls.h
 *
 */
- (void)setupKeyboardControls
{
    // Initialize the keyboard controls
    self.keyboardControls = [[BSKeyboardControls alloc] init];
    
    // Set the delegate of the keyboard controls
    self.keyboardControls.delegate = self;
    
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    self.keyboardControls.textFields = [NSArray arrayWithObjects:self.emailTextField,
                                        self.commentTextView, nil];
    
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
    UIScrollView* v = (UIScrollView*) self.view ;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:v];
    rc.origin.x = 0 ;
    rc.origin.y = 120 ;
    
    rc.size.height = 600;
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
    emailTextField = nil;
    offerTextField = nil;
    commentTextView = nil;
    [self setEmailTextField:nil];
    [self setOfferTextField:nil];
    [self setCommentTextView:nil];
    nameProfile = nil;
    cityProfile = nil;
    emailProfile = nil;
    imgProfile = nil;
    [self setNameProfile:nil];
    [self setCityProfile:nil];
    [self setEmailProfile:nil];
    [self setImgProfile:nil];
    showPicsButton = nil;
    [self setShowPicsButton:nil];
    bidButton = nil;
    [self setBidButton:nil];
    [self setGarageDetailButton:nil];
    garageDetailButton = nil;
    seeAllButton = nil;
    [self setSeeAllButton:nil];
    imgViewLoading = nil;
    [self setImgViewLoading:nil];
    offerLabel = nil;
    [self setOfferLabel:nil];
    descriptionLabel = nil;
    [self setDescriptionLabel:nil];
    msgBidSentLabel = nil;
    [self setMsgBidSentLabel:nil];
    secondView = nil;
    [self setSecondView:nil];
    garageDetailView = nil;
    addThisButton = nil;
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
