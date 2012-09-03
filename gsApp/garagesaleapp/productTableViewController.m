//
//  productTableViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 07/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "productTableViewController.h"
#import "NSAttributedString+Attributes.h"

@interface productTableViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation productTableViewController

@synthesize mutArrayProducts;
@synthesize mutArrayDataThumbs;
@synthesize activityIndicator;
@synthesize RKObjManeger;
@synthesize searchBarProduct;
@synthesize strLocalResourcePath;
@synthesize strTextSearch;
@synthesize labelTitleResults;
@synthesize segmentControl;
//@synthesize customCellViewLine;
//@synthesize customCellViewBlock;

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
    [self loadAttribsToComponents:NO];
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
        mutArrayProducts = (NSMutableArray *)objects;
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
    [self loadAttribsToComponents:YES];
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

- (void)loadAttribsToComponents:(BOOL)isFromLoadObject{
    if (!isFromLoadObject) {
        //set searchBar settings
        searchBarProduct = [[UISearchBar alloc]initWithFrame:CGRectMake(-320,0,320,40)];
        searchBarProduct.delegate = self;
        searchBarProduct.placeholder = NSLocalizedString(@"searchProduct", @"");
        
        [GlobalFunctions setSearchBarLayout:searchBarProduct];
        
        self.navigationItem.title = NSLocalizedString(@"products", @"");
        [self.view addSubview:searchBarProduct];

        self.navigationItem.leftBarButtonItem   = [GlobalFunctions getIconNavigationBar:
                                                 @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];
 
        self.navigationItem.rightBarButtonItem  = [GlobalFunctions getIconNavigationBar:
                                                 @selector(showSearch:) viewContr:self imageNamed:@"btSearchAccount.png"];
        segmentControl.selectedSegmentIndex = 0;
        [self.tableView setRowHeight:377];
        
    }else {
            
        if ([self.strTextSearch length] != 0)
            searchBarProduct.text = self.strTextSearch;
        mutArrayDataThumbs = [[NSMutableArray alloc] init];
        
        labelTitleResults.text = [NSString stringWithFormat:@"%i results for \"%@\"", [mutArrayProducts count], strTextSearch];
        //self.strTextSearch = @"";
    }
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showSearch:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
    
    if (!isSearch) {
        searchBarProduct.transform = CGAffineTransformMakeTranslation(320, 0);
        [searchBarProduct becomeFirstResponder];
    }
    else {
        searchBarProduct.transform = CGAffineTransformMakeTranslation(-320, 0);
        [searchBarProduct resignFirstResponder];
    }
    isSearch = !isSearch;
    
    //  viewSignup.transform = CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];

//- (IBAction)reloadProducts:(id)sender{
//	[activityIndicator startAnimating];
//    self.strLocalResourcePath = @"/product";
//    [self.mutArrayProducts removeAllObjects];
//    [self.tableView reloadData];
//    [self setupProductMapping];
}

// Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mutArrayProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    productCustomViewCell *customViewCellBlock = [tableView dequeueReusableCellWithIdentifier:@"customViewCellBlock"];
    productCustomViewCell *customViewCellLine = [tableView dequeueReusableCellWithIdentifier:@"customViewCellLine"];
    //NSString *caminhoThumb      = [[[self.products objectAtIndex:indexPath.row] fotos ] caminhoThumb];

    
    
        NSString *garageName = [[mutArrayProducts objectAtIndex:indexPath.row] idPessoa ];
    NSString                   *currency        = [GlobalFunctions getCurrencyByCode:(NSString *)
                                                   [[self.mutArrayProducts objectAtIndex:indexPath.row] currency]];
    NSString                   *valorEsperado   = [[self.mutArrayProducts objectAtIndex:indexPath.row] valorEsperado ];
    NSString                   *strFormat       = [NSString stringWithFormat:@"%@%@ by %@", currency, valorEsperado, 
                                                   [[mutArrayProducts objectAtIndex:indexPath.row] idPessoa ]];
    
    
    
    
    
    
    

    
        [[customViewCellLine productName] setText:[[customViewCellBlock productName] text]];
        [[customViewCellLine currency] setText:[[customViewCellBlock currency] text]];
        [[customViewCellLine garageName] setText:[NSString stringWithFormat:@"%@ %@'s garage", 
                                              NSLocalizedString(@"by", @""),
                                              garageName]];
        [customViewCellLine imageView].image = [UIImage imageNamed:@"nopicture.png"];    
    
    
    

    

    //Set Default Size/Color
    NSMutableAttributedString  *attrStr         = [NSMutableAttributedString attributedStringWithString:strFormat];
    [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:15]];
    [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
    
    
    //Set Valor Esperado Size/Color
    [attrStr setTextColor:[UIColor colorWithRed:12.0/255.0 green:168.0/255.0 blue:12.0/255.0 alpha:1.f]    
                    range:[strFormat rangeOfString:valorEsperado]];
    [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:20] range:[strFormat rangeOfString:valorEsperado]];
    
    //Set GarageName Size/Color
    [attrStr setTextColor:[UIColor redColor]  
                    range:[strFormat rangeOfString:garageName]];
    [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:13] range:[strFormat rangeOfString:
                                                                        [NSString stringWithFormat:@"by %@", garageName]]];
    

    
    
    
    
    
    
    
    if ([[[self.mutArrayProducts objectAtIndex:indexPath.row] idEstado] intValue] == 2){
        [[customViewCellBlock valorEsperado]       setFont:[UIFont fontWithName:@"Droid Sans" size:20 ]];
        [[customViewCellBlock valorEsperado] setText:@"Vendido"];
        [[customViewCellBlock valorEsperado] setTextColor:[UIColor colorWithRed:(float)255/255.0 \
                                                           green:(float)102/255.0 \
                                                            blue:(float)102/255.0 alpha:1.0]];
    }else{
        customViewCellBlock.valorEsperado.attributedText = attrStr;
    }
    
    [customViewCellBlock imageView].image = [UIImage imageNamed:@"nopicture.png"];

    [[customViewCellBlock productName] setText:(NSString *)[[mutArrayProducts objectAtIndex:indexPath.row] nome]];
    [[customViewCellBlock productName] setFont:[UIFont fontWithName:@"Droid Sans" size:15]];
    
