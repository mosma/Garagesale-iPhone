//
//  productDetailViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 08/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "productDetailViewController.h"
#import "NSAttributedString+Attributes.h"

@interface productDetailViewController ()
- (void)configureView;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
- (void)setupKeyboardControls;
- (void)scrollViewToTextField:(id)textField;
@end

@implementation productDetailViewController

@synthesize buttonEditProduct;
@synthesize buttonDeleteProduct;
@synthesize detailItem = _detailItem;
@synthesize RKObjManeger;
@synthesize product;
@synthesize arrayGarage;
@synthesize arrayTags;
@synthesize isIdPersonNumber;
@synthesize arrayProfile;
@synthesize buttonBid;
@synthesize txtFieldEmail;
@synthesize txtFieldOffer;
@synthesize txtViewComment;
@synthesize labelNomeProduto;
@synthesize labelDescricao;
@synthesize OHlabelValorEsperado;
@synthesize scrollViewMain;
@synthesize labelNameProfile;
@synthesize labelCityProfile;
@synthesize labelEmailProfile;
@synthesize buttonGarageDetail;
@synthesize msgBidSentLabel;
@synthesize secondView;
@synthesize garageDetailView;
@synthesize countView;
@synthesize countLabel;
@synthesize keyboardControls;
@synthesize productPhotos;
@synthesize imageView;
@synthesize galleryScrollView;
@synthesize viewBidSend;
@synthesize viewBidMsg;
@synthesize viewControl;
@synthesize viewReport;
@synthesize PagContGallery;
@synthesize activityIndicator;
@synthesize buttonReportThisGarage;
@synthesize labelAskSomething, labelBidSent, labelCongrats, labelEmail, labelOffer;

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
    [super viewDidLoad];

    //Initializing the Object Manager
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    
    //Setup Scroll animate to TextFields
    [self setupKeyboardControls];
    
    //Set SerializationMIMEType
    RKObjManeger.acceptMIMEType          = RKMIMETypeJSON;
    RKObjManeger.serializationMIMEType   = RKMIMETypeJSON;
    self.navigationItem.hidesBackButton = YES;
    [self setLoadAnimation];
   // [self.imgViewLoading startAnimating];

   [self loadAttribsToComponents:NO];

    //Check if Flag isIdPersonNumber is name or number
    if (isIdPersonNumber) {
        [self getResourcePathProfile];
    } else{
        [self getResourcePathGarage];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)loadAttribsToComponents:(BOOL)isFromLoadObject{
    
    
    //setting i18n
    [self.buttonBid setTitle: NSLocalizedString(@"bid", @"") forState:UIControlStateNormal];
    [self.buttonReportThisGarage.titleLabel setFont:[UIFont fontWithName:@"Droid Sans"
                                                                    size:12]];
    [self.buttonReportThisGarage setTitleColor:[UIColor colorWithRed:253.0/255.0
                                                               green:103.0/255.0
                                                                blue:102.0/255.0
                                                               alpha:1.f]
                                      forState:UIControlStateNormal ];
    [self.buttonReportThisGarage setTitle: NSLocalizedString(@"reportGarege", @"") forState:UIControlStateNormal];
    [self.buttonDeleteProduct setTitle: NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
    [self.buttonEditProduct setTitle: NSLocalizedString(@"edit", @"") forState:UIControlStateNormal];
    
    
    if (!isFromLoadObject) {
        /*
         Esta verificaçao esta errada... bbbba garagem pode
         ter so numeros ?
         */
        self.isIdPersonNumber = [[NSCharacterSet decimalDigitCharacterSet] 
                                 characterIsMember:[self.product.idPessoa characterAtIndex:0]];
        
        //Show Navigation bar
        [self.navigationController setNavigationBarHidden:NO];
        
        buttonBid.layer.cornerRadius            = 5.0f;
        buttonGarageDetail.layer.cornerRadius   = 5.0f;
        
        viewShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,5000)];
        [viewShadow setBackgroundColor:[UIColor blackColor]];
        [viewShadow setAlpha:0];
        
        [viewBidSend setAlpha:0];
        [viewBidSend.layer setCornerRadius:5];
        
        [viewBidMsg setAlpha:0];
        [viewBidMsg.layer setCornerRadius:5];
        
        [txtFieldEmail    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        [txtViewComment   setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        [labelDescricao   setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        [labelNomeProduto setFont:[UIFont fontWithName:@"Droid Sans" size:18]];
        
        [labelEmail setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        [labelOffer setFont:[UIFont fontWithName:@"DroidSans-Bold" size:17]];
        [labelAskSomething setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        [labelCongrats setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        [labelBidSent setFont:[UIFont fontWithName:@"DroidSans-Bold" size:17]];
        
        //Set Labels, titles, TextView...
        [labelNomeProduto       setText:[self.product nome]];
        [labelDescricao         setText:[self.product descricao]];
        [OHlabelValorEsperado   setText:[self.product valorEsperado]];
        
        //set Navigation Title with OHAttributeLabel
        NSString *titleNavItem = [NSString stringWithFormat: NSLocalizedString(@"garages-garage", nil) , product.idPessoa];
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:titleNavItem];
        // NSLog(@"Available Font Families: %@", [UIFont familyNames]);
        [attrStr setFont:[UIFont fontWithName:@"Corben" size:13]];
        [attrStr setTextColor:[UIColor whiteColor]];
        [attrStr setTextColor:[UIColor colorWithRed:244.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.f]
                        range:[titleNavItem rangeOfString:NSLocalizedString(@"garages-garage-string", nil)]];
        CGRect frame = CGRectMake(100, 0, 320, 27);
        OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:frame];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setShadowColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
        [label setShadowOffset:CGSizeMake(0, -1)];
        [label setAttributedText:attrStr];
        [label setTextAlignment:UITextAlignmentCenter];
        [self.navigationItem setTitleView:label];
        
        NSString *titleValorEsperado = [NSString stringWithFormat:@"%@%@", [GlobalFunctions getCurrencyByCode:(NSString *)self.product.currency], self.product.valorEsperado];
        NSMutableAttributedString* attrStrVE = [NSMutableAttributedString attributedStringWithString:titleValorEsperado];
        // NSLog(@"Available Font Families: %@", [UIFont familyNames]);
        [attrStrVE setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
        [attrStrVE setTextColor:[UIColor grayColor]];
        [attrStrVE setTextColor:[UIColor colorWithRed:91.0/255.0 green:148.0/255.0 blue:67.0/255.0 alpha:1.f]
                        range:[titleValorEsperado rangeOfString:self.product.valorEsperado]];
        [attrStrVE setFontName:@"Droid Sans" size:28 range:[titleValorEsperado rangeOfString:self.product.valorEsperado]];
        [OHlabelValorEsperado setBackgroundColor:[UIColor clearColor]];
        OHlabelValorEsperado.attributedText = attrStrVE;

        UIButton *buttonShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonShare setFrame:CGRectMake(0.0f, 0.0f, 38.0f, 32.0f)];
        [buttonShare setImage:[UIImage imageNamed:@"addThisButton.png"] forState:UIControlStateNormal];
        UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithCustomView:buttonShare];
        [buttonShare addTarget:self action:@selector(topRight:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = random;
        [self.navigationItem.rightBarButtonItem setEnabled:NO];

        [self.view setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];

        [self.navigationItem setLeftBarButtonItem:[GlobalFunctions getIconNavigationBar:
                                                   @selector(backPage) viewContr:self imageNamed:@"btBackNav.png" rect:CGRectMake(0, 0, 40, 30)]];

        [labelAskSomething setText:NSLocalizedString(@"offer", @"")];
        
        CGRect rect;//             = imageView.frame;
        
        rect.size.width         = 320;
        rect.size.height        = 280;
        rect.origin.x             = 0;
        rect.origin.y             = 0;
        imageView.frame         = rect;
        
        imageView.contentMode   = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [galleryScrollView  setFrame:CGRectMake(0, 115, 320, 370)];
        [galleryScrollView  setClipsToBounds:YES];
        [galleryScrollView  setAutoresizesSubviews:YES];
        [galleryScrollView  addSubview:imageView];

        //[secondView addSubview:garageDetailView];
        [scrollViewMain setContentSize:CGSizeMake(320,550+labelDescricao.frame.size.height)];

        nextPageGallery=1;
    }else {
       
        
        // Grab the reference to the router from the manager
        RKObjectRouter *router = [RKObjectManager sharedManager].router;
        
        self.trackedViewName = [NSString stringWithFormat:@"/%@,/%@",
                                [[self.arrayProfile objectAtIndex:0] garagem], self.product.id];
        
        @try {
            [router routeClass:[Bid class] toResourcePath:@"/bid" forMethod:RKRequestMethodPOST];
        }
        @catch (NSException *exception) {
            NSLog(@"Object Exist...");
        }
        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoGarageDetailVC)];
        [gest setNumberOfTapsRequired:1];
        [garageDetailView addGestureRecognizer:gest];
        
        [labelNameProfile   setText:[[self.arrayProfile objectAtIndex:0] nome]];
        
        NSString *cityConc = [[self.arrayGarage objectAtIndex:0] city];
        NSString *country = [[self.arrayGarage objectAtIndex:0] district];
        NSString *district = [[self.arrayGarage objectAtIndex:0] country];
        
        labelCityProfile.text = [GlobalFunctions formatAddressGarage:@[cityConc, district, country]];
        
        if ([labelCityProfile.text length] < 5)
            [labelCityProfile setHidden:YES];
        
        [labelEmailProfile  setText:NSLocalizedString(@"see-more-products", nil)];
        
        [labelNameProfile setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.f]];
        [labelCityProfile setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
        
        labelNameProfile.font  = [UIFont fontWithName:@"DroidSans-Bold" size:14];
        labelCityProfile.font  = [UIFont fontWithName:@"Droid Sans" size:12];
        labelEmailProfile.font = [UIFont fontWithName:@"Droid Sans" size:12];
       
        NSString *garageName = [[self.arrayProfile objectAtIndex:0] garagem];
        
        NSString *avatarName =  [NSString stringWithFormat:@"%@_AvatarImg", garageName];
                
        UIImage *image = (UIImage*)[NSKeyedUnarchiver unarchiveObjectWithData:[[GlobalFunctions getUserDefaults]
                                                                               objectForKey:avatarName]];

        if (!image) {
            vH = [[viewHelper alloc] init];
            vH.avatarName = avatarName;
            image = [vH getGarageAvatar:self.arrayProfile];
        }
        
        
        [buttonGarageDetail setImage:image forState:UIControlStateNormal];
        
        [garageDetailView setHidden:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];

//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.4];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];

        //Calculate resize DescricaoLabel 
            [labelDescricao setText:self.product.descricao];
            [labelDescricao sizeToFit];
            [secondView setFrame:CGRectMake(0,0,320,550+labelDescricao.frame.size.height)];
            garageDetailView.frame = CGRectMake(0, labelDescricao.frame.origin.y+labelDescricao.frame.size.height+10, 320, 450);
            //[self.tagsScrollView initWithFrame:CGRectMake(13,  garageDetailView.frame.origin.y+garageDetailView.frame.size.height+100, 307, 200)];
            [secondView addSubview:labelDescricao];
            // [secondView addSubview:tagsScrollView];
            [secondView addSubview:garageDetailView];
            scrollViewMain.contentSize             = CGSizeMake(320,630+labelDescricao.frame.size.height);
        
 //       [UIView commitAnimations];
        
        countView.layer.cornerRadius = 4;
        [countView.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [countView.layer setShadowOffset:CGSizeMake(1, 1)];
        [countView.layer setShadowOpacity:0.1];
        
        int countPhotos = (int)[self.product.fotos count];

        PagContGallery = [[UIPageControl alloc] init];
        [PagContGallery setNumberOfPages:countPhotos];
        
        if (countPhotos != 0) {
            [scrollViewMain insertSubview:countView aboveSubview:galleryScrollView];
            NSString *titleCount = [NSString stringWithFormat:@"1/%i", PagContGallery.numberOfPages];
            NSMutableAttributedString* attrStrCount = [NSMutableAttributedString attributedStringWithString:titleCount];
            [attrStrCount setFont:[UIFont fontWithName:@"Droid Sans" size:20]];
            [attrStrCount setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
            [attrStrCount setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.f]
                                 range:[titleCount rangeOfString:[NSString stringWithFormat:@"/%i", PagContGallery.numberOfPages]]];
            [countLabel setBackgroundColor:[UIColor clearColor]];
            countLabel.attributedText = attrStrCount;
            [countView setHidden:NO];
            [galleryScrollView setContentSize:CGSizeMake(self.view.frame.size.width * countPhotos, 320)];
            [galleryScrollView setDelegate:self];
        } else 
            [countView setHidden:YES];

        UIImage *firstImage;

        @try {
            Photo       *photo      = (Photo *)[self.product.fotos objectAtIndex:0];
            Caminho     *caminho    = (Caminho *)[[photo caminho] objectAtIndex:0];
            NSURL *url = [NSURL URLWithString:[caminho mobile]];
            firstImage                   = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [imageView setImage:firstImage];
        }
        @catch (NSException *exception) {
            firstImage                   = [UIImage imageNamed:@"nopicture.png"];
            imageView               = [[UIImageView alloc] initWithImage:firstImage];
        }
        
        //Shadow Top below navigationBar
        CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:.15f].CGColor;
        CGColorRef lightColor = [UIColor clearColor].CGColor;
        CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
        newShadow.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
        newShadow.colors = [NSArray arrayWithObjects:(__bridge id)darkColor, (__bridge id)lightColor, nil];
        
        if ([product.idPessoa isEqualToString:(NSString *)[[GlobalFunctions getUserDefaults] valueForKey:@"garagem"]]) {
            [buttonDeleteProduct setHidden:NO];
            [buttonEditProduct setHidden:NO];
            [viewControl setBackgroundColor:[UIColor whiteColor]];
            [buttonDeleteProduct setUserInteractionEnabled:YES];
            [buttonEditProduct setUserInteractionEnabled:YES];
        } else
            [viewControl.layer addSublayer:newShadow];

        [activityIndicator stopAnimating];
    }
}

- (void)getResourcePathGarage {
    RKObjectMapping *garageMapping = [Mappings getGarageMapping];
    
    if (self.isIdPersonNumber)
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", [[self.arrayProfile objectAtIndex:0] garagem]]
                                  objectMapping:garageMapping delegate:self];
    else
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", self.product.idPessoa]
                                  objectMapping:garageMapping delegate:self];
    
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

-(void)popover:(id)sender
{
    sharePopOverViewController *sharePopOverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sharePopOver"];
    
    sharePopOverVC.description = labelDescricao.text;
    sharePopOverVC.imgProduct = imageView.image;
    sharePopOverVC.parent = self;
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:sharePopOverVC];
        
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(300, 500);
    }
    else {
        popover.contentSize = CGSizeMake(170, 145);
    }
    
    popover.arrowDirection = FPPopoverArrowDirectionUp;
        
    UIView* btnView = sender;
    
    //sender is the UIButton view
    [popover presentPopoverFromView:btnView];
}

