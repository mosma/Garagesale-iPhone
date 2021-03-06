//
//  garageDetailViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 09/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "garageAccountViewController.h"
#import "NSAttributedString+Attributes.h"
#import "AsyncImageView.h"

@implementation garageAccountViewController

@synthesize tableViewProducts;
@synthesize RKObjManeger;
@synthesize emailLabel;
@synthesize imgGarageLogo;
@synthesize garageName;
@synthesize description;
@synthesize city;
@synthesize link;
@synthesize scrollViewMain;
@synthesize scrollViewProducts;
@synthesize mutArrayProducts;
@synthesize profile;
@synthesize garage;
@synthesize viewTop;
@synthesize segmentControl;
@synthesize viewSegmentArea;
@synthesize imageURLs;
@synthesize viewNoProducts;
@synthesize imageGravatar;
@synthesize labelTotalProducts;
@synthesize garageNameSearch;
@synthesize isGenericGarage;
@synthesize labelNoProduct;

- (void)awakeFromNib
{
    NSMutableArray *URLs = [NSMutableArray array];
    
    //Hide Products with idEstados == 4 "Invisible."
    for(int i = 0; i < [mutArrayProducts count]; i++)
        if (isGenericGarage)
            if ([[(Product *)[mutArrayProducts objectAtIndex:i] idEstado] intValue] == 4){
              [mutArrayProducts removeObjectAtIndex:i];
              i--;
            }
    
    if ([mutArrayProducts count ] > 0) {
        for (int x=0; x<[mutArrayProducts count]; x++) {

            NSString* urlThumb;
            @try {
                 urlThumb = [[[[[[mutArrayProducts objectAtIndex:x] fotos] objectAtIndex:0] caminho] objectAtIndex:0] mobile];
            }
            @catch (NSException *exception) {
                urlThumb = @"http://garagesaleapp.me/images/nopicture.png";
                NSLog(@"%@", exception.description);
            }
            @finally {
            }
            
            NSURL *URL = [NSURL URLWithString:urlThumb];
            if (URL)
            {
                [URLs addObject:URL];
                URL = nil;
            }
            else
            {
                NSLog(@"'%@' is not a valid URL", urlThumb);
            }
            //NSLog(@"mutArrayProducts indice : %i",x);
        }
        self.imageURLs = URLs;
        URLs = nil;
    }
    [super awakeFromNib];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [viewNoProducts setHidden:YES];
    if (IS_IPHONE_5) {
        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
        [self.scrollViewMain setFrame:CGRectMake(0, 0, 320, 568)];
        [self.scrollViewProducts setFrame:CGRectMake(0, 165, 320, 568)];
        [self.tableViewProducts setFrame:CGRectMake(0, 165, 320, 568)];
        [self.viewNoProducts setFrame:CGRectMake(0, 95, 320, 339)];
    } else {
        [self.view setFrame:CGRectMake(0, 0, 320, 480)];
        [self.scrollViewMain setFrame:CGRectMake(0, 0, 320, 480)];
        [self.scrollViewProducts setFrame:CGRectMake(0, 165, 320, 480)];
        [self.tableViewProducts setFrame:CGRectMake(0, 165, 320, 480)];
        [self.viewNoProducts setFrame:CGRectMake(0, 95, 320, 339)];
    }
    
    if (segmentControl == nil) {
        NSArray *objects = [NSArray arrayWithObjects:[UIImage imageNamed:@"btProdBlock"], [UIImage imageNamed:@"btProdList"], nil];
        
        segmentControl = [[STSegmentedControl alloc] initWithItems:objects];
        [segmentControl setFrame:CGRectMake(0, 0, 92, 31)];
        [segmentControl addTarget:self action:@selector(changeSegControl:) forControlEvents:UIControlEventValueChanged];
        [segmentControl setSelectedSegmentIndex:0];
        [segmentControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [viewSegmentArea addSubview:segmentControl];
        
        UIView *vFoot = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
        [self.tableViewProducts setTableFooterView:vFoot];
        vFoot = nil;
        
        if ([mutArrayProducts count] == 0){
            RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
            //Shadow Top below navigationBar
            CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f].CGColor;
            CGColorRef lightColor = [UIColor clearColor].CGColor;
            CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
            newShadow.frame = CGRectMake(0, 0, self.view.frame.size.width, 15);
            newShadow.colors = [NSArray arrayWithObjects:(__bridge id)darkColor, (__bridge id)lightColor, nil];
            [self.view.layer addSublayer:newShadow];
            [self loadAttribsToComponents:NO];
            [self reloadPage:nil];
        }
        objects = nil;
    }
    if (profile.garagem && !garageNameSearch)
        [self setTrackedViewName:[NSString stringWithFormat:@"/%@", profile.garagem]];
    else if (!garageNameSearch)
        [self setTrackedViewName:[NSString stringWithFormat:@"/%@",
                                  [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]]];

    self.refreshControl = [[CKRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadPage:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0]];
}

