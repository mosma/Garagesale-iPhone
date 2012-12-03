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
@synthesize mutArrayProducts;
@synthesize scrollViewMain;
@synthesize viewTopPage;
@synthesize searchBarProduct;
@synthesize txtFieldSearch;
@synthesize viewSearch;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    self.trackedViewName = @"HomeViewController";
    [self loadAttribsToComponents];
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
}

- (void)loadAttribsToComponents{
//    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    NSInteger indFamily, indFont;
//    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
//    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames = [[NSArray alloc] initWithArray:
//                     [UIFont fontNamesForFamilyName:
//                      [familyNames objectAtIndex:indFamily]]];
//        for (indFont=0; indFont<[fontNames count]; ++indFont)
//        {
//            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
//        }
//    }
    
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
    
    [tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"barItemBackOver.png"]];
    [tabBar setBackgroundImage:[UIImage imageNamed:@"barItemBack.png"]];
    
    [item0 setTitle:@"Search"];
    [item1 setTitle:@"Add product"];
    [item2 setTitle:@"My garage"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DroidSans-Bold" size:10.0f], UITextAttributeFont, nil] forState:UIControlStateNormal];

    item0.titlePositionAdjustment = UIOffsetMake(0, -5);
    item1.titlePositionAdjustment = UIOffsetMake(0, -5);
    item2.titlePositionAdjustment = UIOffsetMake(0, -5);
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    //End Custom TabBarItems
    
    UIImage *statusImage = [UIImage imageNamed:@"ActivityHome00.png"];
    activityImageView = [[UIImageView alloc] initWithImage:statusImage];
    
    activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"ActivityHome00.png"],
                                         [UIImage imageNamed:@"ActivityHome01.png"],
                                         [UIImage imageNamed:@"ActivityHome02.png"],
                                         [UIImage imageNamed:@"ActivityHome03.png"],
                                         [UIImage imageNamed:@"ActivityHome04.png"],
                                         [UIImage imageNamed:@"ActivityHome05.png"],
                                         [UIImage imageNamed:@"ActivityHome06.png"],
                                         [UIImage imageNamed:@"ActivityHome07.png"],
                                         [UIImage imageNamed:@"ActivityHome00.png"],                                        
                                         nil];
    activityImageView.animationDuration = 1.0;
    
    //Set Logo Top Button Not Account.
    buttonLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLogo.frame = CGRectMake(33, 149, 253, 55);
    [buttonLogo setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    buttonLogo.adjustsImageWhenHighlighted = NO;
    [buttonLogo addTarget:self action:@selector(reloadPage:)
         forControlEvents:UIControlEventTouchDown];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    buttonLogo.center = CGPointMake(160, 50);
    [UIView commitAnimations];
    
    self.tabBarController.delegate = self;
    
    //init Global Functions
    globalFunctions = [[GlobalFunctions alloc] init];
    
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
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSearchPad)],
                           nil];
    [numberToolbar sizeToFit];
    [txtFieldSearch setInputAccessoryView:numberToolbar];
    
    //set searchBar settings
    searchBarProduct.delegate           = self;
    [searchBarProduct setPlaceholder:NSLocalizedString(@"searchProduct", @"")];
    
    [GlobalFunctions setSearchBarLayout:searchBarProduct];
    self.navigationItem.hidesBackButton = YES;
    
    [GlobalFunctions setNavigationBarBackground:self.navigationController];

    scrollViewMain.delegate = self;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)getResourcePathProduct{
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"HomeView"
                                                         withAction:@"LoadProduct"
                                                          withLabel:@"Load Home Product"
                                                          withValue:nil];
    
    RKObjectMapping *productMapping = [Mappings getProductMapping];
    RKObjectMapping *photoMapping = [Mappings getPhotoMapping];
    RKObjectMapping *caminhoMapping = [Mappings getCaminhoMapping];
    
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    
    //Relationship
    [photoMapping mapKeyPath:@"caminho" toRelationship:@"caminho" withMapping:caminhoMapping serialize:NO];
    
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:@"product?count=12" objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objects count] > 0) {
        [mutArrayProducts removeAllObjects];
        mutArrayProducts = (NSMutableArray *)objects;
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(loadButtonsProduct)
                                            object:nil];
        [queue addOperation:operation];
        //        [activityLoadProducts stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [activityImageView stopAnimating];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
        [activityImageView setAlpha:0];
        [UIView commitAnimations];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    
//    UIAlertView *alV = [[UIAlertView alloc] initWithTitle:@"Opz!" message:@"Houve um erro de comunicação com o servidor" delegate:self
//                     cancelButtonTitle:@"Ok" otherButtonTitles:@"tentar novamente", nil];
//
//    [alV show];
//    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

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

//- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
//    [GlobalFunctions tabBarController:theTabBarController didSelectViewController:viewController];   
//}

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
    [sheet showInView:self.view];
    [sheet showFromTabBar:self.tabBarController.tabBar];
    return NO;
    } else {
        return YES;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [GlobalFunctions setActionSheetAddProduct:self.tabBarController clickedButtonAtIndex:buttonIndex];
}

