//
//  ViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 03/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize labelTitleTop;
@synthesize RKObjManeger;
@synthesize arrayTags;
@synthesize scrollView;
@synthesize imgViewLoading;
@synthesize searcBarProduct;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reachability];
    [self setLoadAnimation];
    [self.imgViewLoading startAnimating];
    [self setupCategoryMapping];
}

- (void)setupCategoryMapping {
    //Initializing the Object Manager
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    //Configure Object Mapping Category
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[Category class]];
    [categoryMapping mapKeyPath:@"id"           toAttribute:@"identifier"];
    [categoryMapping mapKeyPath:@"descricao"    toAttribute:@"descricao"];
    [categoryMapping mapKeyPath:@"idPessoa"     toAttribute:@"idPessoa"];
    //set path
    [RKObjManeger loadObjectsAtResourcePath:@"/category" objectMapping:categoryMapping delegate:self];
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];  
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objects count] > 0) {
      self.arrayTags = objects;
      [self loadAttribsToComponents];
      [GlobalFunctions drawTagsButton:self.arrayTags scrollView:self.scrollView viewController:self];
    }
}

 //   prdTbl.localResourcePath = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"/product?category=%@", [[sender titleLabel] text] ] cStringUsingEncoding:NSUTF8StringEncoding]];

- (void)gotoProductTableVC:(UIButton *)sender{
    productTableViewController *prdTbl = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    prdTbl.strLocalResourcePath = [NSString stringWithFormat:@"/product?category=%@", [[sender titleLabel] text] ];
    [self.navigationController pushViewController:prdTbl animated:YES];
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
    self.scrollView.contentSize	= CGSizeMake(320,625);
    /*
     If you want use UILabel
     [titleAPP setFont:[UIFont fontWithName:@"Corben" size:34]];
     [titleAPP setTextColor:[UIColor brownColor]];
     [titleAPP setText:@"Garagesaleapp"];
     */
    
    // Do the search and show the results in tableview
    // Deactivate the UISearchBar
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homeBackground.png"]];
    
    //set searchBar settings
    searcBarProduct                    = [[UISearchBar alloc] initWithFrame:CGRectMake(19,213,282,44)];
    searcBarProduct.delegate           = self;
    searcBarProduct.placeholder        = NSLocalizedString(@"searchProduct", @"");
    searcBarProduct.layer.borderWidth  = 1;
    searcBarProduct.layer.borderColor  = [[UIColor colorWithRed:245.0/255 green:244.0/255 blue:242.0/255 alpha:1.0] CGColor];
    searcBarProduct.tintColor          = [UIColor colorWithRed:245.0/255 green:244.0/255 blue:242.0/255 alpha:1.0];
    
    [self.scrollView addSubview:searcBarProduct];
    
    //Logo Button Settings
    UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoButton.frame = CGRectMake(10, 20, 300, 76);
    [logoButton setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    logoButton.adjustsImageWhenHighlighted = NO;
    [logoButton addTarget:self action:@selector(reloadPage:)
         forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:logoButton];
    
    [self.view addSubview:imgViewLoading];
    
    [self.imgViewLoading stopAnimating];
    [self.imgViewLoading setHidden:YES];
}

- (void)setLoadAnimation{
    NSArray *imageArray;
    
    imageArray = [[NSArray alloc] initWithObjects:
                  [UIImage imageNamed:@"load-frame1.png"],
                  [UIImage imageNamed:@"load-frame2.png"],
                  [UIImage imageNamed:@"load-frame3.png"],
                  [UIImage imageNamed:@"load-frame4.png"],nil];
    
    self.imgViewLoading.animationImages = imageArray;
    self.imgViewLoading.animationDuration = 0.9;
}

- (IBAction)reloadPage:(id)sender{
    for (UIButton *subview in [scrollView subviews]) 
        [subview removeFromSuperview];
    [self.imgViewLoading setHidden:NO];
    [self.imgViewLoading startAnimating];
    [self setupCategoryMapping];
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
    [self.searcBarProduct setShowsCancelButton:YES animated:YES];
    UIButton *cancelButton = nil;
    for(UIView *subView in searcBarProduct.subviews){
        if([subView isKindOfClass:UIButton.class]){
            cancelButton = (UIButton*)subView;
        }
    }
    [cancelButton setTintColor:[UIColor colorWithRed:145.0/255.0 green:159.0/255.0 blue:179.0/255.0 alpha:1.0]];}

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
    productTableViewController *prdTbl = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    
    //Search Service
    prdTbl.strLocalResourcePath = [NSString stringWithFormat:@"/search?q=%@", searchBar.text];
    prdTbl.strTextSearch = searchBar.text;
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

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    labelTitleTop = nil;
    [self setLabelTitleTop:nil];
    scrollView = nil;
    [self setScrollView:nil];
    imgViewLoading = nil;
    [self setImgViewLoading:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