-(void)topRight:(id)sender
{
    [self popover:self.navigationItem.rightBarButtonItem.customView];
}

- (void)getResourcePathProfile {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    RKObjectMapping *prolileMapping = [Mappings getProfileMapping];
    
    if (self.isIdPersonNumber)
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", self.product.idPessoa]
                                  objectMapping:prolileMapping delegate:self];
    else
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", [[self.arrayGarage objectAtIndex:0] idPerson]]
                                  objectMapping:prolileMapping delegate:self];
    
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathProduct{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    RKObjectMapping *productMapping = [Mappings getProductMapping];
    
    //LoadUrlResourcePath
    if (self.isIdPersonNumber)
        [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat: @"/product/%@?idProduct=%@",
                                                      [[self.arrayGarage objectAtIndex:0] idPerson], self.product.id ] objectMapping:productMapping delegate:self];
    else
        [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat: @"/product/%@?idProduct=%@",
                                                      self.product.idPessoa, self.product.id ] objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathProductPhotos{
    RKObjectMapping *photoMapping = [Mappings getPhotoMapping];
    RKObjectMapping *productPhotoMapping = [Mappings getProductPhotoMapping];
    
    //Relationship
    [productPhotoMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@/?idProduct=%@", [[self.arrayProfile objectAtIndex:0] garagem], self.product.id] objectMapping:productPhotoMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([objects count] > 0) {
        if ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
            arrayGarage = objects;
            if (!self.isIdPersonNumber)
                [self getResourcePathProfile];
        }else if  ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
            arrayProfile = objects;
            if (self.isIdPersonNumber)
                [self getResourcePathGarage];
            [self getResourcePathProduct];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[Product class]]){
            arrayTags = [(Product *)[objects objectAtIndex:0] categorias];
            [product setDescricao:[(Product *)[objects objectAtIndex:0] descricao]];
            [self loadAttribsToComponents:YES];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[ProductPhotos class]]){
            productPhotos = (NSMutableArray *)objects;
        }
    }
}

