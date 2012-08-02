//
//  garageDetailViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 09/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "garageAccountViewController.h"

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

        description.text = [[GlobalFunctions getUserDefaults] objectForKey:@"about"];
        garageName.text  = [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"];
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
        
        //Load cache thumbs in thumbsDataArray to TableView
        mutArrayDataThumbs = [[NSMutableArray alloc] init];
        for(int i = 0; i < [self.mutArrayProducts count]; i++)
        {
            if ([[self.mutArrayProducts objectAtIndex:i] fotos] != nil) {
                NSString* urlThumb = [NSString stringWithFormat:@"%@/%@", [GlobalFunctions getUrlImagePath], [[[self.mutArrayProducts objectAtIndex:i] fotos] caminhoThumb]];
                UIImage *thumbImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:urlThumb]]];
                [mutArrayDataThumbs addObject:thumbImage];
            }else 
                [mutArrayDataThumbs addObject:[UIImage imageNamed:@"nopicture.png"]];
        }
        
        [self.tableViewProducts reloadData];
        
        //init Global Functions
        globalFunctions = [[GlobalFunctions alloc] init];
        //Set Display thumbs on Home.
        globalFunctions.countColumnImageThumbs = -1;
        globalFunctions.imageThumbsXorigin_Iphone = 10;
        globalFunctions.imageThumbsYorigin_Iphone = 10;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadButtonsProduct)
                                            object:nil];
        [queue addOperation:operation];


    }  
}

-(void)gotoSettingsVC{
    settingsAccountViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    [self.navigationController pushViewController:settingsVC animated:YES];
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

-(void)loadButtonsProduct{
    //NSOperationQueue *queue = [NSOperationQueue new];
    for(int i = 0; i < [self.mutArrayProducts count]; i++)
    {
        // if ([[self.arrayProducts objectAtIndex:i] fotos] == nil) {
        NSString* urlThumb = [NSString stringWithFormat:@"%@/%@", [GlobalFunctions getUrlImagePath], [[[self.mutArrayProducts objectAtIndex:i] fotos] caminhoThumb]];
        
        [NSThread detachNewThreadSelector:@selector(loadImageGalleryThumbs:) toTarget:self 
                               withObject:[NSArray arrayWithObjects:urlThumb, [NSNumber numberWithInt:i] , nil]];
        //}
    }
}

- (void)loadImageGalleryThumbs:(NSArray *)params {
    BOOL isPickNull = ([[self.mutArrayProducts objectAtIndex:
                         [[params objectAtIndex:1] intValue]] fotos] == NULL);
    [scrollViewProducts addSubview:[globalFunctions loadImage:params isNull:isPickNull viewContr:self]];
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
    
    if ([[[self.mutArrayProducts objectAtIndex:indexPath.row] idEstado] intValue] == 2){
        [[cell valorEsperado] setText:@"Vendido"];
        [[cell valorEsperado] setTextColor:[UIColor colorWithRed:(float)255/255.0 \
                                                           green:(float)102/255.0 \
                                                            blue:(float)102/255.0 alpha:1.0]];
    }else{
        [[cell valorEsperado] setText:(NSString *)[[self.mutArrayProducts objectAtIndex:indexPath.row] valorEsperado ]];
        [[cell valorEsperado] setTextColor:[UIColor colorWithRed:(float)90/255.0 \
                                                           green:(float)163/255.0 \
                                                            blue:(float)65/255.0 alpha:1.0]];
    }
    [[cell currency]            setText:(NSString *)[[self.mutArrayProducts objectAtIndex:indexPath.row] currency ]];
    [[cell garageName]          setText:[NSString stringWithFormat:@"%@ %@'s garage", NSLocalizedString(@"by", @""),
                                         [[self.mutArrayProducts objectAtIndex:indexPath.row] idPessoa ]] ];
    
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