//    NSData  *imageData  = [NSData dataWithContentsOfURL:[GlobalFunctions getGravatarURL:[[mutArrayProducts objectAtIndex:indexPath.row] email]]];
//    UIImage *image      = [[UIImage alloc] initWithData:imageData];
    customViewCellBlock.imageGravatar.image = [UIImage imageNamed:@"nopicture.png"];
    
    
    
    
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadButtonsProduct:)
                                            object:[NSArray arrayWithObjects:customViewCellBlock, customViewCellLine, indexPath, nil]];
        [queue addOperation:operation];

    int i = indexPath.row;
    NSLog(@"%@", indexPath);
    NSLog(@"%i", i);
    
    if (!isSegmentedControlChanged) {
        if(segmentControl.selectedSegmentIndex == 0){
            [customViewCellLine removeFromSuperview];
            customViewCellBlock.hidden = NO;
            customViewCellLine.hidden = YES;
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.tableView setRowHeight:150];
            return customViewCellBlock;
        }
        else{
            // [tableView deleteRowsAtIndexPaths:[self.mutArrayProducts objectAtIndex:indexPath.row] withRowAnimation:UITableViewRowAnimationNone];
            [customViewCellBlock removeFromSuperview];
            customViewCellBlock.hidden = YES;
            customViewCellLine.hidden = NO;
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [self.tableView setRowHeight:377];
            return customViewCellLine;
        }
    }
}


-(void)loadButtonsProduct:(NSArray *)array{
    
    NSIndexPath *index = [array objectAtIndex:2];
    if ([[mutArrayProducts objectAtIndex:index.row] fotos] != nil) {
                NSString* urlThumb = [NSString stringWithFormat:@"%@/%@", [GlobalFunctions getUrlImagePath], [[[mutArrayProducts objectAtIndex:index.row] fotos] caminhoThumb]];
                
                [NSThread detachNewThreadSelector:@selector(loadImageGalleryThumbs:) toTarget:self 
                                       withObject:[NSArray arrayWithObjects:[array objectAtIndex:0], [array objectAtIndex:1], urlThumb, nil]];

    }else 
      [mutArrayDataThumbs addObject:[UIImage imageNamed:@"nopicture.png"]];
}

- (void)loadImageGalleryThumbs:(NSArray *)array {
    @try {
        UIImage *thumbImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:(NSString *)[array objectAtIndex:2]]]];
        [mutArrayDataThumbs addObject:thumbImage];
        [(productCustomViewCell *)[array objectAtIndex:0] imageView].image = thumbImage;
        [(productCustomViewCell *)[array objectAtIndex:1] imageView].image = thumbImage;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[mutArrayProducts objectAtIndex:indexPath.row];
    prdDetailVC.imageView               = [[UIImageView alloc] initWithImage:[mutArrayDataThumbs objectAtIndex:indexPath.row]];
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
    [self.searchBarProduct setShowsCancelButton:YES animated:YES];
    [self searchBar:searchBar activate:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the 
    // UISearchBar loses focus
    // We don't need to do anything here.
    [self.searchBarProduct setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Clear the search text
    // Deactivate the UISearchBar
    [self.searchBarProduct resignFirstResponder];
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
    [mutArrayProducts removeAllObjects];
    [mutArrayDataThumbs removeAllObjects];
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
        [searchBarProduct resignFirstResponder];
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

-(IBAction)changeSegControl{
    isSegmentedControlChanged = NO;
    [self.tableView reloadData];
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