- (IBAction)gotoProductAccountVC:(id)sender{
    productAccountViewController *prdAccVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productAccount"];
    prdAccVC.product   = self.product;
    [self.navigationController pushViewController:prdAccVC animated:YES];
}

-(IBAction)bidPost:(id)sender{
    //Validate fields
    if (([txtViewComment.text length] == 0)) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"fieldsRequired", @"")
                                                      message:NSLocalizedString(@"enterValueProduct", @"")
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        return;
    } else if([txtFieldEmail.text length] == 0 || ![GlobalFunctions isValidEmail:txtFieldEmail.text]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"fieldsRequired", @"")
                                                      message:NSLocalizedString(@"enterEmail", @"")
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        return;
    }
    //Post Bid Sent
    RKObjectMapping *patientSerializationMapping = [RKObjectMapping mappingForClass:[Bid class]];
    [patientSerializationMapping mapKeyPath:@"email"      toAttribute:@"email"];
    [patientSerializationMapping mapKeyPath:@"value"      toAttribute:@"value"];
    [patientSerializationMapping mapKeyPath:@"comment"    toAttribute:@"comment"];
    [patientSerializationMapping mapKeyPath:@"idProduct"  toAttribute:@"idProduct"];
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Product"
                                                     withAction:@"Bid"
                                                      withLabel:@"Product Bid"
                                                      withValue:nil];
    
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[patientSerializationMapping inverseMapping] forClass:[Bid class]];
    
    //Setting Bid Entity
    Bid* bid = [[Bid alloc] init];
    [bid setEmail:txtFieldEmail.text];
    [bid setValue:[[NSNumber alloc] initWithInt:[txtViewComment.text floatValue]]];
    [bid setComment:txtViewComment.text];
    [bid setIdProduct:[[NSNumber alloc] initWithInt:[self.product.id intValue]]];
    
    // POST bid
    [[RKObjectManager sharedManager] postObject:bid delegate:self];
    
    //Animate bidButton
    [UIView beginAnimations:@"buttonFades" context:nil];
    [UIView setAnimationDuration:0.5];
    [buttonBid setEnabled:NO];
    [buttonBid setAlpha:0.3];
    [UIView commitAnimations];
}

