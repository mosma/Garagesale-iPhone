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
@synthesize buttonBid;
@synthesize txtFieldEmail;
@synthesize txtFieldOffer;
@synthesize txtViewComment;
@synthesize labelNomeProduto;
@synthesize labelDescricao;
@synthesize labelCurrency;
@synthesize OHlabelValorEsperado;
@synthesize scrollViewMain;
@synthesize labelNameProfile;
@synthesize labelCityProfile;
@synthesize labelEmailProfile;
@synthesize buttonGarageDetail;
@synthesize offerLabel;
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
@synthesize PagContGallery;

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

        buttonBid.layer.cornerRadius            = 5.0f;
        buttonGarageDetail.layer.cornerRadius   = 5.0f;
        
        viewShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1200)];
        [viewShadow setBackgroundColor:[UIColor blackColor]];
        viewShadow.alpha = 0;
        
        viewBidSend.alpha = 0;
        viewBidSend.layer.cornerRadius = 5;
        
        viewBidMsg.alpha = 0;
        viewBidMsg.layer.cornerRadius = 5;
        
        [txtFieldEmail   setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        [txtViewComment  setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        [labelDescricao   setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        
        //Set Labels, titles, TextView...
        labelNomeProduto.text            = [self.product nome];
        
        labelDescricao.text       = [self.product descricao];
        
        OHlabelValorEsperado.text   = [self.product valorEsperado];
        
        //set Navigation Title with OHAttributeLabel
        NSString *titleNavItem = [NSString stringWithFormat:@"%@%@", self.product.currency, self.product.valorEsperado];
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:titleNavItem];
        // NSLog(@"Available Font Families: %@", [UIFont familyNames]);
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
        [attrStr setTextColor:[UIColor grayColor]];
        [attrStr setTextColor:[UIColor colorWithRed:91.0/255.0 green:148.0/255.0 blue:67.0/255.0 alpha:1.f]
                        range:[titleNavItem rangeOfString:self.product.valorEsperado]];
        [attrStr setFontName:@"Droid Sans" size:28 range:[titleNavItem rangeOfString:self.product.valorEsperado]];
        [OHlabelValorEsperado setBackgroundColor:[UIColor clearColor]];
        OHlabelValorEsperado.attributedText = attrStr;

        
        self.navigationItem.leftBarButtonItem = [GlobalFunctions getIconNavigationBar:
                                                 @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];

        labelCurrency.text        = [self.product currency];
        offerLabel.text           = NSLocalizedString(@"offer", @"");
        
        CGRect rect;//             = imageView.frame;
        
        rect.size.width         = 320;
        rect.size.height        = 280;
        rect.origin.x             = 0;
        imageView.frame         = rect;
        
        
        galleryScrollView.frame                 = CGRectMake(0, 115, 320, 320);
        galleryScrollView.clipsToBounds         = YES;
        galleryScrollView.autoresizesSubviews   = YES;
        [galleryScrollView addSubview:imageView];

        countView.layer.cornerRadius = 4;
        [secondView addSubview:garageDetailView];
        scrollViewMain.contentSize             = CGSizeMake(320,550+labelDescricao.frame.size.height);

        
        
    }else {
        [buttonBid setTitle: NSLocalizedString(@"bid", @"") forState:UIControlStateNormal];
        
        // Grab the reference to the router from the manager
        RKObjectRouter *router = [RKObjectManager sharedManager].router;
        
        @try {
            [router routeClass:[Bid class] toResourcePath:@"/bid" forMethod:RKRequestMethodPOST];
        }
        @catch (NSException *exception) {
            NSLog(@"Object Exist...");
        }
        
        labelNameProfile.text    = [[self.arrayProfile objectAtIndex:0] nome];
        labelCityProfile.text    = [[self.arrayGarage objectAtIndex:0] city];
        labelEmailProfile.text   = [[self.arrayProfile objectAtIndex:0] email];
         
        UIImage *imgProfile = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[GlobalFunctions getGravatarURL:[[self.arrayProfile objectAtIndex:0] email]]]];
        
        [buttonGarageDetail setImage:imgProfile forState:UIControlStateNormal];
        
        //set Navigation Title with OHAttributeLabel
        NSString *titleNavItem = [NSString stringWithFormat:@"%@ garage", labelNameProfile.text];
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
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];

        //Calculate resize DescricaoLabel 
            labelDescricao.text = self.product.descricao;
            [labelDescricao sizeToFit];
            secondView.frame = CGRectMake(0,0,320,550+labelDescricao.frame.size.height);
            garageDetailView.frame = CGRectMake(0, labelDescricao.frame.origin.y+labelDescricao.frame.size.height+10, 320, 70);
            //[self.tagsScrollView initWithFrame:CGRectMake(13,  garageDetailView.frame.origin.y+garageDetailView.frame.size.height+100, 307, 200)];
            [secondView addSubview:labelDescricao];
            // [secondView addSubview:tagsScrollView];
            [secondView addSubview:garageDetailView];
            scrollViewMain.contentSize             = CGSizeMake(320,550+labelDescricao.frame.size.height);
                
        [UIView commitAnimations];
        
        
        
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
                                                    description:labelDescricao.text];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addThisButton];

        int countPhotos = (int)[[(ProductPhotos *)[productPhotos objectAtIndex:0] fotos ] count];
        
        PagContGallery = [[UIPageControl alloc] init];
        PagContGallery.numberOfPages = countPhotos;
        
        
        if (countPhotos != 0) {
            [scrollViewMain insertSubview:countView aboveSubview:galleryScrollView];
            countLabel.text = [NSString stringWithFormat:@"1/%i", PagContGallery.numberOfPages];
        } else 
            countView.hidden = YES;

        UIImage *image;

        if (self.product.fotos == NULL) {
            image                   = [UIImage imageNamed:@"nopicture.png"];
            imageView               = [[UIImageView alloc] initWithImage:image];            
        } else {
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [GlobalFunctions getUrlImagePath], [self.product.fotos caminho]]];
            image                   = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            imageView               = [[UIImageView alloc] initWithImage:image];
            
        }


        
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadGalleryTop)
                                            object:nil];
        [queue addOperation:operation];
        
    }
}

