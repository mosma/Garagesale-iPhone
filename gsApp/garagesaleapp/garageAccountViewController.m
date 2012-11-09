//
//  garageDetailViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 09/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "garageAccountViewController.h"
#import "NSAttributedString+Attributes.h"

@implementation garageAccountViewController

@synthesize tableViewProducts;
@synthesize RKObjManeger;
@synthesize gravatarUrl;
@synthesize emailLabel;
@synthesize buttonGarageLogo;
@synthesize garageName;
@synthesize description;
@synthesize city;
@synthesize link;
@synthesize scrollViewMain;
@synthesize scrollViewProducts;
@synthesize mutArrayProducts;
@synthesize mutDictDataThumbs;
@synthesize profile;
@synthesize garage;
@synthesize viewTop;
@synthesize segmentControl;

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
    //[self reloadPage:nil];
}

- (IBAction)reloadPage:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    for (UIButton *subview in [scrollViewProducts subviews]) 
        [subview removeFromSuperview];
    
    [mutArrayProducts removeAllObjects];
        
    mutArrayProducts = nil;
    [self getResourcePathProduct];
    
    //Set Display thumbs on Home.
    globalFunctions.countColumnImageThumbs = -1;
    globalFunctions.imageThumbsXorigin_Iphone = 10;
    globalFunctions.imageThumbsYorigin_Iphone = 10;
    
    [scrollViewMain setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)loadAttribsToComponents:(BOOL)isFromLoadObject{
    if (!isFromLoadObject) {
        self.tabBarController.delegate = self;
        
        [GlobalFunctions setNavigationBarBackground:self.navigationController];

        [self.navigationController.navigationBar setTintColor:[GlobalFunctions getColorRedNavComponets]];
        
        [garageName setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.f]];
        [city setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];

        garageName.font  = [UIFont fontWithName:@"DroidSans-Bold" size:20];
        city.font        = [UIFont fontWithName:@"Droid Sans" size:12];
        description.font = [UIFont fontWithName:@"DroidSans-Bold" size:12];
        link.font        = [UIFont fontWithName:@"DroidSans-Bold" size:12];
        
        [segmentControl setSelectedSegmentIndex:0];
        
        if ((garage  == nil) && (profile == nil)) {
            description.text = [[GlobalFunctions getUserDefaults] objectForKey:@"about"];
            garageName.text  = [[GlobalFunctions getUserDefaults] objectForKey:@"nome"];
            city.text        = [NSString stringWithFormat:@"%@, %@, %@",
                            [[GlobalFunctions getUserDefaults] objectForKey:@"city"],
                            [[GlobalFunctions getUserDefaults] objectForKey:@"district"],
                            [[GlobalFunctions getUserDefaults] objectForKey:@"country"]];
            link.text        = [[GlobalFunctions getUserDefaults] objectForKey:@"link"];
        
            gravatarUrl = [GlobalFunctions getGravatarURL:[[GlobalFunctions getUserDefaults] objectForKey:@"email"]];

            self.navigationItem.rightBarButtonItem = [GlobalFunctions getIconNavigationBar:@selector(gotoSettingsVC) viewContr:self imageNamed:@"btSettingsNavItem.png"];
        } else {
            description.text = garage.about;
            garageName.text  = profile.garagem;
            city.text        = [NSString stringWithFormat:@"%@, %@, %@",
                                        garage.city,
                                        garage.district,
                                        garage.country];
            link.text        = garage.link;
            gravatarUrl = [GlobalFunctions getGravatarURL:profile.email];
            
            self.navigationItem.leftBarButtonItem   = [GlobalFunctions getIconNavigationBar:
                                                       @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];
        }

        self.scrollViewMain.contentSize         = CGSizeMake(320,560);
        self.scrollViewMain.delegate = self;
        self.scrollViewProducts.delegate = self;
        
        self.navigationItem.title = NSLocalizedString(@"garage", @"");
        
        //init Global Functions
        globalFunctions = [[GlobalFunctions alloc] init];
        
        self.navigationItem.hidesBackButton = NO;
        
       // self.tableViewProducts.hidden = YES;
        [self.tableViewProducts setDataSource:self];
        [self.tableViewProducts setDelegate:self];
        
        [viewTop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundGarageTop.png"]]];
        
        [NSThread detachNewThreadSelector:@selector(loadGravatarImage:) toTarget:self
                               withObject:gravatarUrl];
        
    } else {
        mutDictDataThumbs = [[NSMutableDictionary alloc] init];
        
        NSString *total = [NSString stringWithFormat:@"%i products", [mutArrayProducts count]];
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:total];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:20]];
        [attrStr setTextColor:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                        range:[total rangeOfString:[NSString stringWithFormat:@"%i", [mutArrayProducts count]]]];
        [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]
                        range:[total rangeOfString:@"products"]];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:13] range:[total rangeOfString:@"products"]];
        [attrStr setFont:[UIFont boldSystemFontOfSize:20] range:[total rangeOfString:[NSString stringWithFormat:@"%i", [mutArrayProducts count]]]];
        labelTotalProducts.attributedText   = attrStr;
        
