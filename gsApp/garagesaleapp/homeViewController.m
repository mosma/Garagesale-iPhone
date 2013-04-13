//
//  homeViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 03/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "homeViewController.h"

@implementation homeViewController

@synthesize RKObjManeger;
@synthesize mutArrayProducts;
@synthesize scrollViewMain;
@synthesize viewTopPage;
@synthesize searchBarProduct;
@synthesize txtFieldSearch;
@synthesize viewSearch;
@synthesize isFromSignUp;
@synthesize buttonSignIn;
@synthesize buttonSignUp;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set Logo Top Button Not Account.
    buttonLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogo setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [buttonLogo setAdjustsImageWhenHighlighted:NO];
    [buttonLogo addTarget:self action:@selector(reloadPage:)
         forControlEvents:UIControlEventTouchDown];
    [buttonLogo setFrame:CGRectMake(34, 149, 253, 55)];
    
    [GlobalFunctions hideTabBar:self.navigationController.tabBarController animated:NO];
    
    //set searchBar settings
    searchBarProduct = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    //definind searchbar theme
    for(int i =0; i<[searchBarProduct.subviews count]; i++) {
        //text field
        if([[searchBarProduct.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
            [(UITextField*)[searchBarProduct.subviews objectAtIndex:i] setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
        }
        
        //button
        if([[searchBarProduct.subviews objectAtIndex:i] isKindOfClass:[UIButton class]]){
            UIButton * btn = (UIButton *)[searchBarProduct.subviews objectAtIndex:i];
            [btn.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14]];
        }
    }
    
    [searchBarProduct setDelegate:self];
    [searchBarProduct setPlaceholder:NSLocalizedString(@"searchProduct", @"")];
    
    [GlobalFunctions setSearchBarLayout:searchBarProduct];
    [self.view addSubview:searchBarProduct];
    
    if (IS_IPHONE_5) {
        [self.view setFrame:CGRectMake(0, 0, 320, 548)];
        [self.scrollViewMain setFrame:CGRectMake(0, 0, 320, 548)];
    } else {
        [self.view setFrame:CGRectMake(0, 0, 320, 460)];
        [self.scrollViewMain setFrame:CGRectMake(0, 0, 320, 460)];
    }

    [self loadAttribsToComponents];
}

- (void)loadAttribsToComponents{
    if (isFromSignUp) {
        [buttonLogo setCenter:CGPointMake(160, 50)];
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6f];
        [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
        [buttonLogo setCenter:CGPointMake(160, 50)];
        [UIView commitAnimations];
    }
    
    mutArrayProducts = [[NSMutableArray alloc] init];
    
    //Setting i18n
    [self.txtFieldSearch setPlaceholder:NSLocalizedString(@"homeSearchField", @"")];
    [self.buttonSignIn setTitle:NSLocalizedString(@"signinButton", @"") forState:UIControlStateNormal];
    [self.buttonSignUp setTitle:NSLocalizedString(@"signupButton", @"") forState:UIControlStateNormal];
    
    [self.buttonSignIn.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15.0f]];
    [self.buttonSignUp.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15.0f]];

    searchBarProduct.hidden=YES;
        
    shadowSearch = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 420)];
    [shadowSearch setBackgroundColor:[UIColor blackColor]];
    [shadowSearch setAlpha:0.7];
    [shadowSearch setHidden:YES];
    [self.view addSubview:shadowSearch];
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearch:)];
    [gest setNumberOfTouchesRequired:1];
    [shadowSearch addGestureRecognizer:gest];
    
    [viewTopPage.layer setCornerRadius:6];
    [viewTopPage.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [viewTopPage.layer setShadowOffset:CGSizeMake(1, 2)];
    [viewTopPage.layer setShadowOpacity:0.5];
    viewTopPage.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    [viewSearch.layer setCornerRadius:6];
    [viewSearch.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [viewSearch.layer setShadowOffset:CGSizeMake(1, 2)];
    [viewSearch.layer setShadowOpacity:0.5];
    viewSearch.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    [txtFieldSearch setFont:[UIFont fontWithName:@"Droid Sans" size:12.9]];
    [txtFieldSearch setDelegate:self];
    
    //set done at keyboard
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [numberToolbar setBarStyle:UIBarStyleBlackTranslucent];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle: NSLocalizedString(@"keyboard-cancel-btn" , nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancelSearchPad)], nil];
    [numberToolbar sizeToFit];
    [txtFieldSearch setInputAccessoryView:numberToolbar];
    
    //set searchBar settings
    [searchBarProduct setPlaceholder:NSLocalizedString(@"searchProduct", @"")];
    [self.navigationItem setHidesBackButton:YES];
    [GlobalFunctions setNavigationBarBackground:self.navigationController];
    [scrollViewMain setDelegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)getResourcePathProduct{
    [self setTrackedViewName:@"/"];
    
    RKObjectMapping *productMapping = [Mappings getProductMapping];
    RKObjectMapping *photoMapping = [Mappings getPhotoMapping];
    RKObjectMapping *caminhoMapping = [Mappings getCaminhoMapping];
    
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    
    //Relationship
    [photoMapping mapKeyPath:@"caminho" toRelationship:@"caminho" withMapping:caminhoMapping serialize:NO];
    
    //LoadUrlResourcePath
    NSString *path = [NSString stringWithFormat:@"product?count=%0d", [GlobalFunctions getHomeProductsNumber]];
    [self.RKObjManeger loadObjectsAtResourcePath:path objectMapping:productMapping delegate:self];
    
    productMapping = nil;
    photoMapping = nil;
    caminhoMapping = nil;
    path = nil;
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objects count] > 0) {
        [buttonLogo setUserInteractionEnabled:YES];
        for (int x=0; x < [objects count]; x++)
            [mutArrayProducts addObject:(Product *)[objects objectAtIndex:x]];
        
        [self loadButtonsProduct];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
        [activityImageView setAlpha:0];
        [UIView commitAnimations];
        
        if ([activityImageView isAnimating])
            [scrollViewMain setContentSize:CGSizeMake(320,scrollViewMain.contentSize.height+300)];
        [activityImageView stopAnimating];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [buttonLogo setUserInteractionEnabled:YES];
    NSLog(@"Encountered error: %@",                      error);
    NSLog(@"Encountered error.domain: %@",               error.domain);
    NSLog(@"Encountered error.localizedDescription: %@", error.localizedDescription);
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

-(void)setFlagFirstLoad{
    isAnimationLogo = YES;
    [self controlSearchArea];
}

-(void)cancelSearchPad{
    [txtFieldSearch resignFirstResponder];
}

-(void)loadButtonsProduct{
    //NSOperationQueue *queue = [NSOperationQueue new];
    @autoreleasepool {
        for(int i = [mutArrayProducts count] - [GlobalFunctions getHomeProductsNumber]; i < [mutArrayProducts count]; i++)
        {
            UIView *viewThumb = [globalFunctions
                                 loadButtonsThumbsProduct:[NSArray arrayWithObjects:
                                                           [mutArrayProducts objectAtIndex:i],
                                                           [NSNumber numberWithInt:i], nil]
                                 showEdit:NO
                                 showPrice:NO
                                 viewContr:self];
            [scrollViewMain addSubview:viewThumb];
            viewThumb = nil;
        }
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
}

- (BOOL)detectEndofScroll{
    BOOL scrollResult;
    CGPoint offset = self.scrollViewMain.contentOffset;
    CGRect bounds = self.scrollViewMain.bounds;
    CGSize size = self.scrollViewMain.contentSize;
    UIEdgeInsets inset = self.scrollViewMain.contentInset;
    float yaxis = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    if(yaxis > h) {
        scrollResult = YES;
    }else{
        scrollResult = NO;
    }
    return scrollResult;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int activity  = [GlobalFunctions getHomeProductsNumber] == 15 ? 80-countLoads : 17;
    int frameSize = [GlobalFunctions getHomeProductsNumber] == 15 ? 229 : 117;
    
    if ([self detectEndofScroll] && !activityImageView.isAnimating){
        if(countLoads < 6){
            //Position the activity image view somewhere in
            //the middle of your current view
            activityImageView.frame = CGRectMake(137, scrollView.contentSize.height+activity, 46, 45);
            
            //Start the animation
            [activityImageView startAnimating];
            [activityImageView setAlpha:1.0];
            [scrollViewMain addSubview:activityImageView];
            
            [self getResourcePathProduct];
            
            [scrollViewMain setContentSize:CGSizeMake(320,scrollView.contentSize.height+frameSize)];
            
            countLoads++;
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_lastContentOffset < (int)scrollViewMain.contentOffset.y) {
        if (!viewSearch.hidden || !viewTopPage.hidden){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil) {
                [viewSearch setAlpha:0];
                [GlobalFunctions hideTabBar:self.navigationController.tabBarController animated:YES];
            }else
                [viewTopPage setAlpha:0];
            [UIView commitAnimations];
            [txtFieldSearch resignFirstResponder];
        }
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil) {
            [viewSearch setAlpha:1.0];
            [GlobalFunctions showTabBar:self.navigationController.tabBarController];
        }else
            [viewTopPage setAlpha:1.0];
        [UIView commitAnimations];
    }
    if (isSearchDisplayed)
        [self showSearch:nil];
}

- (IBAction)reloadPage:(id)sender{
    int frameSize = [GlobalFunctions getHomeProductsNumber] == 15 ? 570 : 530;

    [buttonLogo setUserInteractionEnabled:NO];
    [mutArrayProducts removeAllObjects];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.navigationController setNavigationBarHidden:YES];
    for (UIButton *subview in [scrollViewMain subviews])
        [subview removeFromSuperview];
    [scrollViewMain addSubview:buttonLogo];
    
    RKObjManeger = nil;
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    
    globalFunctions = nil;
    globalFunctions = [[GlobalFunctions alloc] init];
    
    //Set Display thumbs on Home.
    [globalFunctions setCountColumnImageThumbs:-1];
    [globalFunctions setImageThumbsXorigin_Iphone:10];
    [globalFunctions setImageThumbsYorigin_Iphone:95];
    
    [scrollViewMain setContentOffset:CGPointMake(0, 0) animated:YES];
    countLoads = 0;
    
    [self controlSearchArea];
    
    if ([mutArrayProducts count] == 0) {
        [scrollViewMain setContentSize:CGSizeMake(320,frameSize)];
    }else {
        [scrollViewMain setContentSize:CGSizeMake(320,([mutArrayProducts count]*35)+130)];
    }
    
    NSTimer *load = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getResourcePathProduct) userInfo:nil repeats:NO];
        
    if (!isAnimationLogo) {
        [viewTopPage setHidden:YES];
        [viewSearch setHidden:YES];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setFlagFirstLoad) userInfo:nil repeats:NO];
    }
    load = nil;
    frameSize = nil;
}