-(void)loadButtonsProduct{
    //NSOperationQueue *queue = [NSOperationQueue new];
   // NSLog(@"Integer  : %i", [self.nsArrayProducts count]);
    for(int i = 0; i < [mutArrayProducts count]; i++)
    {
        [NSThread detachNewThreadSelector:@selector(loadImageGalleryThumbs:) toTarget:self 
                               withObject:[NSArray arrayWithObjects:[mutArrayProducts objectAtIndex:i], 
                                                                    [NSNumber numberWithInt:i], 
                                                                     nil]];
    }
}

- (void)loadImageGalleryThumbs:(NSArray *)arrayDetailProduct {
    [scrollViewMain addSubview:[globalFunctions loadButtonsThumbsProduct:arrayDetailProduct
                                                                     showEdit:NO
                                                                     showPrice:NO
                                                                     viewContr:self]];
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
    if ([self detectEndofScroll] && !activityImageView.isAnimating){
        //UIAlertView *displayMessage = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Reached end of table scroll" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        //[displayMessage show];
        
        if(countLoads < 6){
            

//            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nopicture.png"]];
//            [imgV setFrame:CGRectMake(0, scrollViewMain.contentSize.height+150, 320, 50)];
            

            //Position the activity image view somewhere in
            //the middle of your current view
            activityImageView.frame = CGRectMake(137, scrollView.contentSize.height+30-(countLoads*7), 46, 45);
            
            //Start the animation
            [activityImageView startAnimating];
            [activityImageView setAlpha:1.0];
            [scrollViewMain addSubview:activityImageView];
            
            [self getResourcePathProduct];
            [scrollViewMain setContentSize:CGSizeMake(320,scrollView.contentSize.height+425)];

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
               // [self.navigationController setNavigationBarHidden:YES];
                [GlobalFunctions hideTabBar:self.navigationController.tabBarController];
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
            //[self.navigationController setNavigationBarHidden:NO];
            [GlobalFunctions showTabBar:self.navigationController.tabBarController];
        }else
            [viewTopPage setAlpha:1.0];
        [UIView commitAnimations];
    }
    if (isSearch)
        [self showSearch:nil];
}

- (IBAction)reloadPage:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.navigationController setNavigationBarHidden:YES];
    for (UIButton *subview in [scrollViewMain subviews])
        [subview removeFromSuperview];
    //[self loadAttribsToComponents];
    [scrollViewMain addSubview:buttonLogo];
    
    //Set Display thumbs on Home.
    [globalFunctions setCountColumnImageThumbs:-1];
    [globalFunctions setImageThumbsXorigin_Iphone:10];
    [globalFunctions setImageThumbsYorigin_Iphone:95];

    [scrollViewMain setContentOffset:CGPointMake(0, 0) animated:YES];
    countLoads = 0;

    [self controlSearchArea];
    
    if ([mutArrayProducts count] == 0) {
        [scrollViewMain setContentSize:CGSizeMake(320,530)];
    }else {
        [scrollViewMain setContentSize:CGSizeMake(320,([mutArrayProducts count]*35)+130)];
    }

    [self getResourcePathProduct];
    
    if (!isAnimationLogo) {
        [viewTopPage setHidden:YES];
        [viewSearch setHidden:YES];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setFlagFirstLoad) userInfo:nil repeats:NO];
    }
    
    
}


-(void)controlSearchArea{
    if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil) {
        [viewSearch setHidden:NO];
        [viewTopPage setHidden:YES];
        [GlobalFunctions showTabBar:self.navigationController.tabBarController];
        // [self.navigationController setNavigationBarHidden:NO];
        searchBarProduct.hidden=YES;
    }else {
        [viewSearch setHidden:YES];
        [viewTopPage setHidden:NO];
        [GlobalFunctions hideTabBar:self.navigationController.tabBarController];
        // [self.navigationController setNavigationBarHidden:YES];
        //[self setHidesBottomBarWhenPushed:NO];
        searchBarProduct.hidden=NO;
    }
}

- (void)gotoProductDetailVC:(UIButton *)sender{
    //NSLog(@"%i", sender.tag);
    
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[mutArrayProducts objectAtIndex:sender.tag];

    [prdDetailVC setImageView:[[UIImageView alloc] initWithImage:[[sender imageView] image]]];

    [self.navigationController pushViewController:prdDetailVC animated:YES];
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

-(void)gotoProductTableViewController:(id)objetct{
    productTableViewController *prdTbl = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    //Search Service
    [prdTbl setStrLocalResourcePath:[NSString stringWithFormat:@"/search?q=%@", objetct]];
    [prdTbl setStrTextSearch:objetct];
    [self.navigationController pushViewController:prdTbl animated:YES];
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
        [searchBarProduct setTransform:CGAffineTransformMakeTranslation(0, 64)];
        [searchBarProduct becomeFirstResponder];
    }
    else {
        [searchBarProduct setTransform:CGAffineTransformMakeTranslation(0, -64)];
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
    if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil)
        [GlobalFunctions showTabBar:self.navigationController.tabBarController];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    scrollViewMain = nil;
    [self setScrollViewMain:nil];
    //    activityLoadProducts = nil;
    //    [self setActivityLoadProducts:nil];
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