- (IBAction)reloadPage:(id)sender{
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Garage"
                                                     withAction:@"Reload"
                                                      withLabel:@"Reload Products Screen"
                                                      withValue:nil];
    [viewTop setUserInteractionEnabled:NO];

    [segmentControl setEnabled:NO];
    [self getResourcePathProduct];
    
    [scrollViewProducts setContentOffset:CGPointMake(0, 0) animated:NO];
    [tableViewProducts setContentOffset:CGPointMake(0, 0) animated:NO];

    //reload Settings.
    if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil
        && !isGenericGarage && [mutArrayProducts count] != 0)
        [settingsVC getResourcePathProfile];
}

- (void)loadAttribsToComponents:(BOOL)isFromLoadObject{
    if (!isFromLoadObject) {
        
        //Garage Session
        if (!isGenericGarage) {
            NSString *cityConc = [[GlobalFunctions getUserDefaults] objectForKey:@"city"];
            NSString *country = [[GlobalFunctions getUserDefaults] objectForKey:@"country"];
            NSString *district = [[GlobalFunctions getUserDefaults] objectForKey:@"district"];
            
            city.text = [GlobalFunctions formatAddressGarage:@[cityConc, district, country]];
            
            if ([[[GlobalFunctions getUserDefaults] objectForKey:@"about"] isEqualToString:@""])
                [description setText:NSLocalizedString(@"welcome-my-garage", @"")];
            else
                [description setText:[[GlobalFunctions getUserDefaults] objectForKey:@"about"]];
            
            [garageName setAttributedText:[GlobalFunctions
                                           getNamePerfil:[[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]
                                           profileName:[[GlobalFunctions getUserDefaults] objectForKey:@"nome"]]];

            [garageName setTextAlignment:UITextAlignmentLeft];
            
            if ([[[GlobalFunctions getUserDefaults] objectForKey:@"link"] isEqualToString:@""])
                [link setText:[NSString stringWithFormat:@"http://gsapp.me/%@",
                               [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]]];
            else
                [link setText:[[GlobalFunctions getUserDefaults] objectForKey:@"link"]];
            
            //Retrieving
            UIImage *image = (UIImage*)[NSKeyedUnarchiver
                                        unarchiveObjectWithData:
                                        [[GlobalFunctions getUserDefaults]
                                         objectForKey:[NSString stringWithFormat:@"%@_AvatarImg",
                                                        [[GlobalFunctions getUserDefaults]
                                                            objectForKey:@"garagem"]]]];
            
            NSString *noProduct = NSLocalizedString(@"new-garage-no-product", @"");
            
            NSMutableAttributedString* attrStrNoProduct = [NSMutableAttributedString attributedStringWithString:noProduct];
            
            [attrStrNoProduct setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
            
            [attrStrNoProduct setTextColor:[UIColor colorWithRed:153.0/255.0
                                                           green:153.0/255.0
                                                            blue:153.0/255.0
                                                           alpha:1.f]
                                     range:[noProduct rangeOfString:NSLocalizedString(@"ngnp1", @"")]];
            
            [attrStrNoProduct setTextColor:[UIColor colorWithRed:253.0/255.0
                                                           green:103.0/255.0
                                                            blue:102.0/255.0
                                                           alpha:1.f]
                                     range:[noProduct rangeOfString:NSLocalizedString(@"ngnp2", @"")]];
            
            
            [attrStrNoProduct setFont:[UIFont fontWithName:@"Corben" size:14]
                                range:[noProduct rangeOfString:NSLocalizedString(@"ngnp2", @"")]];
            
            [labelNoProduct setAttributedText:attrStrNoProduct];
            [labelNoProduct setTextAlignment:UITextAlignmentCenter];
            
            [imgGarageLogo setImage:image];
            
            settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
            [settingsVC setRKObjManeger:[RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]]];
            [settingsVC.RKObjManeger setAcceptMIMEType:RKMIMETypeJSON];
            [settingsVC.RKObjManeger setSerializationMIMEType:RKMIMETypeJSON];

            UIButton *btSettings = [UIButton buttonWithType:UIButtonTypeCustom];
            [btSettings setFrame:CGRectMake(0.0f, 0.0f, 38.0f, 31.0f)];
            [btSettings setImage:[UIImage imageNamed:@"btSettingsNavItem.png"] forState:UIControlStateNormal];
            [btSettings addTarget:self action:@selector(gotoSettingsVC) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithCustomView:btSettings];
            [self.navigationItem setLeftBarButtonItem:settings];
                        
            settings = nil;
            image = nil;
            btSettings = nil;
        }
        
        //Generics Garage. From SearchVC and DetailVC
        else
            [self loadHeader];
        
        if (imageGravatar)
            [imgGarageLogo setImage:imageGravatar];
        
        if (isGenericGarage){
            UIBarButtonItem *barItemBack = [GlobalFunctions getIconNavigationBar:@selector(backPage)
                                                                       viewContr:self
                                                                      imageNamed:@"btBackNav.png" rect:CGRectMake(0, 0, 40, 30)];
            
            [self.navigationItem setLeftBarButtonItem:barItemBack];
            barItemBack = nil;
        }
        
        [imgGarageLogo setContentMode:UIViewContentModeScaleAspectFit];
        
        UITapGestureRecognizer *gestReload = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadPage:)];
        [gestReload setNumberOfTapsRequired:1];
        [viewTop addGestureRecognizer:gestReload];
        gestReload = nil;
        
        [GlobalFunctions setNavigationBarBackground:self.navigationController];
        
        [self.navigationController.navigationBar setTintColor:[GlobalFunctions getColorRedNavComponets]];
        
        [city setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
        
        [city setFont:[UIFont fontWithName:@"Droid Sans" size:12]];
        [description setFont:[UIFont fontWithName:@"Droid Sans" size:12]];
        [link setFont:[UIFont fontWithName:@"DroidSans-Bold" size:12]];
        
        UITapGestureRecognizer *gestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(urlGarage:)];
        [gestureRec setNumberOfTapsRequired:1];
        [link addGestureRecognizer:gestureRec];
        gestureRec = nil;
        
        if (IS_IPHONE_5) self.scrollViewMain.contentSize  = CGSizeMake(320,735);
        else             self.scrollViewMain.contentSize  = CGSizeMake(320,647);
        
        [self.scrollViewMain setDelegate:self];
        [self.scrollViewProducts setDelegate:self];
        
        [self.navigationItem setTitle:NSLocalizedString(@"garage", @"")];
        
        self.navigationItem.hidesBackButton = NO;
        
        [self.tableViewProducts setDataSource:self];
        [self.tableViewProducts setDelegate:self];
    }
    
    // set values to objetcs from objectLoader
    else {
        [segmentControl setEnabled:YES];
        
        UITapGestureRecognizer *tapDescrip = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(gotoDescriptionVC)];
        [tapDescrip setNumberOfTapsRequired:1];
        [description addGestureRecognizer:tapDescrip];
        tapDescrip = nil;
        
        NSString *total = [NSString stringWithFormat:NSLocalizedString(@"x-products", @""), [mutArrayProducts count]];
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:total];
        
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:20]];
        [attrStr setTextColor:[UIColor colorWithRed:253.0/255.0
                                              green:103.0/255.0
                                               blue:102.0/255.0
                                              alpha:1.f]
                        range:[total rangeOfString:[NSString stringWithFormat:@"%i", [mutArrayProducts count]]]];
        
        [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0
                                              green:153.0/255.0
                                               blue:153.0/255.0
                                              alpha:1.f]
                        range:[total rangeOfString:NSLocalizedString(@"x-products-range", @"")]];
        
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:13]
                   range:[total rangeOfString:NSLocalizedString(@"x-products-range", @"")]];
        
        [attrStr setFont:[UIFont boldSystemFontOfSize:20]
                   range:[total rangeOfString:[NSString stringWithFormat:@"%i", [mutArrayProducts count]]]];
        
        UIButton *buttonShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonShare setFrame:CGRectMake(0.0f, 0.0f, 38.0f, 32.0f)];
        [buttonShare setImage:[UIImage imageNamed:@"addThisButton.png"] forState:UIControlStateNormal];
        [buttonShare addTarget:self action:@selector(popover:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithCustomView:buttonShare];
        [self.navigationItem setRightBarButtonItem:share];
        
        [labelTotalProducts setAttributedText:attrStr];
        [labelTotalProducts setTextAlignment:UITextAlignmentLeft];
        [self loadButtonsProduct];
    }
}