-(void)controlSearchArea{
    if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil) {
        [viewSearch setHidden:NO];
        [viewTopPage setHidden:YES];
        [GlobalFunctions showTabBar:self.navigationController.tabBarController];
        searchBarProduct.hidden=YES;
    }else {
        [viewSearch setHidden:YES];
        [viewTopPage setHidden:NO];
        [GlobalFunctions hideTabBar:self.navigationController.tabBarController animated:YES];
    }
}

- (void)gotoProductDetailVC:(UIButton *)sender{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[mutArrayProducts objectAtIndex:sender.tag];
    [prdDetailVC setImageView:[[UIImageView alloc] initWithImage:[[sender imageView] image]]];
    [self.navigationController pushViewController:prdDetailVC animated:YES];
    prdDetailVC = nil;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
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
    UIButton *cancelButton = nil;
    for(UIView *subView in searchBarProduct.subviews){
        if([subView isKindOfClass:UIButton.class]){
            cancelButton = (UIButton*)subView;
        }
    }
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
    [self showSearch:nil];
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

-(void)gotoProductTableViewController:(id)object{    
    searchViewController *prdTbl = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    
    [prdTbl setStrLocalResourcePath:[NSString stringWithFormat:@"/search?q=%@",
                                     [object stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
    
    [prdTbl setStrTextSearch:object];
    
    [self.navigationController pushViewController:prdTbl animated:YES];
    prdTbl = nil;
}

- (IBAction)showSearch:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
    
    if (!isSearchDisplayed) {
        [searchBarProduct setHidden:NO];
        [shadowSearch setHidden:NO];
        [searchBarProduct becomeFirstResponder];
    }
    else {
        [searchBarProduct setHidden:YES];
        [shadowSearch setHidden:YES];
        [searchBarProduct resignFirstResponder];
    }
    isSearchDisplayed = !isSearchDisplayed;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [buttonLogo setUserInteractionEnabled:YES];
    self.tabBarController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
    if ([mutArrayProducts count] == 0 ||
        [[[GlobalFunctions getUserDefaults] objectForKey:@"reloadHome"] isEqual:@"YES"]){
        [self reloadPage:nil];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NO" forKey:@"reloadHome"];
        [userDefaults synchronize];
        userDefaults = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    if (isSearchDisplayed)
        [self showSearch:nil];
    [GlobalFunctions showTabBar:self.navigationController.tabBarController];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    RKObjManeger = nil;
    [self setRKObjManeger:nil];
    mutArrayProducts = nil;
    [self setMutArrayProducts:nil];
    viewTopPage = nil;
    [self setViewTopPage:nil];
    searchBarProduct = nil;
    [self setSearchBarProduct:nil];
    txtFieldSearch = nil;
    [self setSearchBarProduct:nil];
    isFromSignUp = nil;
    [self setIsFromSignUp:nil];
    scrollViewMain = nil;
    [self setScrollViewMain:nil];
    txtFieldSearch = nil;
    [self setTxtFieldSearch:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end