-(void)loadGalleryTop{

    int countPhotos = (int)[[(ProductPhotos *)[productPhotos objectAtIndex:0] fotos ] count];
        
    UIImage *image;
    CGRect rect;//             = imageView.frame;
    rect.size.width         = 320;
    rect.size.height        = 280;
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.4];
    //    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];
    
    for (int i = 0; i < countPhotos; i++){

        
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
        [activityIndicator startAnimating];
        activityIndicator.color = [UIColor grayColor];
        
        activityIndicator.center = CGPointMake(160+(320*i), 140);
        
        [galleryScrollView addSubview:activityIndicator];
        
        if (countPhotos == 0) {
            image                   = [UIImage imageNamed:@"nopicture.png"];
            imageView               = [[UIImageView alloc] initWithImage:image];
            imageView.frame         = rect;
            [galleryScrollView addSubview:imageView];
        }else {
            NSNumber *index = [NSNumber numberWithInt:i];
            [NSThread detachNewThreadSelector:@selector(loadImageGalleryThumbs:) toTarget:self 
                                   withObject:index];
        }
    }
    
    galleryScrollView.contentSize           = CGSizeMake(self.view.frame.size.width * countPhotos, 320);
    galleryScrollView.delegate              = self;
    //    [UIView commitAnimations];
}

