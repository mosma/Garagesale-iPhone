//
//  ViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 03/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize RKObjManeger;
@synthesize nsArrayProducts;
@synthesize scrollView;
@synthesize viewTopPage;
@synthesize searchBarProduct;
@synthesize activityLoadProducts;
@synthesize txtFieldSearch;
@synthesize viewSearch;
@synthesize labelSearch;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    [self reachability];
    [self loadAttribsToComponents];
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
   //[self setupProductMapping];
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
    
    activityLoadProducts.transform = CGAffineTransformMakeScale(0.65, 0.65); 
    
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:@"product" objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objects count] > 0) {
        [nsArrayProducts removeAllObjects];
        self.nsArrayProducts = (NSMutableArray *)objects;
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadButtonsProduct)
                                            object:nil];
        [queue addOperation:operation];
        [activityLoadProducts stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

- (void)loadAttribsToComponents{
    //Main Custom Tab Bar Controller
    UIImage *selectedImage0   = [UIImage imageNamed:@"homeOver.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"home.png"];
    UIImage *selectedImage1   = [UIImage imageNamed:@"addOver.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"add.png"];
    UIImage *selectedImage2   = [UIImage imageNamed:@"personOver.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"person.png"];
    UITabBar     *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0  = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1  = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2  = [tabBar.items objectAtIndex:2];
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    
    //Set Logo Top Button Not Account.
    logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoButton.frame = CGRectMake(33, 20, 253, 55);
    [logoButton setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    logoButton.adjustsImageWhenHighlighted = NO;
    [logoButton addTarget:self action:@selector(reloadPage:)
         forControlEvents:UIControlEventTouchDown];

    self.tabBarController.delegate = self;
    
    //init Global Functions
    globalFunctions = [[GlobalFunctions alloc] init];
    
    viewTopPage.layer.cornerRadius = 6;
    [viewTopPage.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [viewTopPage.layer setShadowOffset:CGSizeMake(1, 2)];
    [viewTopPage.layer setShadowOpacity:0.5];
    viewTopPage.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    viewSearch.layer.cornerRadius = 6;
    [viewSearch.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [viewSearch.layer setShadowOffset:CGSizeMake(1, 2)];
    [viewSearch.layer setShadowOpacity:0.5];
    viewSearch.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    [txtFieldSearch setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
    txtFieldSearch.delegate = self;
    labelSearch.font = [UIFont fontWithName:@"Corben" size:21];
    
    //set searchBar settings
    searchBarProduct.delegate           = self;
    searchBarProduct.placeholder        = NSLocalizedString(@"searchProduct", @"");
    
    [GlobalFunctions setSearchBarLayout:searchBarProduct];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.jpg"] 
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[GlobalFunctions getColorRedNavComponets]];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = [GlobalFunctions getLabelTitleGaragesaleNavBar:UITextAlignmentLeft width:300];
    
    scrollView.delegate = self;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    [GlobalFunctions tabBarController:theTabBarController didSelectViewController:viewController];
}

-(void)loadButtonsProduct{
    //NSOperationQueue *queue = [NSOperationQueue new];
   // NSLog(@"Integer  : %i", [self.nsArrayProducts count]);
    for(int i = 0; i < [self.nsArrayProducts count]; i++)
    {
        [NSThread detachNewThreadSelector:@selector(loadImageGalleryThumbs:) toTarget:self 
                               withObject:[NSArray arrayWithObjects:[self.nsArrayProducts objectAtIndex:i], 
                                                                    [NSNumber numberWithInt:i], 
                                                                     nil]];
    }
}

- (void)loadImageGalleryThumbs:(NSArray *)arrayDetailProduct {
    [scrollView addSubview:[globalFunctions loadButtonsThumbsProduct:arrayDetailProduct
                                                                     showEdit:NO 
                                                                     viewContr:self]];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (isSearch)
        [self showSearch:nil];
    [txtFieldSearch resignFirstResponder];
}

- (IBAction)reloadPage:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    for (UIButton *subview in [scrollView subviews]) 
        [subview removeFromSuperview];
    //[self loadAttribsToComponents];
    [scrollView addSubview:logoButton];
    [self setupProductMapping];
    
    //Set Display thumbs on Home.
    globalFunctions.countColumnImageThumbs = -1;
    globalFunctions.imageThumbsXorigin_Iphone = 10;
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil) {
        viewSearch.hidden = NO;
        viewTopPage.hidden = YES;
        logoButton.hidden = YES;
        [GlobalFunctions showTabBar:self.navigationController.tabBarController];
        [self.navigationController setNavigationBarHidden:NO];        
        globalFunctions.imageThumbsYorigin_Iphone = 10;
        self.scrollView.contentSize	= CGSizeMake(320,825);   
    }else {
        viewSearch.hidden = YES;
        viewTopPage.hidden = NO;
        logoButton.hidden = NO;
        globalFunctions.imageThumbsYorigin_Iphone = 95;
        [GlobalFunctions hideTabBar:self.navigationController.tabBarController];
        [self.navigationController setNavigationBarHidden:YES];
        self.scrollView.contentSize	= CGSizeMake(320,817);   
        //[self setHidesBottomBarWhenPushed:NO];
    }
}

- (void)gotoProductDetailVC:(UIButton *)sender{
    //NSLog(@"%i", sender.tag);
    
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[self.nsArrayProducts objectAtIndex:sender.tag];

    prdDetailVC.imageView               = [[UIImageView alloc] initWithImage:[[sender imageView] image]];
           
    [self.navigationController pushViewController:prdDetailVC animated:YES];
}

// Settings SearchBar
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
    //[self.searchBarProduct setShowsCancelButton:YES animated:YES];
   // UIButton *cancelButton = nil;
    //for(UIView *subView in searchBarProduct.subviews){
   //     if([subView isKindOfClass:UIButton.class]){
    //        cancelButton = (UIButton*)subView;
   //     }
   // }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the 
    // UISearchBar loses focus
    // We don't need to do anything here.
   // [self.searchBarProduct setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Clear the search text
    // Deactivate the UISearchBar
    [self.searchBarProduct resignFirstResponder];
    // searchBar.text=@"";
    //[self searchBar:searchBar activate:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self gotoProductTableViewController:searchBar.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
    [self gotoProductTableViewController:theTextField.text];
	return YES;
}

-(void)gotoProductTableViewController:(id)objetct{
    productTableViewController *prdTbl = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    //Search Service
    prdTbl.strLocalResourcePath = [NSString stringWithFormat:@"/search?q=%@", objetct];
    prdTbl.strTextSearch = objetct;
    [self.navigationController pushViewController:prdTbl animated:YES];
}

// Check if the network is available
- (void)reachability {
    [[RKClient sharedClient] isNetworkAvailable];
    // Register for changes in network availability
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reachabilityDidChange:)
                   name:RKReachabilityDidChangeNotification object:nil];
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    RKReachabilityObserver* observer = (RKReachabilityObserver *) [notification
                                                                   object];
    RKReachabilityNetworkStatus status = [observer networkStatus];
    if (RKReachabilityNotReachable == status) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No network access!"
                                                          message:@"check your connection."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else if (RKReachabilityReachableViaWiFi == status) {
        RKLogInfo(@"Online via WiFi!");
    } else if (RKReachabilityReachableViaWWAN == status) {
        RKLogInfo(@"Online via Edge or 3G!");
    }
}

//- (IBAction)signSearchTransform:(id)sender{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
//
//   if (!isSearch) {
//       viewSearch.transform = CGAffineTransformMakeTranslation(0, 37);
//       viewSignup.transform = CGAffineTransformMakeTranslation(0, 37);
//       [textFieldSearch becomeFirstResponder];
//    }
//    else {
//        viewSearch.transform = CGAffineTransformMakeTranslation(0, -37);
//        viewSignup.transform = CGAffineTransformMakeTranslation(0, 0);
//        [textFieldSearch resignFirstResponder];
//    }
//    
//   isSearch = !isSearch;
//    
//  //  viewSignup.transform = CGAffineTransformMakeRotation(0);
//    [UIView commitAnimations];
//}

- (IBAction)showSearch:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
    
    if (!isSearch) {
        searchBarProduct.transform = CGAffineTransformMakeTranslation(0, 42);
        [searchBarProduct becomeFirstResponder];
    }
    else {
        searchBarProduct.transform = CGAffineTransformMakeTranslation(0, -42);
        [searchBarProduct resignFirstResponder];
    }
    
    isSearch = !isSearch;
    
    //  viewSignup.transform = CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
}

-(IBAction)showSearchLoged:(id)sender{
    if ([txtFieldSearch isFirstResponder]){
        [txtFieldSearch resignFirstResponder];
        if (![txtFieldSearch.text isEqualToString:@""])
            [self gotoProductTableViewController:txtFieldSearch.text];
    }
    else
        [txtFieldSearch becomeFirstResponder];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    scrollView = nil;
    [self setScrollView:nil];
    activityLoadProducts = nil;
    [self setActivityLoadProducts:nil];
    txtFieldSearch = nil;
    [self setTxtFieldSearch:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadPage:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    if (isSearch)
        [self showSearch:nil];
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