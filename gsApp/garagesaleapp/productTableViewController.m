//
//  productTableViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 07/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "productTableViewController.h"

@interface productTableViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation productTableViewController

@synthesize mutArrayProducts;
@synthesize mutArrayDataThumbs;
@synthesize activityIndicator;
@synthesize RKObjManeger;
@synthesize searcBarProduct;
@synthesize strLocalResourcePath;
@synthesize strTextSearch;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController setNavigationBarHidden:NO];
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
    
    //set Local Resource Defautl
    if ([strLocalResourcePath length] == 0) 
        strLocalResourcePath = @"/product";
    
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:self.strLocalResourcePath objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    //set Array objects Products
    if([objects count] > 0){
        self.mutArrayProducts = (NSMutableArray *)objects;
        [self.tableView reloadData];
    }else{ 
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Search not found!"
                              message: @"No itens found for this search."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    [self loadAttribsToComponents];
    [activityIndicator stopAnimating];
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

- (void)loadAttribsToComponents{
    //Load cache thumbs in thumbsDataArray to TableView
    mutArrayDataThumbs = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.mutArrayProducts count]; i++)
    {
        if ([[self.mutArrayProducts objectAtIndex:i] fotos] != nil) {
            NSString* urlThumb = [NSString stringWithFormat:@"http://www.garagesaleapp.me/%@", [[[self.mutArrayProducts objectAtIndex:i] fotos] caminhoThumb]];
            UIImage *thumbImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:urlThumb]]];
            [mutArrayDataThumbs addObject:thumbImage];
        }else 
            [mutArrayDataThumbs addObject:[UIImage imageNamed:@"nopicture.png"]];
    }
    
    //set searchBar settings
    searcBarProduct = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,40)];
    searcBarProduct.delegate = self;
    searcBarProduct.placeholder = NSLocalizedString(@"searchProduct", @"");
    
    if ([self.strTextSearch length] != 0)
        searcBarProduct.text = self.strTextSearch;
    
    self.strTextSearch = @"";
    self.navigationItem.title = NSLocalizedString(@"products", @"");
    [self.view addSubview:searcBarProduct];
}

- (IBAction)reloadProducts:(id)sender{
	[activityIndicator startAnimating];
    self.strLocalResourcePath = @"/product";
    [self.mutArrayProducts removeAllObjects];
    [self.tableView reloadData];
    [self setupProductMapping];
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
    productCustomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    cell.imageView.frame = CGRectMake(5, 5, 80, 80);
    cell.imageView.image = [mutArrayDataThumbs objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[self.mutArrayProducts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:prdDetailVC animated:YES];
}

// Settings to SearchBar
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks 
    // the 'Search' button.
    // If you wanted to display results as the user types 
    // you would do that here.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // searchBarTextDidBeginEditing is called whenever 
    // focus is given to the UISearchBar
    // call our activate method so that we can do some 
    // additional things when the UISearchBar shows.
    [self.searcBarProduct setShowsCancelButton:YES animated:YES];
    [self searchBar:searchBar activate:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the 
    // UISearchBar loses focus
    // We don't need to do anything here.
    [self.searcBarProduct setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Clear the search text
    // Deactivate the UISearchBar
    [self.searcBarProduct resignFirstResponder];
    // searchBar.text=@"";
    //[self searchBar:searchBar activate:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // Do the search and show the results in tableview
    // Deactivate the UISearchBar
    
    //Search Service
    self.strLocalResourcePath = [NSString stringWithFormat:@"/search?q=%@", searchBar.text];
    [self setupProductMapping];
    [self searchBar:searchBar activate:NO];
	[activityIndicator startAnimating];
    [self.mutArrayProducts removeAllObjects];
    [self.tableView reloadData];
}


// We call this when we want to activate/deactivate the UISearchBar
// Depending on active (YES/NO) we disable/enable selection and 
// scrolling on the UITableView
// Show/Hide the UISearchBar Cancel button
// Fade the screen In/Out with the disableViewOverlay and 
// simple Animations
- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active {	
    //    self.tableView.allowsSelection = !active;
    //    self.tableView.scrollEnabled = !active;
    if (!active) {
        //        [disableViewOverlay removeFromSuperview];
        [searcBarProduct resignFirstResponder];
    } else {
        //        self.disableViewOverlay.alpha = 0;
        //        [self.view addSubview:self.disableViewOverlay];
		
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDuration:0.5];
        //        self.disableViewOverlay.alpha = 0.6;
        [UIView commitAnimations];
		
        // probably not needed if you have a details view since you 
        // will go there on selection
        NSIndexPath *selected = [self.tableView 
                                 indexPathForSelectedRow];
        if (selected) {
            [self.tableView deselectRowAtIndexPath:selected 
                                          animated:NO];
        }
    }
    [searchBar setShowsCancelButton:active animated:YES];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    
    activityIndicator = nil;
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