-(IBAction)deleteProduct:(id)sender {
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"delete-product-title", nil)
                                                     message: NSLocalizedString(@"delete-product-desc", nil)
                                                    delegate: self
                                           cancelButtonTitle: NSLocalizedString(@"delete-product-btn1", nil)
                                           otherButtonTitles: NSLocalizedString(@"delete-product-btn2", nil), nil];
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
            [[RKClient sharedClient] delete:
             [NSString stringWithFormat:@"/product/%i?token=%@&garage=%@",
              [self.product.id intValue] ,
              [[GlobalFunctions getUserDefaults] valueForKey:@"token"],
              [[GlobalFunctions getUserDefaults] valueForKey:@"garagem"]] delegate:self];
            break;
        default:
            break;
    }
}

-(IBAction)reportGarage:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"http://garagesaleapp.me/%@/reportAbuse", self.product.idPessoa];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *urlData;
    NSURLResponse *response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"report-title", nil)
                                                    message: NSLocalizedString(@"report-desc", nil)
                                                   delegate:self
                                          cancelButtonTitle: NSLocalizedString(@"report-btn1", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
    // [self getResourcePathProfile];
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
        
        [self bidSend];
        
        //Set Delay to Hide msgBidSentLabel
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideMsgBidSent) userInfo:nil repeats:NO];
        
    } else if ([request isDELETE]) {
        // Handling DELETE /missing_resource.txt
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"YES" forKey:@"isNewOrRemoveProduct"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popToRootViewControllerAnimated:YES];

        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