- (void)loadImageGalleryThumbs:(NSNumber *)index{
    @try {
        
        int i = [index intValue];
        UIImage *image;
        CGRect rect;//             = imageView.frame;
        rect.size.width         = 320;
        rect.size.height        = 280;
        
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [GlobalFunctions getUrlImagePath], [[[(ProductPhotos *)[productPhotos objectAtIndex:0]fotos]objectAtIndex:i]caminho]]];
            //NSLog(@"url object at index %i is %@",i,url);
            image                   = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            imageView               = [[UIImageView alloc] initWithImage:image];
            rect.origin.x           = i*320;
            imageView.frame         = rect;
            // imageView.contentMode   = UIViewContentModeScaleAspectFit;
            [galleryScrollView addSubview:imageView];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
   // [self setupProfileMapping];
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
        [buttonBid setEnabled:YES];
        [buttonBid setAlpha:1.0];
        [msgBidSentLabel setAlpha:1.0];
        [viewBidSend setAlpha:0];
        viewBidSend.hidden = YES;
        [viewBidMsg setAlpha:1.0f];
        [scrollViewMain insertSubview:viewShadow belowSubview:viewBidMsg];
        viewBidMsg.hidden = NO;        
        [UIView commitAnimations];
        
        [scrollViewMain setContentOffset:CGPointMake(0, 0) animated:YES];
        
        msgBidSentLabel.text = NSLocalizedString(@"bidSent", @"");
        txtFieldEmail.text  = @"";
        txtFieldOffer.text  = @"";
        txtViewComment.text  = @"";

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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    PagContGallery.currentPage = galleryScrollView.contentOffset.x / self.view.frame.size.width;
    countLabel.text = [NSString stringWithFormat:@"%i/%i", PagContGallery.currentPage+1, PagContGallery.numberOfPages];
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
    
    garageAccountViewController *garaAcc = [self.storyboard instantiateViewControllerWithIdentifier:@"garageAccount"];

    
    garaAcc.profile = (Profile *)[arrayProfile objectAtIndex:0];
    garaAcc.garage =  (Garage *)[arrayGarage objectAtIndex:0];
    
      
    [self.navigationController pushViewController:garaAcc animated:YES];
    
//    garageDetailViewController *garageDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GarageDetail"];
//    garageDetailVC.garage = self.arrayGarage;
//    garageDetailVC.profile = self.arrayProfile;
//    garageDetailVC.gravatarUrl = [GlobalFunctions getGravatarURL:[[self.arrayProfile objectAtIndex:0] email]];
//    [self.navigationController pushViewController:garageDetailVC animated:YES];
//    
//    //Custom Title Back Bar Button Item
//    self.navigationController.navigationBar.backItem.title = NSLocalizedString(@"back", @"");
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
    
    if (viewBidSend.hidden && viewBidMsg.hidden) {
        [scrollViewMain insertSubview:viewBidMsg belowSubview:viewBidSend];
        [scrollViewMain insertSubview:viewShadow belowSubview:viewBidSend];
        viewBidSend.hidden = NO;
        viewBidMsg.hidden = NO;
        viewBidSend.alpha = 1.0;
        viewShadow.alpha = 0.7;
        countView.alpha = 0;
        [UIView commitAnimations];
    } else {
        viewBidSend.alpha = 0;
        viewShadow.alpha = 0;
        viewBidSend.hidden = YES;
        viewBidMsg.hidden = YES;
        countView.alpha = 1.0;
        [viewShadow removeFromSuperview];
    }
    
    [UIView commitAnimations];
}

-(IBAction)bidPost:(id)sender{
    //Validate fields
    if (([txtViewComment.text length] == 0)) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"fieldsRequired", @"") message:NSLocalizedString(@"enterValueProduct", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    } else if([txtFieldEmail.text length] == 0 || ![GlobalFunctions isValidEmail:txtFieldEmail.text]) {
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
    bid.email = txtFieldEmail.text;  
    bid.value = [[NSNumber alloc] initWithInt:[txtViewComment.text floatValue]];
    bid.comment = txtViewComment.text;
    bid.idProduct =  [[NSNumber alloc] initWithInt:[self.product.id intValue]]; 
    
    // POST bid  
    [[RKObjectManager sharedManager] postObject:bid delegate:self];
     
    //Animate bidButton
    [UIView beginAnimations:@"buttonFades" context:nil];
    [UIView setAnimationDuration:0.5];
    [buttonBid setEnabled:NO];
    [buttonBid setAlpha:0.3];
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
    self.keyboardControls.textFields = [NSArray arrayWithObjects:txtFieldEmail,
                                        txtViewComment, nil];
    
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
    UIScrollView* v = (UIScrollView*) scrollViewMain;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:v];
    
    rc.size.height = 300;
    [scrollViewMain scrollRectToVisible:rc animated:YES];
    
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
    viewBidMsg = nil;
    [self setViewBidSend:nil];
    [self setViewBidMsg:nil];
    countView = nil;
    [self setCountView:nil];
    countLabel = nil;
    [self setCountLabel:nil];
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
