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
@synthesize mutDictDataThumbs;
@synthesize activityIndicator;
@synthesize RKObjManeger;
@synthesize searchBarProduct;
@synthesize strLocalResourcePath;
@synthesize strTextSearch;
@synthesize OHlabelTitleResults;
@synthesize segmentControl;

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
    //Initializing the Object Managers
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
    [productMapping mapKeyPath:@"link"          toAttribute:@"link"];
    [productMapping mapKeyPath:@"id"            toAttribute:@"id"];
    
    //Configure Photo Object Mapping
    RKObjectMapping *photoMapping = [RKObjectMapping mappingForClass:[Photo class]];
    [photoMapping mapAttributes:
     @"caminhoThumb",
     @"caminhoTiny",
     @"principal",
     @"idProduto",
     @"id",
     @"id_estado",
     nil];
    
    //Configure Photo Object Mapping
    RKObjectMapping *caminhoMapping = [RKObjectMapping mappingForClass:[Caminho class]];
    [caminhoMapping mapAttributes:
     @"icon",
     @"listing",
     @"listingscaled",
     @"mobile",
     @"original",
     nil];
        
    //set Local Resource Defautl
    if ([strLocalResourcePath length] == 0) 
        strLocalResourcePath = @"/product";

    
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    
    //Relationship
    [photoMapping mapKeyPath:@"caminho" toRelationship:@"caminho" withMapping:caminhoMapping serialize:NO];
    
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:strLocalResourcePath objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/plain"];
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

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (isSearch)
        [self showSearch:nil];
    [searchBarProduct resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)loadAttribsToComponents:(BOOL)isFromLoadObject{
    if (!isFromLoadObject) {
        //set searchBar settings
        searchBarProduct = [[UISearchBar alloc]initWithFrame:CGRectMake(0,-200,320,40)];
        searchBarProduct.delegate = self;
        searchBarProduct.placeholder = NSLocalizedString(@"searchProduct", @"");
        
        self.tableView.delegate = self;
        
        [GlobalFunctions setSearchBarLayout:searchBarProduct];
        
        [self.navigationController.navigationBar setTintColor:[GlobalFunctions getColorRedNavComponets]];
        
        self.navigationItem.title = NSLocalizedString(@"products", @"");
        [self.tableView addSubview:searchBarProduct];

        self.navigationItem.leftBarButtonItem   = [GlobalFunctions getIconNavigationBar:
                                                 @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];
 
        self.navigationItem.rightBarButtonItem  = [GlobalFunctions getIconNavigationBar:
                                                 @selector(showSearch:) viewContr:self imageNamed:@"btSearchAccount.png"];
        segmentControl.selectedSegmentIndex = 0;
        [self.tableView setRowHeight:377];
        
    }else {
            
        if ([self.strTextSearch length] != 0)
            searchBarProduct.text = self.strTextSearch;
        mutDictDataThumbs = [[NSMutableDictionary alloc] init];
        
        NSString *text = [NSString stringWithFormat:@"%i results for \"%@\"", [mutArrayProducts count], strTextSearch];
        NSString *count = [NSString stringWithFormat:@"%i", [mutArrayProducts count]];

        
        NSMutableAttributedString  *attrStr         = [NSMutableAttributedString attributedStringWithString:text];
        [attrStr setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:15] range:[text rangeOfString:@"results for"]];
        [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
        [attrStr setTextColor:[UIColor redColor] range:[text rangeOfString:count]];
        [attrStr setTextColor:[UIColor redColor] range:[text rangeOfString:[NSString stringWithFormat:@"\"%@\"", strTextSearch]]];
        
        OHlabelTitleResults.attributedText = attrStr;
    }
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showSearch:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromTop];
    
    if (!isSearch) {
        searchBarProduct.transform = CGAffineTransformMakeTranslation(0, self.tableView.contentOffset.y+200);
        [searchBarProduct becomeFirstResponder];
    }
    else {
        searchBarProduct.transform = CGAffineTransformMakeTranslation(0, -(self.tableView.contentOffset.y+200));
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
    
    //Instacied cells CellBlock and CellLine
    productCustomViewCell *customViewCellBlock = [tableView dequeueReusableCellWithIdentifier:@"customViewCellBlock"];
    productCustomViewCell *customViewCellLine = [tableView dequeueReusableCellWithIdentifier:@"customViewCellLine"];

    NSString *garageName = [[mutArrayProducts objectAtIndex:indexPath.row] idPessoa ];
    
    //Attibuted at strFormat values : Currency, Valor Esperado.
    NSString                   *currency        = [GlobalFunctions getCurrencyByCode:(NSString *)
                                                   [[self.mutArrayProducts objectAtIndex:indexPath.row] currency]];
    NSString                   *valorEsperado   = [[self.mutArrayProducts objectAtIndex:indexPath.row] valorEsperado ];
    NSString                   *strFormat       = [NSString stringWithFormat:@"%@%@ by %@", currency, valorEsperado, 
                                                   [[mutArrayProducts objectAtIndex:indexPath.row] idPessoa ]];

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
    
    //Check Flag idEstado (1 - Não Vendido, 2 - Vendido)
    if ([[[self.mutArrayProducts objectAtIndex:indexPath.row] idEstado] intValue] == 2){
        [[customViewCellBlock valorEsperado]       setFont:[UIFont fontWithName:@"Droid Sans" size:20 ]];
        [[customViewCellBlock valorEsperado] setText:@"Vendido"];
        [[customViewCellBlock valorEsperado] setTextColor:[UIColor colorWithRed:(float)255/255.0 \
                                                           green:(float)102/255.0 \
                                                            blue:(float)102/255.0 alpha:1.0]];
        
        customViewCellLine.valorEsperado = customViewCellBlock.valorEsperado;
        
    }else{
        customViewCellBlock.valorEsperado.attributedText = attrStr;
        customViewCellLine.valorEsperado.attributedText = attrStr;
    }
    
                
    

//    NSData  *imageData  = [NSData dataWithContentsOfURL:[GlobalFunctions getGravatarURL:[[GlobalFunctions getUserDefaults] objectForKey:@"email"]]];
//    UIImage *image      = [[UIImage alloc] initWithData:imageData];
//    customViewCellBlock.imageGravatar.image = image;
    
    //Set CellBlock Values
    [[customViewCellBlock productName] setText:(NSString *)[[mutArrayProducts objectAtIndex:indexPath.row] nome]];
    [[customViewCellBlock productName] setFont:[UIFont fontWithName:@"Droid Sans" size:15]];
    //[customViewCellBlock imageView].image = [UIImage imageNamed:@"nopicture.png"];
    
    
    //Set Gravatar at CellBlock.
    //NSData  *imageData  = [NSData dataWithContentsOfURL:[GlobalFunctions getGravatarURL:[[mutArrayProducts objectAtIndex:indexPath.row] email]]];
    //UIImage *image      = [[UIImage alloc] initWithData:imageData];
    

    //Set CellLine Values
    [[customViewCellLine productName] setText:(NSString *)[[mutArrayProducts objectAtIndex:indexPath.row] nome]];
    [[customViewCellLine productName] setFont:[UIFont fontWithName:@"Droid Sans" size:15]];
    //[customViewCellLine imageView].image = [UIImage imageNamed:@"nopicture.png"];    
    

    //NSLog(@"------------------>%i", indexPath.row);
    
    
    customViewCellBlock.imageView.image = [UIImage imageNamed:@"nopicture.png"];
    customViewCellLine.imageView.image = [UIImage imageNamed:@"nopicture.png"]; 

    
    customViewCellBlock.imageView.layer.cornerRadius = 5.0f;


    
//    UIProgressView *progressProgressView = [[UIProgressView alloc] init];
//    progressProgressView.frame = CGRectMake(20, 120, 280, 9);
//    progressProgressView.progress = 0.1;
//    progressProgressView.progressTintColor = [UIColor grayColor];
//
//    
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] 
//                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    
//    CGRect frame = spinner.frame;
//    frame.origin.x = customViewCellLine.imageView.frame.size.width / 2 - frame.size.width / 2;
//    frame.origin.y = customViewCellLine.imageView.frame.size.height / 2 - frame.size.height / 2;
//    spinner.frame = frame;
//    [customViewCellLine insertSubview:spinner aboveSubview:customViewCellLine.imageView];
//    [customViewCellBlock insertSubview:progressProgressView aboveSubview:customViewCellBlock.imageView];
//    [spinner startAnimating];
    
   
//    progressProgressView.progress = 0.03;
    
    //if ([mutDictDataThumbs count] > indexPath.row) {
    if ([[mutDictDataThumbs allKeys] containsObject:[NSString stringWithFormat:@"%i", indexPath.row]]) {
        customViewCellBlock.imageView.image = [mutDictDataThumbs objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];
        customViewCellLine.imageView.image = [mutDictDataThumbs objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];  
    }else {
        if ([mutArrayProducts count] != [mutDictDataThumbs count]) {
            NSOperationQueue *queue = [NSOperationQueue new];
            NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                                initWithTarget:self
                                                selector:@selector(loadImageAtIndexPath:)
                                                object:[NSArray arrayWithObjects:
                                                        customViewCellBlock, 
                                                        customViewCellLine, 
                                                        indexPath, nil]];
            [queue addOperation:operation];
        }
    }
    
    if (!isSegmentedControlChanged) {
        if(segmentControl.selectedSegmentIndex == 0){
            [customViewCellLine removeFromSuperview];
            customViewCellBlock.hidden = NO;
            customViewCellLine.hidden = YES;
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.tableView setRowHeight:122];
            return customViewCellBlock;
        }
        else{
            // [tableView deleteRowsAtIndexPaths:[self.mutArrayProducts objectAtIndex:indexPath.row] withRowAnimation:UITableViewRowAnimationNone];
            [customViewCellBlock removeFromSuperview];
            customViewCellBlock.hidden = YES;
            customViewCellLine.hidden = NO;
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [self.tableView setRowHeight:367];
            return customViewCellLine;
        }
    }
}