-(void)bidSend{
    //Settings to Bid Sent
    [UIView beginAnimations:@"buttonFades" context:nil];
    [UIView setAnimationDuration:0.5];
    [buttonBid setEnabled:YES];
    [buttonBid setAlpha:1.0];
    [msgBidSentLabel setAlpha:1.0];
    [viewBidSend setAlpha:0];
    [viewBidSend setHidden:YES];
    [viewBidMsg setAlpha:1.0f];
    [scrollViewMain insertSubview:viewShadow belowSubview:viewBidMsg];
    [viewBidMsg setHidden:NO];
    [UIView commitAnimations];
    
    [scrollViewMain setContentOffset:CGPointMake(0, 0) animated:YES];
    
    msgBidSentLabel.text = NSLocalizedString(@"bidSent", @"");
    [txtFieldEmail  setText:@""];
    [txtFieldOffer  setText:@""];
    [txtViewComment setText:@""];
}

-(void)loadGalleryTop:(UIPageControl *)pagContr{
    UIImage *image;
    /*copy pagCont.currentPage with NSString, we do 
     this because pagCont is instable acconding fast
     or slow scroll*/
    NSString *pageCCopy = [NSString stringWithFormat:@"%i" , pagContr.currentPage];
    [NSThread detachNewThreadSelector:@selector(loadImageGalleryThumbs:) toTarget:self 
                                   withObject:pageCCopy];
}