//        [labelTotalProducts setBackgroundColor:[UIColor clearColor]];
//        [labelTotalProducts setShadowColor:[UIColor blackColor]];
//        [labelTotalProducts setShadowOffset:CGSizeMake(1, 1)];
        labelTotalProducts.attributedText = attrStr;
        labelTotalProducts.textAlignment = UITextAlignmentLeft;

        //Set Display thumbs on Home.
        globalFunctions.countColumnImageThumbs = -1;
        globalFunctions.imageThumbsXorigin_Iphone = 10;
        globalFunctions.imageThumbsYorigin_Iphone = 10;

        NSOperationQueue *queue = [NSOperationQueue new];
        
        NSInvocationOperation *opThumbsProd = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadButtonsThumbsProduct)
                                            object:nil];
        [queue addOperation:opThumbsProd];
    }  
}

-(void)loadGravatarImage:(NSURL *)gravatar{
    NSData  *imageData  = [NSData dataWithContentsOfURL:gravatar];
    UIImage *image      = [[UIImage alloc] initWithData:imageData];
    [buttonGarageLogo setImage:image forState:UIControlStateNormal];
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
    if ((garage  == nil) && (profile == nil))
        [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]] objectMapping:productMapping delegate:self];
    else
        [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@", profile.garagem] objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
    
    //[self initLoadingGuear];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if([objects count] > 0){
        self.mutArrayProducts = (NSMutableArray *)objects;
        [self.tableViewProducts reloadData];
        [self loadAttribsToComponents:YES];
        isLoadingDone = !isLoadingDone;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.scrollViewProducts.contentSize = CGSizeMake(320,([mutArrayProducts count]*35)+130);
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
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

-(void)initLoadingGuear{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.scrollViewMain addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.labelFont = [UIFont fontWithName:@"Droid Sans" size:14];
	HUD.delegate = self;
    HUD.labelText = @"Loading Products";
    HUD.color = [UIColor colorWithRed:219.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
    
    // Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	while (!isLoadingDone) {
		sleep(1);
	}
}

//- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
//    [GlobalFunctions tabBarController:theTabBarController didSelectViewController:viewController];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 0){
        if (scrollViewMain.contentOffset.y > 130){
            scrollViewProducts.scrollEnabled = YES;
            tableViewProducts.scrollEnabled = YES;
        }else{        
            scrollViewProducts.scrollEnabled = NO;
            tableViewProducts.scrollEnabled = NO;  
        }
    }
    
    if (scrollView.tag == 1 || scrollView.tag == 2) {
        if (scrollView.contentOffset.y == 0){
            [scrollViewMain setContentOffset:CGPointMake(0, 0) animated:YES];  
        }
    } 
}

-(void)loadButtonsThumbsProduct{
    //NSOperationQueue *queue = [NSOperationQueue new];
    for(int i = 0; i < [self.mutArrayProducts count]; i++)
    {
        [NSThread detachNewThreadSelector:@selector(loadImageGalleryThumbs:) toTarget:self 
                               withObject:[NSArray arrayWithObjects:[self.mutArrayProducts objectAtIndex:i], 
                                           [NSNumber numberWithInt:i], 
                                           nil]];
    }
}

