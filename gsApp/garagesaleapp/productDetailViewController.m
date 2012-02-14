//
//  productDetailViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 08/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "productDetailViewController.h"
#import "productTableViewController.h"
#import "garageDetailViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Product.h"
#import "Category.h"
#import "Photo.h"
#import "Bid.h"
#import <CommonCrypto/CommonDigest.h> //CC_MD5

@interface productDetailViewController ()
- (void)configureView;
@end

@implementation productDetailViewController

@synthesize detailItem = _detailItem;
@synthesize manager;
@synthesize product;
@synthesize garage;
@synthesize tags;
@synthesize isIdPersonNumber;
@synthesize profile;
@synthesize bidButton;
@synthesize emailTextField;
@synthesize offerTextField;
@synthesize nomeLabel;
@synthesize descricaoTextView;
@synthesize currencyLabel;
@synthesize valorEsperadoLabel;
@synthesize scrollView;
@synthesize imageView;
@synthesize nameProfile;
@synthesize cityProfile;
@synthesize emailProfile;
@synthesize imgProfile;
@synthesize tagsScrollView;
@synthesize showPicsButton;
@synthesize garageDetailButton;
@synthesize seeAllButton;
@synthesize imageLoad;
@synthesize offerLabel;
@synthesize descriptionLabel;
@synthesize msgBidSentLabel;
@synthesize secondView;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //Initializing the Object Manager
    manager = [RKObjectManager objectManagerWithBaseURL:@"http://api.garagesaleapp.in"];
    
    //Show Navigation Bar
    [self.navigationController setNavigationBarHidden:YES];
    
    //Set SerializationMIMEType
    manager.acceptMIMEType          = RKMIMETypeJSON;
    manager.serializationMIMEType   = RKMIMETypeJSON;
    self.navigationItem.hidesBackButton = YES;
    [self setLoadAnimation];
    [self.imageLoad startAnimating];
    
    self.isIdPersonNumber = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[self.product.idPessoa characterAtIndex:0]];
    
    //Check if Flag isIdPersonNumber is name or number
    if (isIdPersonNumber) {
        [self setupProfileMapping];
    } else
        [self setupGarageMapping];
    
    [super viewDidLoad];
}