- (void)loadImageGalleryThumbs:(NSString *)pagContr{
    @try {
        UIImage *image;
        CGRect rect;//             = imageView.frame;
        rect.size.width         = 320;
        rect.size.height        = 280;

        Caminho *caminho = (Caminho *)[[[self.product.fotos objectAtIndex:[pagContr intValue]] caminho ] objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:[caminho mobile]];

        image                   = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        imageView               = [[UIImageView alloc] initWithImage:image];
        rect.origin.x           = [pagContr intValue]*320;
        [imageView setFrame:rect];
        imageView.contentMode   = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [galleryScrollView addSubview:imageView];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //imageView.frame = [self centeredFrameForScrollView:scrollView andUIView:imageView];
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    CGSize boundsSize    = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //check if countPicsAtGallery+1 is out of bounds
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.delegate = self;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [PagContGallery setCurrentPage:galleryScrollView.contentOffset.x / self.view.frame.size.width];
    //[countLabel setText:[NSString stringWithFormat:@"%i/%i", PagContGallery.currentPage+1, PagContGallery.numberOfPages]];
    
    NSString *titleCount = [NSString stringWithFormat:@"%i/%i", PagContGallery.currentPage+1, PagContGallery.numberOfPages];
    NSMutableAttributedString* attrStrCount = [NSMutableAttributedString attributedStringWithString:titleCount];
    [attrStrCount setFont:[UIFont fontWithName:@"Droid Sans" size:20]];
    [attrStrCount setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
    [attrStrCount setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.f]
                         range:[titleCount rangeOfString:[NSString stringWithFormat:@"/%i", PagContGallery.numberOfPages]]];
    [countLabel setBackgroundColor:[UIColor clearColor]];
    countLabel.attributedText = attrStrCount;

    NSLog(@"Current Page %i",PagContGallery.currentPage);
    NSLog(@"nextPageGallery %i",nextPageGallery);

        //never repeat load image at your respective page.
        if (nextPageGallery < [self.product.fotos count] && PagContGallery.currentPage == nextPageGallery) {
            NSOperationQueue *queue = [NSOperationQueue new];
            UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] init];
            [actInd startAnimating];
            [actInd setColor:[UIColor grayColor]];
            [actInd setCenter:CGPointMake(160+(320*PagContGallery.currentPage), 140)];
            [galleryScrollView addSubview:actInd];
            NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                                initWithTarget:self
                                                selector:@selector(loadGalleryTop:)
                                                object:PagContGallery];
            [queue addOperation:operation];
            nextPageGallery++;
        }
}