-(void)popover:(id)sender
{
    sharePopOverViewController *sharePopOverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sharePopOver"];
    
    Caminho *urlImage = [[Caminho alloc] init];
    
    @try {
        [sharePopOverVC setImgProduct:self.imgGarageLogo.image];
   //     urlImage = (Caminho *)[[[self.product.fotos objectAtIndex:0] caminho] objectAtIndex:0];
    }
    @catch (NSException *exception) {
        urlImage.listing = @"";
        [sharePopOverVC setImgProduct:nil];
    }
    
    NSString *avatarName;
    if (isGenericGarage)
        avatarName = [NSString stringWithFormat:@"%@_AvatarImg", profile.garagem];
    else
        avatarName = [NSString stringWithFormat:@"%@_AvatarImg", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]];
    
    NSString *urlImgProfile = [[GlobalFunctions getUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_url", avatarName ]];
    
    [sharePopOverVC setIdProduct:@""];
    [sharePopOverVC setPriceProduct:@""];
    [sharePopOverVC setGarageName:self.garageName.text];
    [sharePopOverVC setProdName:self.garageName.text];
    [sharePopOverVC setDescription:self.description.text];
    [sharePopOverVC setStrUrlImg:@""];
    [sharePopOverVC setParent:self];

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
    popover = nil;
    sharePopOverVC = nil;
    btnView = nil;
    urlImage = nil;
}
-(void)topRight:(id)sender
{
    [self popover:self.navigationItem.rightBarButtonItem.customView];
}

-(void)loadHeader{
    if (garageNameSearch) {
        description.text = @"";
        garageName.text  = @"";
        city.text        = @"";
        link.text        = @"";
    } else {
        if ([garage.about isEqualToString:@""])
            [description setText:NSLocalizedString(@"welcome-my-garage", @"")];
        else
            [description setText:[NSString stringWithFormat:@"%@", garage.about]];
        [city setText:[GlobalFunctions formatAddressGarage:@[garage.city, garage.district, garage.country]]];
        [garageName setAttributedText:[GlobalFunctions getNamePerfil:profile.garagem
                                                         profileName:profile.nome]];
        
        if ([garage.link isEqualToString:@""])
            [link setText:[NSString stringWithFormat:@"http://gsapp.me/%@", profile.garagem]];
        else
            [link setText:garage.link];
    
        if ([city.text length] < 5)
            [city setHidden:YES];
    }
}

- (void)urlGarage:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link.text]];
}

