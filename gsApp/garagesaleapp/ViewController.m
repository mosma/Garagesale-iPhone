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
@synthesize arrayProducts;
@synthesize scrollView;
@synthesize viewTopPage;
@synthesize searchBarProduct;
@synthesize activityMain;

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
    [self setupProductMapping];
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
    
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:@"product" objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([objects count] > 0) {
      self.arrayProducts = objects;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                                    initWithTarget:self
                                                    selector:@selector(loadProducts)
                                                    object:nil];
        [queue addOperation:operation];
        [activityMain stopAnimating];

     // [self loadProducts];
        
    }
}

- (void)gotoProductDetailVC:(UIButton *)sender{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[self.arrayProducts objectAtIndex:sender.tag];
    [self.navigationController pushViewController:prdDetailVC animated:YES];
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
    //[self hideTabBar:self.navigationController.tabBarController];

    
    [self.navigationController.tabBarController setHidesBottomBarWhenPushed:NO];
    
    //Logo Button Settings
    UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoButton.frame = CGRectMake(33, 20, 253, 55);
    [logoButton setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    logoButton.adjustsImageWhenHighlighted = NO;
    [logoButton addTarget:self action:@selector(reloadPage:)
         forControlEvents:UIControlEventTouchDown];
    
    countColumn   = -1;
    imageXPostion = 10;
    imageYPostion = 95;
    
    self.scrollView.contentSize	= CGSizeMake(320,825);   
    
    //[GlobalFunctions roundedLayer:viewTopPage.layer radius:2.0 shadow:YES];  
    //[viewLayer setMasksToBounds:YES];
    //[viewLayer setBorderColor:[RGB(180, 180, 180) CGColor]];
    //[viewTopPage.layer setBorderWidth:0.3f];
    
    viewTopPage.layer.cornerRadius = 6;
    [viewTopPage.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [viewTopPage.layer setShadowOffset:CGSizeMake(1, 2)];
    [viewTopPage.layer setShadowOpacity:0.5];

    //set searchBar settings
    searchBarProduct.delegate           = self;
    searchBarProduct.placeholder        = NSLocalizedString(@"searchProduct", @"");

    [GlobalFunctions setSearchBarLayout:searchBarProduct];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.jpg"] 
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[GlobalFunctions getColorRedNavComponets]];
    [self.scrollView addSubview:logoButton];
}

- (void) hideTabBar:(UITabBarController *) tabbarcontroller {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    [UIView commitAnimations];
}


//-(void)scrollViewDidScroll:(UIScrollView *)myScrollView {
//	/**
//	 *	calculate the current page that is shown
//	 *	you can also use myScrollview.frame.size.height if your image is the exact size of your scrollview
//	 */
//	int currentPage = (self.scrollView.contentOffset.y / currentImageSize.height);
//    
//	// display the image and maybe +/-1 for a smoother scrolling
//	// but be sure to check if the image already exists, you can do this very easily using tags
//	if ( [myScrollView viewWithTag:(currentPage +1)] ) {
//		return;
//	}
//	else {
//		// view is missing, create it and set its tag to currentPage+1
//	}
//    
//	/**
//	 *	using your paging numbers as tag, you can also clean the UIScrollView
//	 *	from no longer needed views to get your memory back
//	 *	remove all image views except -1 and +1 of the currently drawn page
//	 */
//	for ( int i = 0; i < currentPages; i++ ) {
//		if ( (i < (currentPage-1) || i > (currentPage+1)) && [myScrollView viewWithTag:(i+1)] ) {
//			[[myScrollView viewWithTag:(i+1)] removeFromSuperview];
//		}
//	}
//} 


//- (void)displayImage:(UIActivityIndicatorView *)image {
//    [image stopAnimating];
//
//}

-(void)loadProducts{
    //NSOperationQueue *queue = [NSOperationQueue new];
    for(int i = 0; i < [self.arrayProducts count]; i++)
    {
       // if ([[self.arrayProducts objectAtIndex:i] fotos] == nil) {
            NSString* urlThumb = [NSString stringWithFormat:@"http://www.garagesaleapp.me/%@", [[[self.arrayProducts objectAtIndex:i] fotos] caminhoThumb]];
            
            [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self 
                                   withObject:[NSArray arrayWithObjects:urlThumb, [NSNumber numberWithInt:i] , nil]];
        //}
    }
}

- (void)loadImage:(NSArray *)params {
    NSData      *imageData  = [[NSData alloc] initWithContentsOfURL:
                               [NSURL URLWithString:(NSString *)[params objectAtIndex:0]]];
    
    int index = [[params objectAtIndex:1] intValue];
    
    NSLog(@"%i",index);
    
    UIImage     *image;
    if ([[self.arrayProducts objectAtIndex:index] fotos] == NULL)    
        image      = [UIImage imageNamed:@"nopicture.png"];
    else 
        image      = [[UIImage alloc] initWithData:imageData];
    
    if (countColumn == 3) {
        imageXPostion = 10;
        imageYPostion = imageYPostion + 103;
        countColumn = 0;
    } else if (countColumn >= 1){
        imageXPostion = imageXPostion + 103;
    }
    
    if (countColumn == -1)
        countColumn++;
    
    countColumn++;
    
    UIButton    *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imgButton.frame = CGRectMake(imageXPostion, imageYPostion, 94, 94);
    [imgButton setTag:index];
    [imgButton addTarget:self action:@selector(gotoProductDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] 
//                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    
//    [spinner setCenter:CGPointMake(imgButton.frame.size.width/2, 
//                                   imgButton.frame.size.height/2)];
//    
//    UIGraphicsBeginImageContext(spinner.frame.size);
    
//    [image drawInRect:CGRectMake(0,0,spinner.frame.size.width, spinner.frame.size.height)];
    //UIImage* resizedSpacer = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    // tagsButton.image = resizedSpacer;
    //[imgButton addSubview:spinner];
   // [spinner startAnimating];
    [imgButton setImage:image forState:UIControlStateNormal];
    
    //[self performSelectorOnMainThread:@selector(displayImage:) withObject:spinner waitUntilDone:NO];
    
    [scrollView addSubview:imgButton];
}

- (IBAction)reloadPage:(id)sender{
    for (UIButton *subview in [scrollView subviews]) 
        [subview removeFromSuperview];
    [self loadAttribsToComponents];
    [self setupProductMapping];
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

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    labelTitleTop = nil;
    [self setLabelTitleTop:nil];
    scrollView = nil;
    [self setScrollView:nil];
    activityMain = nil;
    [self setActivityMain:nil];
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