-(void) hideMsgBidSent {
    [UIView beginAnimations:@"msgFade" context:nil];
    [UIView setAnimationDuration:0.5];
    [msgBidSentLabel setAlpha:0.0];
    [UIView commitAnimations];
}

- (void)setLoadAnimation{
    NSArray *imageArray;
    
    imageArray = [[NSArray alloc] initWithObjects:
                  [UIImage imageNamed:@"load-frame1.png"],
                  [UIImage imageNamed:@"load-frame2.png"],
                  [UIImage imageNamed:@"load-frame3.png"],
                  [UIImage imageNamed:@"load-frame4.png"],nil];
}

- (IBAction)gotoGalleryScrollVC{
    galleryScrollViewController *galleryScrollVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryProduct"];
    [galleryScrollVC setIdPessoa:[[self.arrayProfile objectAtIndex:0] garagem]];
    [galleryScrollVC setIdProduto:self.product.id];
    [self.navigationController pushViewController:galleryScrollVC animated:YES];
}

- (IBAction)gotoGarageDetailVC{
    
    if ([[self.navigationController viewControllers] count] >= 4)
        [self.navigationController popViewControllerAnimated:YES];
    else {
        garageAccountViewController *garaAcc = [self.storyboard instantiateViewControllerWithIdentifier:@"garageAccount"];
        [garaAcc setProfile:(Profile *)[arrayProfile objectAtIndex:0]];
        [garaAcc setGarage:(Garage *)[arrayGarage objectAtIndex:0]];
        [garaAcc setImageGravatar:buttonGarageDetail.imageView.image];
        garaAcc.isGenericGarage = YES;
        [self.navigationController pushViewController:garaAcc animated:YES];
    }
}

- (IBAction)gotoUserProductTableVC{
    productTableViewController *prdTabVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    [prdTabVC setStrLocalResourcePath:[NSString stringWithFormat:@"/product/%@", [[self.arrayProfile objectAtIndex:0] garagem]]];
    [self.navigationController pushViewController:prdTabVC animated:YES];
}

- (void)gotoProductTableVC:(UIButton *)sender{
    productTableViewController *prdTbl = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    //filter by Category
    [prdTbl setStrLocalResourcePath:[NSString stringWithFormat:@"/product?category=%@", [[sender titleLabel] text] ]];
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

- (IBAction)animationBidView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];
    
    if (viewBidSend.hidden && viewBidMsg.hidden) {
        [scrollViewMain insertSubview:viewBidMsg belowSubview:viewBidSend];
        [scrollViewMain insertSubview:viewShadow belowSubview:viewBidSend];
        [viewBidSend setHidden:NO];
        [viewBidMsg setHidden:NO];
        [viewBidSend setAlpha:1.0];
        [viewShadow setAlpha:0.7];
        [countView setAlpha:0];
        [UIView commitAnimations];
    } else {
        [viewBidSend setAlpha:0];
        [viewShadow setAlpha:0];
        [viewBidSend setHidden:YES];
        [viewBidMsg setHidden:YES];
        [countView setAlpha:1.0];
        [viewShadow removeFromSuperview];
    }
    
    [UIView commitAnimations];
}