- (void)getResourcePathProduct{
    //Initializing the Object Manager
    RKObjManeger = [RKObjectManager sharedManager];
    
    RKObjectMapping *productMapping = [Mappings getProductMapping];
    RKObjectMapping *photoMapping = [Mappings getPhotoMapping];
    RKObjectMapping *caminhoMapping = [Mappings getCaminhoMapping];
    
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    
    //Relationship
    [photoMapping mapKeyPath:@"caminho" toRelationship:@"caminho" withMapping:caminhoMapping serialize:NO];
    
    //LoadUrlResourcePath
    if (!isGenericGarage)
        [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]] objectMapping:productMapping delegate:self];
    else if (!garageNameSearch)
        [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@", profile.garagem] objectMapping:productMapping delegate:self];
    else if (garageNameSearch)
        [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@", garageNameSearch] objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)getResourcePathGarage:(NSString *)garagem{
    RKObjectMapping *garageMapping = [Mappings getGarageMapping];
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", garagem]
                              objectMapping:garageMapping delegate:self];
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class]
                                          forMIMEType:[GlobalFunctions getMIMEType]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)getResourcePathProfile:(NSArray *)garagem {
    RKObjectMapping *prolileMapping = [Mappings getProfileMapping];
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", [[garagem objectAtIndex:0] idPerson]]
                              objectMapping:prolileMapping delegate:self];
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class]
                                          forMIMEType:[GlobalFunctions getMIMEType]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    if ([objects count] > 0) {
        [viewNoProducts setHidden:YES];
        [viewTop setUserInteractionEnabled:YES];
        if([[objects objectAtIndex:0] isKindOfClass:[Product class]]){
            [mutArrayProducts removeAllObjects];
            mutArrayProducts = nil;
            mutArrayProducts = (NSMutableArray *)objects;
            [self awakeFromNib];
            [tableViewProducts reloadData];
            self.scrollViewProducts.contentSize = CGSizeMake(320,([mutArrayProducts count]*35)+130);
            [scrollViewMain setUserInteractionEnabled:YES];
            [self loadAttribsToComponents:YES];
            if (garageNameSearch){
                [self getResourcePathGarage:[[objects objectAtIndex:0] idPessoa]];
                garageNameSearch = nil;
            } else
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } else if ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
            [self getResourcePathProfile:objects];
            garage = nil;
            garage = (Garage *)[objects objectAtIndex:0];
        } else if ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
            profile = nil;
            profile = (Profile *)[objects objectAtIndex:0];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self loadHeader];
        }
    }
    else if ([objects count] == 0)
        if (!isGenericGarage){
            [viewNoProducts setHidden:NO];
            [mutArrayProducts removeAllObjects];
            [scrollViewMain setUserInteractionEnabled:NO];
            [labelTotalProducts setText:@""];
            [self.scrollViewProducts setContentSize:CGSizeMake(320,400)];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self showNoMessage:@"noproducts" text:NSLocalizedString(@"no-products-popup", nil)];
        }
    [self.refreshControl endRefreshing];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
    [self.refreshControl endRefreshing];
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
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