- (void)loadImageGalleryThumbs:(NSArray *)arrayDetailProduct {
    @try {
        [scrollViewProducts addSubview:
         [globalFunctions loadButtonsThumbsProduct:arrayDetailProduct
                                          showEdit:((garage  == nil) && (profile == nil)) ? YES : NO
                                          showPrice:YES
                                          viewContr:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

-(void)loadTableProduct:(NSArray *)array{
    [NSThread detachNewThreadSelector:@selector(loadImageTableThumbs:) toTarget:self 
                               withObject:array];
}

- (void)loadImageTableThumbs:(NSArray *)array {
    /*
     array WithObjects:
     0 cell, 
     1 indexPath, 
     */
    NSIndexPath *index = [array objectAtIndex:1];
    NSString* urlThumb;

        @try {
            urlThumb  = [[[[[[mutArrayProducts objectAtIndex:index.row] fotos] objectAtIndex:0] caminho] objectAtIndex:0] listing];
            if (urlThumb != NULL) {
                UIImage *thumbImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:urlThumb]]];
                [(productCustomViewCell *)[array objectAtIndex:0] imageView].image =  thumbImage;
                [mutDictDataThumbs setObject:thumbImage forKey:[NSString stringWithFormat:@"%i", index.row]];
            }
        }
        @catch (NSException *exception) {
            [(productCustomViewCell *)[array objectAtIndex:0] imageView].image  = [UIImage imageNamed:@"nopicture.png"];
            [mutDictDataThumbs setObject:[UIImage imageNamed:@"nopicture.png"] forKey:[NSString stringWithFormat:@"%i", index.row]];
            NSLog(@"%@", exception);
        }
        @finally {
        }
}

-(IBAction)changeSegControl{
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
    settingsAccountViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)gotoProductDetailVC:(UIButton *)sender{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[self.mutArrayProducts objectAtIndex:sender.tag];
    prdDetailVC.imageView = [[UIImageView alloc] initWithImage:[[sender imageView] image]];
    [self.navigationController pushViewController:prdDetailVC animated:YES];
}

- (void)gotoProductAccountVC:(UIButton *)sender{
    productAccountViewController *prdAccVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productAccount"];
    prdAccVC.product   = (Product *)[self.mutArrayProducts objectAtIndex:sender.tag];
    [self.navigationController pushViewController:prdAccVC animated:YES];
}

// Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mutArrayProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString             *CellIdentifier = @"CellProduct";
    productCustomViewCell       *cell = [self.tableViewProducts dequeueReusableCellWithIdentifier:CellIdentifier];    
        
    if ([mutArrayProducts count] > 0) {

        [[cell productName]         setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        [[cell productName]         setText:(NSString *)[[self.mutArrayProducts objectAtIndex:indexPath.row] nome]];

        NSString                   *currency        = [GlobalFunctions getCurrencyByCode:(NSString *)
                                                       [[self.mutArrayProducts objectAtIndex:indexPath.row] currency]];
        
        NSString                   *valorEsperado   = [[self.mutArrayProducts objectAtIndex:indexPath.row] valorEsperado ];

        NSString                   *strFormat       = [NSString stringWithFormat:@"%@%@", currency, valorEsperado];
        
        NSMutableAttributedString  *attrStr         = [NSMutableAttributedString attributedStringWithString:strFormat];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:24]];
        [attrStr setTextColor:[UIColor colorWithRed:12.0/255.0 green:168.0/255.0 blue:12.0/255.0 alpha:1.f]];
        [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]   
                        range:[strFormat rangeOfString:currency]];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:16] range:[strFormat rangeOfString: currency]];

        if ([[[self.mutArrayProducts objectAtIndex:indexPath.row] idEstado] intValue] == 2){
            [[cell valorEsperado]       setFont:[UIFont fontWithName:@"Droid Sans" size:20 ]];
            [[cell valorEsperado] setText:@"Vendido"];
            [[cell valorEsperado] setTextColor:[UIColor colorWithRed:(float)255/255.0 \
                                                               green:(float)102/255.0 \
                                                                blue:(float)102/255.0 alpha:1.0]];
        }else cell.valorEsperado.attributedText = attrStr;
        
        if ([[mutDictDataThumbs allKeys] containsObject:[NSString stringWithFormat:@"%i", indexPath.row]])
            cell.imageView.image = [mutDictDataThumbs objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]]; 
        else {
             if ([mutArrayProducts count] != [mutDictDataThumbs count]) {
                NSOperationQueue *queue = [NSOperationQueue new];

                NSInvocationOperation *opTableProd  = [[NSInvocationOperation alloc]
                                                       initWithTarget:self
                                                       selector:@selector(loadTableProduct:)
                                                       object:[NSArray arrayWithObjects:
                                                               cell,
                                                               indexPath, nil]];
                [queue addOperation:opTableProd];
             }
        }
                
        if ((garage  == nil) && (profile == nil))
            cell.imageEditButton.hidden = NO;
        else 
            cell.imageEditButton.hidden = YES;
        
        [cell.imageEditButton setTag:indexPath.row];
        [cell.imageEditButton addTarget:self action:@selector(gotoProductAccountVC:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[mutArrayProducts objectAtIndex:indexPath.row];
    prdDetailVC.imageView               = [[UIImageView alloc] initWithImage:[mutDictDataThumbs objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]]];
    [self.navigationController pushViewController:prdDetailVC animated:YES];
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [GlobalFunctions setActionSheetAddProduct:self.tabBarController clickedButtonAtIndex:buttonIndex];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadAttribsToComponents:NO];
    
    if ([mutArrayProducts count] == 0)
        [self reloadPage:nil];
    
    if ([[[GlobalFunctions getUserDefaults] objectForKey:@"isProductRecorded"] isEqual:@"YES"]) {
        [self reloadPage:nil];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NO" forKey:@"isProductRecorded"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewDidUnload
{
    emailLabel = nil;
    buttonGarageLogo = nil;
    garageName = nil;
    description = nil;
    city = nil;
    link = nil;
    [self setEmailLabel:nil];
    [self setButtonGarageLogo:nil];
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
    [super viewDidUnload];
    mutDictDataThumbs = nil;
    [self setMutDictDataThumbs:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end