- (IBAction)isNumberKey:(UITextField *)textField{
    [GlobalFunctions onlyNumberKey:textField];
}

- (void)setupKeyboardControls
{
    // Initialize the keyboard controls
    self.keyboardControls = [[BSKeyboardControls alloc] init];
    
    // Set the delegate of the keyboard controls
    self.keyboardControls.delegate = self;
    
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    self.keyboardControls.textFields = [NSArray arrayWithObjects:txtFieldEmail,
                                        txtViewComment, nil];
    
    // Set the style of the bar. Default is UIBarStyleBlackTranslucent.
    self.keyboardControls.barStyle = UIBarStyleBlackTranslucent;
    
    // Set the tint color of the "Previous" and "Next" button. Default is black.
    self.keyboardControls.previousNextTintColor = [UIColor blackColor];
    
    // Set the tint color of the done button. Default is a color which looks a lot like the original blue color for a "Done" butotn
    self.keyboardControls.doneTintColor = [UIColor colorWithRed:34.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    // Set title for the "Previous" button. Default is "Previous".
    self.keyboardControls.previousTitle = NSLocalizedString(@"keyboard-previous-btn", nil);
    
    // Set title for the "Next button". Default is "Next".
    self.keyboardControls.nextTitle =  NSLocalizedString(@"keyboard-next-btn", nil);
    
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

- (void)scrollViewToTextField:(id)textField
{
    UIScrollView* v = (UIScrollView*) scrollViewMain;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:v];
    
    rc.size.height = 300;
    [scrollViewMain scrollRectToVisible:rc animated:YES];
    
}

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
    [sender resignFirstResponder];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
    if (indexOfTab == 1 && ![[[GlobalFunctions getUserDefaults] objectForKey:@"isProductDisplayed"] boolValue]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"keyboard-cancel-btn", nil) 
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"sheet-camera-item", nil),
                                                                    NSLocalizedString(@"sheet-library-item", nil),
                                                                    NSLocalizedString(@"sheet-no-pic-item", nil),
                                                                    nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.view];
        [sheet showFromTabBar:self.tabBarController.tabBar];
        return NO;
    } else {
        return YES;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [GlobalFunctions setActionSheetAddProduct:self.tabBarController clickedButtonAtIndex:buttonIndex];
}

- (void)viewDidUnload
{
    txtFieldEmail = nil;
    txtFieldOffer = nil;
    txtViewComment = nil;
    [self setTxtFieldEmail:nil];
    [self setTxtFieldOffer:nil];
    [self setTxtViewComment:nil];
    labelNameProfile = nil;
    labelCityProfile = nil;
    labelEmailProfile = nil;
    [self setLabelNameProfile:nil];
    [self setLabelCityProfile:nil];
    [self setLabelEmailProfile:nil];
    buttonBid = nil;
    [self setButtonBid:nil];
    [self setButtonGarageDetail:nil];
    buttonGarageDetail = nil;
    msgBidSentLabel = nil;
    [self setMsgBidSentLabel:nil];
    secondView = nil;
    [self setSecondView:nil];
    garageDetailView = nil;
    viewBidSend = nil;
    viewBidMsg = nil;
    [self setViewBidSend:nil];
    [self setViewBidMsg:nil];
    countView = nil;
    [self setCountView:nil];
    countLabel = nil;
    [self setCountLabel:nil];
    buttonEditProduct = nil;
    [self setButtonEditProduct:nil];
    viewControl = nil;
    [self setViewControl:nil];
    viewReport = nil;
    [self setViewReport:nil];
    buttonDeleteProduct = nil;
    [self setButtonDeleteProduct:nil];
    [super viewDidUnload];
    
    labelEmail = nil;
    labelOffer = nil;
    labelAskSomething = nil;
    labelCongrats = nil;
    labelBidSent= nil;
    
    [self setLabelEmail:nil];
    [self setLabelOffer:nil];
    [self setLabelAskSomething:nil];
    [self setLabelCongrats:nil];
    [self setLabelBidSent:nil];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
