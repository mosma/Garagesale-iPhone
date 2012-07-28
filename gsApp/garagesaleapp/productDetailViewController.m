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
@synthesize nameProfile;
@synthesize cityProfile;
@synthesize emailProfile;
@synthesize imgProfile;
@synthesize showPicsButton;
@synthesize garageDetailButton;
@synthesize seeAllButton;
@synthesize offerLabel;
@synthesize msgBidSentLabel;
@synthesize secondView;
@synthesize garageDetailView;
@synthesize keyboardControls;

@synthesize productPhotos;
@synthesize idPessoa;
@synthesize idProduto;
@synthesize imageView;
@synthesize galleryScrollView;
@synthesize activityIndicator;
@synthesize viewBidSend;

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
    
    //Setup Scroll animate to TextFields
    [self setupKeyboardControls];
    
    //Set SerializationMIMEType
    RKObjManeger.acceptMIMEType          = RKMIMETypeJSON;
    RKObjManeger.serializationMIMEType   = RKMIMETypeJSON;
    self.navigationItem.hidesBackButton = YES;
    [self setLoadAnimation];
   // [self.imgViewLoading startAnimating];

   [self loadAttribsToComponents:NO];
    
    [super viewDidLoad];

    //Check if Flag isIdPersonNumber is name or number
    if (isIdPersonNumber) {
        [self setupProfileMapping];
    } else{
        [self setupGarageMapping];
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
   
    if (!isFromLoadObject) {
        /*
         Esta verificaçao esta errada... bbbba garagem pode
         ter so numeros ?
         */
        self.isIdPersonNumber = [[NSCharacterSet decimalDigitCharacterSet] 
                                 characterIsMember:[self.product.idPessoa characterAtIndex:0]];
        
        //Custom Title Back Bar Button Item
//        UIImage *image = [UIImage imageNamed: @"nopicture.png"];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
        
        
        //self.navigationController.navigationBar.backItem.titleView = imageView;
        
        
        //Show Navigation bar
        [self.navigationController setNavigationBarHidden:NO];

        bidButton.layer.cornerRadius            = 5.0f;
        garageDetailButton.layer.cornerRadius   = 5.0f;
        seeAllButton.layer.cornerRadius         = 5.0f;
        
        shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1200)];
        [shadowView setBackgroundColor:[UIColor blackColor]];
        shadowView.alpha = 0;
        viewBidSend.alpha = 0;
        
        viewBidSend.layer.cornerRadius = 5;
        
  //      commentTextView.layer.cornerRadius = 10;
        
        commentTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"uitextViewBackground.png"]];
        
        emailTextField.layer.shadowOpacity = 0.0;   
        emailTextField.layer.shadowRadius = 0.0;
        emailTextField.layer.shadowColor = [UIColor clearColor].CGColor;

        garageDetailView.userInteractionEnabled = NO;

        //Set Labels, titles, TextView...
        nomeLabel.text            = [self.product nome];
        
        
        valorEsperadoLabel.text   = [self.product valorEsperado];
        
        //set Navigation Title with OHAttributeLabel
        NSString *titleNavItem = [NSString stringWithFormat:@"%@%@", self.product.currency, self.product.valorEsperado];
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:titleNavItem];
        // NSLog(@"Available Font Families: %@", [UIFont familyNames]);
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
        [attrStr setTextColor:[UIColor grayColor]];
        [attrStr setTextColor:[UIColor colorWithRed:91.0/255.0 green:148.0/255.0 blue:67.0/255.0 alpha:1.f]
                        range:[titleNavItem rangeOfString:self.product.valorEsperado]];
        [attrStr setFontName:@"Droid Sans" size:28 range:[titleNavItem rangeOfString:self.product.valorEsperado]];
        [valorEsperadoLabel setBackgroundColor:[UIColor clearColor]];
        valorEsperadoLabel.attributedText = attrStr;

        
        self.navigationItem.leftBarButtonItem = [GlobalFunctions getIconNavigationBar:
                                                 @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];

        currencyLabel.text        = [self.product currency];
        offerLabel.text           = NSLocalizedString(@"offer", @"");

        //self.navigationItem.hidesBackButton = NO;

        descricaoLabel.text = [NSString stringWithFormat:@"%@...", self.product.descricao];

        galleryScrollView.frame                 = CGRectMake(0, 115, 320, 320);
        galleryScrollView.clipsToBounds         = YES;
        galleryScrollView.autoresizesSubviews   = YES;
        
    }else {
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
        
        
        //    //Set Image Main Image Detail to show
        //    if ([[[self.product fotos] caminho] length] != 0){
        //        UIImage *imageSet = [UIImage imageWithData: [NSData dataWithContentsOfURL: 
        //                                                     [NSURL URLWithString:[NSString stringWithFormat:@"http://www.garagesaleapp.me/%@", 
        //                                                                           [[self.product fotos] caminho]]]]];
        //        
        //        imageView.image = imageSet;
        //        //Set proporcional image, center.
        //        if (imageSet.size.width < 320 ){
        //            imageView.frame = CGRectMake(((320-imageSet.size.width)/2), 115, imageSet.size.width, 265);
        //            imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        }
        //        showPicsButton.hidden = NO;
        //    }
        //    else
        //        imageView.image = [UIImage imageNamed:@"nopicture.png"];
        
        nameProfile.text    = [[self.arrayProfile objectAtIndex:0] nome];
        cityProfile.text    = [[self.arrayGarage objectAtIndex:0] city];
        emailProfile.text   = [[self.arrayProfile objectAtIndex:0] email];
        imgProfile.image    = [UIImage imageWithData: [NSData dataWithContentsOfURL:
                                                       [GlobalFunctions getGravatarURL:[[self.arrayProfile objectAtIndex:0] email]]]];
        
        
        //set Navigation Title with OHAttributeLabel
            NSString *titleNavItem = [NSString stringWithFormat:@"%@ garage", nameProfile.text];
            NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:titleNavItem];
            // NSLog(@"Available Font Families: %@", [UIFont familyNames]);
            [attrStr setFont:[UIFont fontWithName:@"Corben" size:13]];
            [attrStr setTextColor:[UIColor whiteColor]];
            [attrStr setTextColor:[UIColor colorWithRed:244.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.f]
                            range:[titleNavItem rangeOfString:@"garage"]];
            CGRect frame = CGRectMake(100, 0, 320, 27);
            OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:frame];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setShadowColor:[UIColor redColor]];
            [label setShadowOffset:CGSizeMake(1, 1)];
            label.attributedText = attrStr;
            label.textAlignment = UITextAlignmentCenter;
            self.navigationItem.titleView = label;
        
        //Calculate resize DescricaoLabel 
            descricaoLabel.text = self.product.descricao;
            [descricaoLabel sizeToFit];
            secondView.frame = CGRectMake(0,0,320,550+descricaoLabel.frame.size.height);
            garageDetailView.frame = CGRectMake(0, descricaoLabel.frame.origin.y+descricaoLabel.frame.size.height+10, 320, 70);
            //[self.tagsScrollView initWithFrame:CGRectMake(13,  garageDetailView.frame.origin.y+garageDetailView.frame.size.height+100, 307, 200)];
            [secondView addSubview:descricaoLabel];
            // [secondView addSubview:tagsScrollView];
            [secondView addSubview:garageDetailView];
            self.scrollView.contentSize             = CGSizeMake(320,550+descricaoLabel.frame.size.height);
        
        
        //configure addthis -- (this step is optional)
            [AddThisSDK setNavigationBarColor:[GlobalFunctions getColorRedNavComponets]];
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
            
            addThisButton = [AddThisSDK showAddThisButtonInView: self.navigationItem.rightBarButtonItem
                                                      withFrame:CGRectMake(225, 305, 36, 30)
                                                       forImage:imageView.image
                                                      withTitle:@"Product Send from Garagesaleapp.me"
                                                    description:descricaoLabel.text];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addThisButton];
        
        [activityIndicatorGarage stopAnimating];
        garageDetailView.userInteractionEnabled = YES;
        
        UIImage *image;
        CGRect rect;//             = imageView.frame;
        
        
        if (self.product.fotos == NULL) {
            image                   = [UIImage imageNamed:@"nopicture.png"];
            imageView               = [[UIImageView alloc] initWithImage:image];            
        } else {
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.garagesaleapp.in/%@",  [self.product.fotos caminho]]];
            image                   = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            imageView               = [[UIImageView alloc] initWithImage:image];
            
        }
        
        rect.size.width         = 320;
        rect.size.height        = 280;
        rect.origin.x             = 0;
        imageView.frame         = rect;
        
        [galleryScrollView addSubview:imageView];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadGalleryTop)
                                            object:nil];
        [queue addOperation:operation];
        
       // [self loadGalleryTop];
    }

    //    [self.imgViewLoading stopAnimating];
    //    [self.imgViewLoading setHidden:YES];
    
    // [GlobalFunctions drawTagsButton:self.tags scrollView:self.scrollview viewController:self];
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadGalleryTop{
    int countPhotos = (int)[[(ProductPhotos *)[productPhotos objectAtIndex:0] fotos ] count];
    
    UIImage *image;
    CGRect rect;//             = imageView.frame;
    rect.size.width         = 320;
    rect.size.height        = 280;

    if (countPhotos == 0) {
        image                   = [UIImage imageNamed:@"nopicture.png"];
        imageView               = [[UIImageView alloc] initWithImage:image];
        imageView.frame         = rect;

        [galleryScrollView addSubview:imageView];
    }
    
    for (int i = 0; i < countPhotos; i++){
        if (i > 1) break;
        NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.garagesaleapp.in/%@",[[[(ProductPhotos *)[productPhotos objectAtIndex:0]fotos]objectAtIndex:i]caminho]]];
        NSLog(@"url object at index %i is %@",i,url);
        image                   = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        imageView               = [[UIImageView alloc] initWithImage:image];
        rect.origin.x           = i*320;
        imageView.frame         = rect;
       // imageView.contentMode   = UIViewContentModeScaleAspectFit;
        [galleryScrollView addSubview:imageView];
    }

    galleryScrollView.contentSize           = CGSizeMake(self.view.frame.size.width * countPhotos, 320);
    galleryScrollView.delegate              = self;
    [activityIndicator stopAnimating];
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


- (void)setupProductPhotosMapping{
    //Initializing the Object Manager
   // RKObjManeger = [RKObjectManager sharedManager];
    
    //Configure Photo Object Mapping
    RKObjectMapping *photoMapping = [RKObjectMapping mappingForClass:[Photo class]];
    [photoMapping mapAttributes:@"caminho",
     @"caminhoThumb",
     @"caminhoTiny",
     @"principal",
     @"idProduto",
     @"id",
     @"id_estado",
     nil];
    
    //Configure Product Object Mapping
    RKObjectMapping *productPhotoMapping = [RKObjectMapping mappingForClass:[ProductPhotos class]];    
    [productPhotoMapping mapKeyPath:@"sold"          toAttribute:@"sold"];
    [productPhotoMapping mapKeyPath:@"showPrice"     toAttribute:@"showPrice"];
    [productPhotoMapping mapKeyPath:@"currency"      toAttribute:@"currency"];
    [productPhotoMapping mapKeyPath:@"categorias"    toAttribute:@"categorias"];
    [productPhotoMapping mapKeyPath:@"valorEsperado" toAttribute:@"valorEsperado"];    
    [productPhotoMapping mapKeyPath:@"descricao"     toAttribute:@"descricao"];
    [productPhotoMapping mapKeyPath:@"nome"          toAttribute:@"nome"];
    [productPhotoMapping mapKeyPath:@"idEstado"      toAttribute:@"idEstado"];
    [productPhotoMapping mapKeyPath:@"idPessoa"      toAttribute:@"idPessoa"];
    [productPhotoMapping mapKeyPath:@"id"            toAttribute:@"id"];
    //Relationship
    [productPhotoMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@/?idProduct=%@", [[self.arrayProfile objectAtIndex:0] garagem], self.product.id] objectMapping:productPhotoMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/plain"];

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
            //[self loadAttribsToComponents];
            [self setupProductPhotosMapping];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[ProductPhotos class]]){
            self.productPhotos = (NSMutableArray *)objects;
            [self loadAttribsToComponents:YES];
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    imageView.frame = [self centeredFrameForScrollView:scrollView andUIView:imageView];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //PagContGallery.currentPage = galleryScrollView.contentOffset.x / self.view.frame.size.width;
}