-(void)loadImageAtIndexPath:(NSArray *)array{
    
    
    NSIndexPath *index = [array objectAtIndex:2];
    if ([[mutArrayProducts objectAtIndex:index.row] fotos] != nil) {

        NSString* urlThumb = [[[[[[mutArrayProducts objectAtIndex:index.row] fotos] objectAtIndex:0] caminho] objectAtIndex:0] listing];
                
        [NSThread detachNewThreadSelector:@selector(loadImageGalleryThumbs:) toTarget:self 
                                       withObject:[NSArray arrayWithObjects:
                                                   [array objectAtIndex:0], 
                                                   [array objectAtIndex:1], 
                                                   urlThumb,
                                                   index, nil]];
    }else {
        [mutDictDataThumbs setObject:[UIImage imageNamed:@"nopicture.png"] forKey:[NSString stringWithFormat:@"%i", index.row]];
        [(productCustomViewCell *)[array objectAtIndex:0] imageView].image = [UIImage imageNamed:@"nopicture.png"];
        [(productCustomViewCell *)[array objectAtIndex:1] imageView].image = [UIImage imageNamed:@"nopicture.png"];
    }
}

- (void)loadImageGalleryThumbs:(NSArray *)array {
    @try {
        UIImage *thumbImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:(NSString *)[array objectAtIndex:2]]]];
        
        NSIndexPath *index = [array objectAtIndex:3];
        
        [mutDictDataThumbs setObject:thumbImage forKey:[NSString stringWithFormat:@"%i", index.row]];
        
        //[mutArrayDataThumbs addObject:thumbImage];
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
    prdDetailVC.imageView               = [[UIImageView alloc] initWithImage:[mutDictDataThumbs objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]]];
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
    [mutDictDataThumbs removeAllObjects];
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
    
    [mutDictDataThumbs removeAllObjects];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
    [self.tableView reloadInputViews];

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    switch (buttonIndex) {
        case 0:
            [userDefaults setInteger:0 forKey:@"controlComponentsAtFirstDisplay"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 1:
            self.tabBarController.selectedIndex = 1;
            [userDefaults setInteger:1 forKey:@"controlComponentsAtFirstDisplay"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 2:
            self.tabBarController.selectedIndex = 1;
            [userDefaults setInteger:2 forKey:@"controlComponentsAtFirstDisplay"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 3:
            [userDefaults setBool:NO forKey:@"isProductDisplayed"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break; //Cancel
    }
    if (buttonIndex != 3)
        self.tabBarController.selectedIndex = 1;
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    
    activityIndicator = nil;
    [self setActivityIndicator:nil];
    
    
    mutDictDataThumbs = nil;
    [self setMutDictDataThumbs:nil];
    
    mutArrayProducts = nil;
    [self setMutArrayProducts:nil];
    
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
