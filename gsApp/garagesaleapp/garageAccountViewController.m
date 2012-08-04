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
@synthesize activityIndicator;

@synthesize tableViewProducts;
@synthesize RKObjManeger;
@synthesize gravatarUrl;
@synthesize emailLabel;
@synthesize imageView;
@synthesize garageName;
@synthesize description;
@synthesize city;
@synthesize link;
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
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if([objects count] > 0){
        self.mutArrayProducts = (NSMutableArray *)objects;
        [self loadAttribsToComponents:YES];
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
        garageName.font        = [UIFont boldSystemFontOfSize:22];
        
        description.text = [[GlobalFunctions getUserDefaults] objectForKey:@"about"];
        garageName.text  = [[GlobalFunctions getUserDefaults] objectForKey:@"nome"];
        city.text        = [NSString stringWithFormat:@"%@, %@, %@",
                        [[GlobalFunctions getUserDefaults] objectForKey:@"city"],
                        [[GlobalFunctions getUserDefaults] objectForKey:@"district"],
                        [[GlobalFunctions getUserDefaults] objectForKey:@"country"]];
        link.text        = [[GlobalFunctions getUserDefaults] objectForKey:@"link"];
    
        self.scrollViewProducts.contentSize     = CGSizeMake(320,2845);
    
        self.navigationItem.title       = NSLocalizedString(@"garage", @"");
    
        self.imageView.image            = [UIImage imageWithData: [NSData dataWithContentsOfURL:self.gravatarUrl]];

        self.navigationItem.hidesBackButton = NO;
        
        self.navigationItem.rightBarButtonItem = [GlobalFunctions getIconNavigationBar:@selector(gotoSettingsVC) viewContr:self imageNamed:@"btSettingsNavItem.png"];
        
        self.tableViewProducts.hidden = YES;

    }else {
        [self.tableViewProducts setDataSource:self];
        [self.tableViewProducts setDelegate:self];

        //init Global Functions
        globalFunctions = [[GlobalFunctions alloc] init];
        //Set Display thumbs on Home.
        globalFunctions.countColumnImageThumbs = -1;
        globalFunctions.imageThumbsXorigin_Iphone = 10;
        globalFunctions.imageThumbsYorigin_Iphone = 50;
        
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
        
        [activityIndicator stopAnimating];
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
        [mutArrayDataThumbs addObject:thumbImage];
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
    static NSString *CellIdentifier = @"CellProduct";
    
    // Configure the cell...
    productCustomViewCell *cell = [self.tableViewProducts dequeueReusableCellWithIdentifier:CellIdentifier];
    //NSString *caminhoThumb      = [[[self.products objectAtIndex:indexPath.row] fotos ] caminhoThumb];
    [[cell productName]         setText:(NSString *)[[self.mutArrayProducts objectAtIndex:indexPath.row] nome]];
    
    
    /* 
     set Navigation Title with OHAttributeLabel
     */
//    NSString *titleNavItem = [NSString stringWithFormat:@"%@%@",  
//                              (NSString *)[[self.mutArrayProducts objectAtIndex:indexPath.row] currency],
//                              (NSString *)[[self.mutArrayProducts objectAtIndex:indexPath.row] valorEsperado]];
//    
//    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:titleNavItem];
//    [attrStr setFont:[UIFont fontWithName:@"Corben" size:16]];
//    [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0]];
//    [attrStr setTextColor:[UIColor colorWithRed:244.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.f]
//                    range:[titleNavItem rangeOfString:(NSString *)[[self.mutArrayProducts objectAtIndex:indexPath.row] currency]]];
//    [attrStr setFont:[UIFont fontWithName:@"Corben" size:14] range:[titleNavItem rangeOfString:@"app"]];

    [[cell productName]         setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
    //[[cell valorEsperado]       setFont:[UIFont fontWithName:@"Droid Sans" size:20 ]];

    
    
    if ([[[self.mutArrayProducts objectAtIndex:indexPath.row] idEstado] intValue] == 2){
//        [[cell valorEsperado] setText:@"Vendido"];
//        [[cell valorEsperado] setTextColor:[UIColor colorWithRed:(float)255/255.0 \
//                                                           green:(float)102/255.0 \
//                                                            blue:(float)102/255.0 alpha:1.0]];
    }else{
        [[cell valorEsperado] setText:(NSString *)[[self.mutArrayProducts objectAtIndex:indexPath.row] valorEsperado]];
        //cell.valorEsperado.text = attrStr;
    }
   // [[cell currency]            setText:(NSString *)[[self.mutArrayProducts objectAtIndex:indexPath.row] currency ]];
   // [[cell garageName]          setText:[NSString stringWithFormat:@"%@ %@'s garage", NSLocalizedString(@"by", @""),
                                   //      [[self.mutArrayProducts objectAtIndex:indexPath.row] idPessoa ]] ];
    
    cell.imageView.image = [mutArrayDataThumbs objectAtIndex:indexPath.row];
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
    activityIndicator = nil;
    [self setActivityIndicator:nil];
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