-(IBAction)pageControlCliked{
    //CGPoint offset = CGPointMake(PagContGallery.currentPage * self.view.frame.size.width, 0);
    //[galleryScrollView setContentOffset:offset animated:YES];
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
    
//    self.imgViewLoading.animationImages = imageArray;
//    self.imgViewLoading.animationDuration = 0.9;
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
    garageDetailVC.gravatarUrl = [GlobalFunctions getGravatarURL:[[self.arrayProfile objectAtIndex:0] email]];
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
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    [mail setToRecipients:[NSArray arrayWithObject:[[self.arrayProfile objectAtIndex:0] email]]];
    [mail setSubject:@"Contato Garagem."];    
    [self presentModalViewController:mail animated:YES];
}

- (IBAction)animationBidView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];
    
    if (viewBidSend.hidden) {
        [self.scrollView insertSubview:shadowView belowSubview:viewBidSend];
        viewBidSend.hidden = NO;
        viewBidSend.alpha = 1.0;
        shadowView.alpha = 0.7;
        [UIView commitAnimations];
    } else {
        viewBidSend.alpha = 0;
        shadowView.alpha = 0;
        viewBidSend.hidden = YES;
        [shadowView removeFromSuperview];
    }
    
    [UIView commitAnimations];
}

-(IBAction)bidPost:(id)sender{
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
//    [[RKObjectManager sharedManager] postObject:bid delegate:self];
     
    //Animate bidButton
    [UIView beginAnimations:@"buttonFades" context:nil];
    [UIView setAnimationDuration:0.5];
    [bidButton setEnabled:NO];
    [bidButton setAlpha:0.3];
    [UIView commitAnimations];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Sent!" message:@"Your message has been sent! \n Thank you for your feedback" delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil];
        [alert show];
    } if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed" message:@"Your email has failed to send \n Please try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)isNumberKey:(UITextField *)textField{
    [GlobalFunctions onlyNumberKey:textField];
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
    UIScrollView* v = (UIScrollView*) self.scrollView ;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:v];
    rc.origin.x = 0 ;
    rc.origin.y = -120 ;
    
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
//    imgViewLoading = nil;
//    [self setImgViewLoading:nil];
    offerLabel = nil;
    [self setOfferLabel:nil];
    msgBidSentLabel = nil;
    [self setMsgBidSentLabel:nil];
    secondView = nil;
    [self setSecondView:nil];
    garageDetailView = nil;
    addThisButton = nil;
    viewBidSend = nil;
    [super viewDidUnload];
    
    activityIndicator = nil;
    [self setActivityIndicator:nil];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
