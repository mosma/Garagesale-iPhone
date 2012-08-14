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
@synthesize imageView;
@synthesize garageName;
@synthesize description;
@synthesize city;
@synthesize link;
@synthesize scrollViewMain;
@synthesize scrollViewProducts;
@synthesize mutArrayProducts;
@synthesize mutArrayDataThumbs;

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
    [self loadAttribsToComponents:NO];
    [self setupProductMapping];
}

- (void)setupProductMapping{
    //Initializing the Object Manager
    RKObjManeger = [RKObjectManager sharedManager];
    
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
    
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]] objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    
    
    
    
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

- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	while (!isLoading) {
		sleep(1);
	}
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if([objects count] > 0){
        self.mutArrayProducts = (NSMutableArray *)objects;
        [self loadAttribsToComponents:YES];
        isLoading = !isLoading;
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
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

- (void)loadAttribsToComponents:(BOOL)isFromLoadObject{
    if (!isFromLoadObject) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.jpg"] 
                                                  forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTintColor:[GlobalFunctions getColorRedNavComponets]];
            
        gravatarUrl = [GlobalFunctions getGravatarURL:[[GlobalFunctions getUserDefaults] objectForKey:@"email"]];

        
        
        garageName.font        = [UIFont fontWithName:@"Droid Sans" size:22 ];
        
        city.font              = [UIFont fontWithName:@"Droid Sans" size:12 ];
        [city setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
        
        description.text = [[GlobalFunctions getUserDefaults] objectForKey:@"about"];
        description.font = [UIFont fontWithName:@"Droid Sans" size:12];
        
        garageName.text  = [[GlobalFunctions getUserDefaults] objectForKey:@"nome"];
        city.text        = [NSString stringWithFormat:@"%@, %@, %@",
                            [[GlobalFunctions getUserDefaults] objectForKey:@"city"],
                            [[GlobalFunctions getUserDefaults] objectForKey:@"district"],
                            [[GlobalFunctions getUserDefaults] objectForKey:@"country"]];
        link.text        = [[GlobalFunctions getUserDefaults] objectForKey:@"link"];
        link.font        = [UIFont fontWithName:@"Droid Sans" size:12];

        
        
        self.scrollViewMain.contentSize         = CGSizeMake(320,560);
        self.scrollViewProducts.contentSize     = CGSizeMake(320,2845);
        self.scrollViewMain.delegate = self;
        self.scrollViewProducts.delegate = self;
        
        
        self.navigationItem.title       = NSLocalizedString(@"garage", @"");
    
        self.imageView.image            = [UIImage imageWithData: [NSData dataWithContentsOfURL:self.gravatarUrl]];

        self.navigationItem.hidesBackButton = NO;
        
        self.navigationItem.rightBarButtonItem = [GlobalFunctions getIconNavigationBar:@selector(gotoSettingsVC) viewContr:self imageNamed:@"btSettingsNavItem.png"];
        
        self.tableViewProducts.hidden = YES;

    }else {
        [self.tableViewProducts setDataSource:self];
        [self.tableViewProducts setDelegate:self];

        NSString *total = [NSString stringWithFormat:@"%i products", [mutArrayProducts count]];
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:total];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:20]];
        [attrStr setTextColor:[UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.f] range:[total rangeOfString:[NSString stringWithFormat:@"%i", [mutArrayProducts count]]]];
        [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]
                        range:[total rangeOfString:@"products"]];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:12] range:[total rangeOfString:@"products"]];
        [attrStr setFont:[UIFont boldSystemFontOfSize:20] range:[total rangeOfString:[NSString stringWithFormat:@"%i", [mutArrayProducts count]]]];
        labelTotalProducts.attributedText   = attrStr;

        
        
        [labelTotalProducts setBackgroundColor:[UIColor clearColor]];
        [labelTotalProducts setShadowColor:[UIColor blackColor]];
        [labelTotalProducts setShadowOffset:CGSizeMake(1, 1)];
        labelTotalProducts.attributedText = attrStr;
        labelTotalProducts.textAlignment = UITextAlignmentLeft;
        
        
        
        
        
        
        
        //init Global Functions
        globalFunctions = [[GlobalFunctions alloc] init];
        //Set Display thumbs on Home.
        globalFunctions.countColumnImageThumbs = -1;
        globalFunctions.imageThumbsXorigin_Iphone = 10;
        globalFunctions.imageThumbsYorigin_Iphone = 10;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        
        NSInvocationOperation *opThumbsProd = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadButtonsProduct)
                                            object:nil];
        
        NSInvocationOperation *opTableProd  = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadTableProduct)
                                            object:nil];
        [queue addOperation:opThumbsProd];
        [queue addOperation:opTableProd];
        
    }  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 0){
        if (scrollViewMain.contentOffset.y > 130){
            scrollViewProducts.userInteractionEnabled = YES;
            tableViewProducts.userInteractionEnabled = YES;
        }else{        
            scrollViewProducts.userInteractionEnabled = NO;
            tableViewProducts.userInteractionEnabled = NO;  
        }
    }
    
    if (scrollView.tag == 1 || scrollView.tag == 2) {
        if (scrollView.contentOffset.y == 0){
            [scrollViewMain setContentOffset:CGPointMake(0, 0) animated:YES];  
        }
    } 
}

-(void)loadButtonsProduct{
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
    [scrollViewProducts addSubview:[globalFunctions loadButtonsThumbsProduct:arrayDetailProduct
                                                            showEdit:YES 
                                                           viewContr:self]];
}

-(void)loadTableProduct{
    
    
    //Load cache thumbs in thumbsDataArray to TableView
    mutArrayDataThumbs = [[NSMutableArray alloc] init];

    for(int i = 0; i < [self.mutArrayProducts count]; i++)
    {
        [NSThread detachNewThreadSelector:@selector(loadImageTableThumbs:) toTarget:self 
                               withObject:[NSArray arrayWithObjects:[self.mutArrayProducts objectAtIndex:i], 
                                           [NSNumber numberWithInt:i], 
                                           nil]];
    }
    [self.tableViewProducts reloadData];

}

- (void)loadImageTableThumbs:(NSArray *)arrayDetailProduct {
    
    
    if ([[arrayDetailProduct objectAtIndex:0] fotos] != nil) {
        NSString* urlThumb = [NSString stringWithFormat:@"%@/%@", [GlobalFunctions getUrlImagePath], [[[arrayDetailProduct objectAtIndex:0] fotos] caminhoThumb]];
        UIImage *thumbImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:urlThumb]]];
        
        
        @try {
            [mutArrayDataThumbs addObject:thumbImage];

        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
        }
        
        
        
    }else 
        [mutArrayDataThumbs addObject:[UIImage imageNamed:@"nopicture.png"]];

    
   // [scrollViewProducts addSubview:[globalFunctions loadTableProduct:arrayDetailProduct
     //                                                               showEdit:YES 
       //                                                            viewContr:self]];
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
    [self.navigationController pushViewController:prdDetailVC animated:YES];
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
    }else{
        cell.valorEsperado.attributedText = attrStr;
    }
    
    @try {
        cell.imageView.image = [mutArrayDataThumbs objectAtIndex:indexPath.row];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[self.mutArrayProducts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:prdDetailVC animated:YES];
}




- (void)viewDidUnload
{
    emailLabel = nil;
    imageView = nil;
    garageName = nil;
    description = nil;
    city = nil;
    link = nil;
    [self setEmailLabel:nil];
    [self setImageView:nil];
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
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end