- (void)loadAttributesSettings{
    self.scrollView.contentSize             = CGSizeMake(320,1060);
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
    
    [descricaoTextView setScrollEnabled:YES];
    [descricaoTextView flashScrollIndicators];
    descricaoTextView.editable = NO;
    [secondView addSubview:descricaoTextView];
    
    self.navigationItem.title = NSLocalizedString(@"detailProduct", @"");

    //Set Image Main Image Detail to show
    if ([[[self.product fotos] caminho] length] != 0){
         UIImage *imageSet = [UIImage imageWithData: [NSData dataWithContentsOfURL: 
                                                   [NSURL URLWithString:[NSString stringWithFormat:@"http://www.garagesaleapp.in/%@", 
                                                                         [[self.product fotos] caminho]]]]];
        
        imageView.image = imageSet;
        //Set proporcional image, center.
        if (imageSet.size.width < 320 ){
            imageView.frame = CGRectMake(((320-imageSet.size.width)/2), 0, imageSet.size.width, 300);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        showPicsButton.hidden = NO;
    }
    else
        imageView.image = [UIImage imageNamed:@"nopicture.png"];
    
    nameProfile.text    = [[self.profile objectAtIndex:0] nome];
    cityProfile.text    = [[self.garage objectAtIndex:0] city];
    emailProfile.text   = [[self.profile objectAtIndex:0] email];
    imgProfile.image    = [UIImage imageWithData: [NSData dataWithContentsOfURL:
                                                    [self getGravatarURL:[[self.profile objectAtIndex:0] email]]]];

    self.navigationItem.hidesBackButton = NO;
    
    [self.imageLoad stopAnimating];
    [self.imageLoad setHidden:YES];
    [self drawTagsButton];
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
        [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", [[self.profile objectAtIndex:0] garagem]] 
                             objectMapping:garageMapping delegate:self];
    else
        [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", self.product.idPessoa] 
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
        [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", self.product.idPessoa] 
                             objectMapping:prolileMapping delegate:self];
    else 
        [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", [[self.garage objectAtIndex:0] idPerson]] 
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
        [self.manager loadObjectsAtResourcePath:[NSString stringWithFormat: @"/product/%@?idProduct=%@", 
                                                 [[self.garage objectAtIndex:0] idPerson], self.product.id ] objectMapping:productMapping delegate:self];
    else
        [self.manager loadObjectsAtResourcePath:[NSString stringWithFormat: @"/product/%@?idProduct=%@", 
                                                 self.product.idPessoa, self.product.id ] objectMapping:productMapping delegate:self];

    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objects count] > 0) {
        if ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
            self.garage = objects;
            if (!self.isIdPersonNumber)
                [self setupProfileMapping];
        }else if  ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
            self.profile = objects;
            if (self.isIdPersonNumber)
                [self setupGarageMapping];
            [self setupProductMapping];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[Product class]]){
            self.tags = [(Product *)[objects objectAtIndex:0] categorias];
            if ([self.tags count] == 0)
                descricaoTextView = [[UITextView alloc] initWithFrame:CGRectMake(13, 570, 307, 305)];
            else 
                descricaoTextView = [[UITextView alloc] initWithFrame:CGRectMake(13, 570, 307, 175)];
            descricaoTextView.text = [(Product *)[objects objectAtIndex:0] descricao];
            [self loadAttributesSettings];
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

        //Set Delay to Hide msgBidSentLabel
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideMsgBidSent) userInfo:nil repeats:NO];
        
    } else if ([request isDELETE]) {
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
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

-(void)drawTagsButton{
    //define x,y position
    //sumY draw y positio
    int sumY = 0;
    int sumX = 0;
    int y = 0;
    int x;
    for(int i=0;i<[self.tags count];i++){
        //initial position x
        x = 20;
        
        //Category *category = [self.tags objectAtIndex:i];
        //get size of button string
        CGSize stringSize = [[[self.tags objectAtIndex:i] lowercaseString] sizeWithFont:[UIFont systemFontOfSize:14]]; 
        
        //set new position x
        if (sumX != 0)
            x = sumX;
        
        //draw Buttom
        UIButton *tagsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tagsButton.frame = CGRectMake(x, y, /* 135 */  stringSize.width+20 , 35);
        [tagsButton setTintColor:[UIColor greenColor]];
        //[tagsButton setTag:(NSInteger)category.identifier];
        [tagsButton setTitle:[[self.tags objectAtIndex:i] lowercaseString] forState:UIControlStateNormal];
        tagsButton.layer.masksToBounds = YES;
        tagsButton.layer.cornerRadius = 5.0f;
        tagsButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.466666666666667 blue:0 alpha:0.7];
        tagsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [tagsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tagsButton setTitleColor:[UIColor blackColor] forState:UIControlEventTouchDown];
        [tagsButton addTarget:self action:@selector(gotoProductTableVC:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize NextStringSize;
        //check if self.tags is out of bounds
        if ([self.tags count] > i+1)
            NextStringSize = [[[self.tags objectAtIndex:i+1] lowercaseString] sizeWithFont:[UIFont systemFontOfSize:14]]; 
        else
           //get size of next button string
            NextStringSize = [[[self.tags objectAtIndex:i] lowercaseString] sizeWithFont:[UIFont systemFontOfSize:14]]; 
        
        //check and set all new values control
        if ((sumX+20)+NextStringSize.width>200) {
            sumY++;
            y = sumY*40;
            sumX=0;
        } else if (sumX == 0)
            sumX = stringSize.width + sumX + 45;
        else
            sumX = stringSize.width + sumX + 25;
        
        [self.tagsScrollView addSubview:tagsButton];
    }
    [self.tagsScrollView setContentSize:CGSizeMake(300,y+40)];
}

- (void)setLoadAnimation{
    NSArray *imageArray;
    
    imageArray = [[NSArray alloc] initWithObjects:
                  [UIImage imageNamed:@"load-frame1.png"],
                  [UIImage imageNamed:@"load-frame2.png"],
                  [UIImage imageNamed:@"load-frame3.png"],
                  [UIImage imageNamed:@"load-frame4.png"],nil];
    
    self.imageLoad.animationImages = imageArray;
    self.imageLoad.animationDuration = 0.9;
}

- (IBAction)gotoGalleryScrollVC{
    galleryScrollViewController *galleryScrollVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryProduct"];
    galleryScrollVC.idPessoa = [[self.profile objectAtIndex:0] garagem];
    galleryScrollVC.idProduto = self.product.id;
    [self.navigationController pushViewController:galleryScrollVC animated:YES];
}

- (IBAction)gotoGarageDetailVC{
    garageDetailViewController *garageDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GarageDetail"];
    garageDetailVC.garage = self.garage;
    garageDetailVC.profile = self.profile;
    garageDetailVC.gravatarUrl = [self getGravatarURL:[[self.profile objectAtIndex:0] email]];
    [self.navigationController pushViewController:garageDetailVC animated:YES];
}

- (IBAction)gotoUserProductTableVC{
    productTableViewController *prdTabVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    prdTabVC.localResourcePath = [NSString stringWithFormat:@"/product/%@", [[self.profile objectAtIndex:0] garagem]];
    [self.navigationController pushViewController:prdTabVC animated:YES];
}

- (void)gotoProductTableVC:(UIButton *)sender{
    productTableViewController *prdTbl = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    //filter by Category
    prdTbl.localResourcePath = [NSString stringWithFormat:@"/product?category=%@", [[sender titleLabel] text] ];
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
    if (([self.offerTextField.text length] == 0) || ([self.offerTextField.text length] > 7)) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"fieldsRequired", @"") message:NSLocalizedString(@"enterValueProduct", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    } else if([self.emailTextField.text length] == 0 || ![self validEmail:self.emailTextField.text]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"fieldsRequired", @"") message:NSLocalizedString(@"enterEmail", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //Post Bid Sent
    RKObjectMapping *patientSerializationMapping = [RKObjectMapping mappingForClass:[Bid class]];
    [patientSerializationMapping mapKeyPath:@"email"      toAttribute:@"email"];
    [patientSerializationMapping mapKeyPath:@"value"      toAttribute:@"value"];
    [patientSerializationMapping mapKeyPath:@"idProduct"  toAttribute:@"idProduct"];
    
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:patientSerializationMapping forClass:[Bid class]];

    //Setting Bid Entity
    Bid* bid = [[Bid alloc] init];  
    bid.email = self.emailTextField.text;  
    bid.value = [[NSNumber alloc] initWithInt:[self.offerTextField.text floatValue]]; 
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

-(BOOL)validEmail:(NSString*) emailString {
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else
        return YES;
}

- (IBAction)isNumberKey:(UITextField *)textField{
	if ([textField.text length] > 0) {
		int I01 = [textField.text length];
		int Char01 = [textField.text characterAtIndex:I01-1];
		//check and accept input if last character is a number from 0 to 9, accept("." 46), reject("/" 47)
		if ((Char01 < 46) || (Char01 > 57) || (Char01 == 47)) {
			if (I01 == 1) {
				textField.text = nil;
			}
			else {
				textField.text = [textField.text substringWithRange:NSMakeRange(0, I01-1)];
			}
		}
	}
}

-(IBAction)textFieldEditingEnded:(id)sender{
    [sender resignFirstResponder];
}

- (void)viewDidUnload
{
    emailTextField = nil;
    offerTextField = nil;
    [self setEmailTextField:nil];
    [self setOfferTextField:nil];
    nameProfile = nil;
    cityProfile = nil;
    emailProfile = nil;
    imgProfile = nil;
    [self setNameProfile:nil];
    [self setCityProfile:nil];
    [self setEmailProfile:nil];
    [self setImgProfile:nil];
    tagsScrollView = nil;
    [self setTagsScrollView:nil];
    showPicsButton = nil;
    [self setShowPicsButton:nil];
    bidButton = nil;
    [self setBidButton:nil];
    [self setGarageDetailButton:nil];
    garageDetailButton = nil;
    seeAllButton = nil;
    [self setSeeAllButton:nil];
    imageLoad = nil;
    [self setImageLoad:nil];
    offerLabel = nil;
    [self setOfferLabel:nil];
    descriptionLabel = nil;
    [self setDescriptionLabel:nil];
    msgBidSentLabel = nil;
    [self setMsgBidSentLabel:nil];
    secondView = nil;
    [self setSecondView:nil];
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