-(void)backPageFromDescription{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backPage{
    if (isGenericGarage){
        [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    [self releaseMemoryCache];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)releaseMemoryCache{
    settingsVC = nil;
    RKObjManeger = nil;
    mutArrayProducts = nil;
    segmentControl = nil;
    profile = nil;
    garage = nil;
    garageNameSearch = nil;
    imageURLs = nil;
    imageGravatar = nil;
    self.tabBarController.delegate = nil;
    self.scrollViewMain.delegate = nil;
    self.scrollViewProducts.delegate = nil;
    self.tableViewProducts.dataSource = nil;
    self.tableViewProducts.delegate = nil;
    [super releaseMemoryCache];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 0){
        if (scrollViewMain.contentOffset.y > 130){
            [scrollViewProducts setScrollEnabled:YES];
            [tableViewProducts setScrollEnabled:YES];
        }else{
            [scrollViewProducts setScrollEnabled:NO];
            [tableViewProducts setScrollEnabled:NO];
        }
    }
    
    if (scrollView.tag == 1 || scrollView.tag == 2) {
        if (scrollView.contentOffset.y == 0){
            [scrollViewProducts setContentOffset:CGPointMake(0, 0) animated:NO];
            [tableViewProducts setContentOffset:CGPointMake(0, 0) animated:NO];
            [scrollViewMain setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    
    if ([mutArrayProducts count] > 3) {
        if (_lastContentOffset < (int)tableViewProducts.contentOffset.y ||
            _lastContentOffset < (int)scrollViewMain.contentOffset.y ||
            _lastContentOffset < (int)scrollViewProducts.contentOffset.y) {
            [GlobalFunctions hideTabBar:self.navigationController.tabBarController animated:YES];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }else{
            if (tableViewProducts.contentOffset.y < tableViewProducts.contentSize.height-300) {
              [GlobalFunctions showTabBar:self.navigationController.tabBarController];
              [self.navigationController setNavigationBarHidden:NO animated:YES];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [GlobalFunctions showTabBar:self.navigationController.tabBarController];
}

-(void)loadButtonsProduct{
    for (UIButton *subview in [scrollViewProducts subviews])
        [subview removeFromSuperview];
    [self.scrollViewMain addSubview:self.refreshControl];
    
    //init Global Functions
    GlobalFunctions *globalFunctions = [[GlobalFunctions alloc] init];
    
    //Set Display thumbs on Home.
    [globalFunctions setCountColumnImageThumbs:-1];
    [globalFunctions setImageThumbsXorigin_Iphone:10];
    [globalFunctions setImageThumbsYorigin_Iphone:10];
    
    for(int i = 0; i < [mutArrayProducts count]; i++)
    {
        UIView *viewThumb = [globalFunctions loadButtonsThumbsProduct:[NSArray arrayWithObjects:
                                                                       [self.mutArrayProducts objectAtIndex:i],
                                                                       [NSNumber numberWithInt:i], nil]
                                                             showEdit:!isGenericGarage ? YES : NO
                                                            showPrice:YES
                                                            viewContr:self];
        [scrollViewProducts addSubview:viewThumb];
        viewThumb = nil;
    }
    globalFunctions = nil;
}

-(void)changeSegControl:(id)sender{
    if(segmentControl.selectedSegmentIndex == 0){
        tableViewProducts.hidden = YES;
        scrollViewProducts.hidden = NO;
    }
    if(segmentControl.selectedSegmentIndex == 1){
        tableViewProducts.hidden = NO;
        scrollViewProducts.hidden = YES;
    }
}

-(void)gotoSettingsVC{
    settingsVC.totalProducts = [mutArrayProducts count];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

-(void)gotoDescriptionVC{
    UIViewController *descr = [[UIViewController alloc] init];
    [descr.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *barItemBack = [GlobalFunctions getIconNavigationBar:@selector(backPageFromDescription)
                                                               viewContr:self
                                                              imageNamed:@"btBackNav.png" rect:CGRectMake(0, 0, 40, 30)];
    
    [descr.navigationItem setLeftBarButtonItem:barItemBack];
    barItemBack = nil;
    
    UILabel *labDesc = [[UILabel alloc] init];
    [labDesc setText:description.text];
    [labDesc setFont:[UIFont fontWithName:@"Droid Sans" size:12]];
    [labDesc setNumberOfLines:0];
    [labDesc setTextColor:[UIColor grayColor]];
    [labDesc setFrame:CGRectMake(10, 10, 300, 400)];
    [labDesc sizeToFit];
    
    UIScrollView *scrl = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [scrl addSubview:labDesc];
    [scrl setContentSize:CGSizeMake(320, labDesc.frame.size.height+50)];
    
    [descr.view addSubview:scrl];
    labDesc = nil;
    scrl = nil;
    [self.navigationController pushViewController:descr animated:YES];
    descr = nil;
}

- (void)gotoProductDetailVC:(UIButton *)sender{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[self.mutArrayProducts objectAtIndex:sender.tag];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[[sender imageView] image]];
    prdDetailVC.imageView = imgV;
    imgV = nil;
    [self.navigationController pushViewController:prdDetailVC animated:YES];
}

- (void)gotoProductAccountVC:(UIButton *)sender{
    productAccountViewController *prdAccVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productAccount"];
    prdAccVC.product   = (Product *)[self.mutArrayProducts objectAtIndex:sender.tag];
    [self.navigationController pushViewController:prdAccVC animated:YES];
    prdAccVC = nil;
}

// Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mutArrayProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString      *CellIdentifier = @"CellProduct";
    __weak searchCustomViewCell *cell = [self.tableViewProducts dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if ([mutArrayProducts count] > 0) {
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imageView];
        //set placeholder image or cell won't update when image is loader
        UIImage *placeHolder = [UIImage imageNamed:@"placeHolder.png"];
        [cell.imageView setImage:placeHolder];
        //load the image
        [cell.imageView setImageURL:[imageURLs objectAtIndex:indexPath.row]];
        [cell.imageView.layer setMasksToBounds:YES];
        [cell.imageView.layer setCornerRadius:3];
        NSString *prodName = (NSString *)[[self.mutArrayProducts objectAtIndex:indexPath.row] nome];
        [[cell productName]         setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        [[cell productName]         setText:prodName];

        NSString                   *currency        = [GlobalFunctions getCurrencyByCode:(NSString *)
                                                       [[self.mutArrayProducts objectAtIndex:indexPath.row] currency]];
        
        NSString                   *valorEsperado   = [[self.mutArrayProducts objectAtIndex:indexPath.row] valorEsperado ];

        NSString                   *strFormat       = [NSString stringWithFormat:@"%@%@", currency, valorEsperado];
        
        NSMutableAttributedString  *attrStr         = [NSMutableAttributedString attributedStringWithString:strFormat];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:24]];
        [attrStr setTextColor:[UIColor colorWithRed:91.0/255.0 green:148.0/255.0 blue:67.0/255.0 alpha:1.f]];
        [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]   
                        range:[strFormat rangeOfString:currency]];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:16] range:[strFormat rangeOfString: currency]];

        int state = [[[self.mutArrayProducts objectAtIndex:indexPath.row] idEstado] intValue];
        
        if (state > 1) {
          [[cell valorEsperado] setFont:[UIFont fontWithName:@"Droid Sans" size:20 ]];
          [[cell valorEsperado] setTextColor:[UIColor colorWithRed:(float)255/255.0 \
                                                           green:(float)102/255.0 \
                                                            blue:(float)102/255.0 alpha:1.0]];
        }
        switch (state) {
            case 2:
                [[cell valorEsperado] setText:NSLocalizedString(@"sold", nil)];
                break;
            case 3:
                [[cell valorEsperado] setText:@"N/D"];
                break;
            case 4:
                [[cell valorEsperado] setText:NSLocalizedString(@"invisible", nil)];
                break;
            default:
                cell.valorEsperado.attributedText = attrStr;
                break;
        }
                
        if (!isGenericGarage)
            cell.imageEditButton.hidden = NO;
        else 
            cell.imageEditButton.hidden = YES;
        
        [cell.imageEditButton setTag:indexPath.row];
        [cell.imageEditButton addTarget:self action:@selector(gotoProductAccountVC:) forControlEvents:UIControlEventTouchUpInside];
        [cell.valorEsperado setAutomaticallyAddLinksForType:0];
        
        currency        = nil;
        valorEsperado   = nil;
        strFormat       = nil;
        attrStr         = nil;
        strFormat       = nil;
        placeHolder     = nil;
        prodName        = nil;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    [prdDetailVC setProduct:(Product *)[mutArrayProducts objectAtIndex:indexPath.row]];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[[(searchCustomViewCell *)[tableView cellForRowAtIndexPath:indexPath] imageView] image]];
    
    [prdDetailVC setImageView:imageV];
    imageV = nil;
    [self.navigationController pushViewController:prdDetailVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [viewTop setUserInteractionEnabled:YES];
    [self.tabBarController setDelegate:self];
    if ([[[GlobalFunctions getUserDefaults] objectForKey:@"isSettingsChange"] isEqual:@"YES"]) {
        [self loadAttribsToComponents:NO];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NO" forKey:@"isSettingsChange"];
        [userDefaults synchronize];
        userDefaults = nil;
    }
    
    if ([[[GlobalFunctions getUserDefaults] objectForKey:@"reloadGarage"] isEqual:@"YES"]) {
        for (UIButton *subview in [[self scrollViewProducts] subviews])
            [subview removeFromSuperview];
        [labelTotalProducts setText:@""];
        [self loadAttribsToComponents:NO];
        [self reloadPage:nil];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NO" forKey:@"reloadGarage"];
        [userDefaults synchronize];
        userDefaults = nil;
    }
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
    emailLabel = nil;
    imgGarageLogo = nil;
    garageName = nil;
    description = nil;
    city = nil;
    link = nil;
    [self setEmailLabel:nil];
    [self setImgGarageLogo:nil];
    [self setGarageName:nil];
    [self setDescription:nil];
    [self setCity:nil];
    [self setLink:nil];
    scrollViewProducts = nil;
    [self setScrollViewProducts:nil];
    tableViewProducts = nil;
    [self setTableViewProducts:nil];
    scrollViewMain = nil;
    [self setScrollViewMain:nil];
    labelNoProduct = nil;
    [self setLabelNoProduct:nil];
    mutArrayProducts = nil;
    [self setMutArrayProducts:nil];
    profile = nil;
    [self setProfile:nil];
    garage = nil;
    [self setGarage:nil];
    imageGravatar = nil;
    [self setImageGravatar:nil];
    garageNameSearch = nil;
    [self setGarageNameSearch:nil];
    isGenericGarage = nil;
    [self setIsGenericGarage:nil];
    labelTotalProducts = nil;
    [self setLabelTotalProducts:nil];
    segmentControl = nil;
    [self setSegmentControl:nil];
    viewSegmentArea = nil;
    [self setViewSegmentArea:nil];
    viewTop = nil;
    [self setViewTop:nil];
    imageURLs = nil;
    [self setImageURLs:nil];
    viewNoProducts = nil;
    [self setViewNoProducts:nil];
    self.refreshControl = nil;
    [self setRefreshControl:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end