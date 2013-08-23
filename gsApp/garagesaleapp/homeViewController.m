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
@synthesize viewSearchFront;
@synthesize viewSearchFooter;
@synthesize isFromSignUp;
@synthesize buttonSignIn;
@synthesize buttonSignUp;

//@synthesize txtFieldSearch;
//@synthesize imgTxtField;
//@synthesize btCancelSearch;

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
    
    self.refreshControl = [[CKRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadPage:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0]];
    
    [GlobalFunctions hideTabBar:self.navigationController.tabBarController animated:NO];
    
    //set searchBar settings
    searchBarProduct = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    [self setLayoutTabBarController];
    
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

-(void)setLayoutTabBarController{
   // self.tabBarController = (UITabBarController *)self.window.rootViewController;
    
    UIImage         *selectedImage0     = [UIImage imageNamed:@"homeOver.png"];
    UIImage         *unselectedImage0   = [UIImage imageNamed:@"home.png"];
    UIImage         *selectedImage1     = [UIImage imageNamed:@"addOver.png"];
    UIImage         *unselectedImage1   = [UIImage imageNamed:@"add.png"];
    UIImage         *selectedImage2     = [UIImage imageNamed:@"personOver.png"];
    UIImage         *unselectedImage2   = [UIImage imageNamed:@"person.png"];
    
    UITabBar        *tabBar             = self.tabBarController.tabBar;
    UITabBarItem    *item0              = [tabBar.items objectAtIndex:0];
    UITabBarItem    *item1              = [tabBar.items objectAtIndex:1];
    UITabBarItem    *item2              = [tabBar.items objectAtIndex:2];
    
    [tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"barItemBackOver.png"]];
    [tabBar setBackgroundImage:[UIImage imageNamed:@"barItemBack.png"]];
    
    [item0 setTitle: NSLocalizedString( @"menu-explore", nil)];
    [item1 setTitle: NSLocalizedString( @"menu-add-product", nil)];
    [item2 setTitle: NSLocalizedString( @"menu-my-garage", nil)];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                                       UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:62.0/255.0 green:114.0/255.0 blue:39.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor, [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                   UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:67.0/255.0 green:129.0/255.0 blue:40.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor,nil] forState:UIControlStateSelected];
    
    [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor, [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                   UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor, [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                   UITextAttributeFont, nil] forState:UIControlStateSelected];
    
    [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor, [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                   UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                   UITextAttributeTextColor, [UIFont fontWithName:@"DroidSans-Bold" size:12.0f],
                                   UITextAttributeFont, nil] forState:UIControlStateSelected];
    
    if (IS_IPHONE_5) {
        item0.titlePositionAdjustment = UIOffsetMake(0,-4);
        item1.titlePositionAdjustment = UIOffsetMake(0,-4);
        item2.titlePositionAdjustment = UIOffsetMake(0,-4);
        [item0 setImageInsets:UIEdgeInsetsMake(-2.0, 0.0, 2.0, 0.0)];
        [item1 setImageInsets:UIEdgeInsetsMake(-2.0, 0.0, 2.0, 0.0)];
        [item2 setImageInsets:UIEdgeInsetsMake(-2.0, 0.0, 2.0, 0.0)];
    }else{
        item0.titlePositionAdjustment = UIOffsetMake(0,-2);
        item1.titlePositionAdjustment = UIOffsetMake(0,-2);
        item2.titlePositionAdjustment = UIOffsetMake(0,-2);
    }
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
}

- (void)loadAttribsToComponents{
    if (isFromSignUp) {
        if (IS_IPHONE_5)
            [buttonLogo setCenter:CGPointMake(160, 40)];
        else
            [buttonLogo setCenter:CGPointMake(160, 50)];
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6f];
        [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
        if (IS_IPHONE_5)
            [buttonLogo setCenter:CGPointMake(160, 40)];
        else
            [buttonLogo setCenter:CGPointMake(160, 50)];
        [UIView commitAnimations];
    }
    
    [viewSearchFront  setSettings];
    [viewSearchFooter setSettings];
    
    [viewSearchFront setParentVC:self];
    [viewSearchFooter setParentVC:self];
    
    if (IS_IPHONE_5){
        [viewSearchFront setCenter:CGPointMake(160, 136)];
        [viewTopPage setCenter:CGPointMake(160, 132)];
    }else {
        [viewSearchFront setCenter:CGPointMake(160, 146)];
        [viewTopPage setCenter:CGPointMake(160, 142)];
    }
    
    mutArrayProducts = [[NSMutableArray alloc] init];
    
    //Setting i18n
    [self.buttonSignIn setTitle:NSLocalizedString(@"signinButton", @"") forState:UIControlStateNormal];
    [self.buttonSignUp setTitle:NSLocalizedString(@"signupButton", @"") forState:UIControlStateNormal];
    
    [self.buttonSignIn.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15.0f]];
    [self.buttonSignUp.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15.0f]];

    searchBarProduct.hidden=YES;
    
    shadowSearch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    [shadowSearch setBackgroundColor:[UIColor whiteColor]];
    [shadowSearch setAlpha:0.6];
    [shadowSearch setHidden:YES];
    [self.view insertSubview:viewTopPage belowSubview:viewSearchFront];
    [self.view insertSubview:shadowSearch aboveSubview:viewTopPage];

    [viewTopPage.layer setCornerRadius:6];
    [viewTopPage.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [viewTopPage.layer setShadowOffset:CGSizeMake(1, 2)];
    [viewTopPage.layer setShadowOpacity:0.5];
    viewTopPage.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];

    //set searchBar settings
    [searchBarProduct setPlaceholder:NSLocalizedString(@"searchProduct", @"")];
    [self.navigationItem setHidesBackButton:YES];
    [GlobalFunctions setNavigationBarBackground:self.navigationController];
    [scrollViewMain setDelegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)getResourcePathProduct{
    [self setTrackedViewName:@"/home"];
    
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
        [self.refreshControl endRefreshing];
    }
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [buttonLogo setUserInteractionEnabled:YES];
    [self.refreshControl endRefreshing];
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

- (IBAction)showHideViewSearch:(id)sender{
    //Control to viewSearchFront
    if (scrollViewMain.contentOffset.y < 2400){
        if ([viewSearchFront.txtFieldSearch resignFirstResponder]) {
            [shadowSearch setHidden:YES];
            [viewSearchFront.txtFieldSearch resignFirstResponder];
        }
        else {
            [shadowSearch setHidden:NO];
            [viewSearchFront.txtFieldSearch becomeFirstResponder];
        }
    //Control to viewSearchFront
    }else{
        if ([viewSearchFooter.txtFieldSearch resignFirstResponder])
            [viewSearchFooter.txtFieldSearch resignFirstResponder];
        else 
            [viewSearchFooter.txtFieldSearch becomeFirstResponder];
        //Set contentOffSet to bottom
        CGPoint bottomOffset = CGPointMake(0, scrollViewMain.contentSize.height-scrollViewMain.frame.size.height);
        [scrollViewMain setContentOffset:bottomOffset animated:YES];
    }
    isTopViewShowing = !isTopViewShowing;
}
- (IBAction)showHideTopPage:(id)sender{
    if (!isTopViewShowing) {
        [searchBarProduct setHidden:NO];
        [shadowSearch setHidden:NO];
        [searchBarProduct becomeFirstResponder];
    }
    else {
        [searchBarProduct setHidden:YES];
        [shadowSearch setHidden:YES];
        [searchBarProduct resignFirstResponder];
    }
    isTopViewShowing = !isTopViewShowing;
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
           // viewThumb = nil;
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
    if ([self detectEndofScroll] && !activityImageView.isAnimating){
        if(countLoads < 6){
            [self getMoreProductsToScroll:scrollView];
            countLoads++;
        }
        if (countLoads == 7) {
            [self showPublicity:scrollView];
        }
        if (countLoads == 6) {
            countLoads++;
        }
    }
}
-(void)getMoreProductsToScroll:(UIScrollView *)scrollView{
    int activity  = [GlobalFunctions getHomeProductsNumber] == 15 ? 80-countLoads : 17;
    int frameSize = [GlobalFunctions getHomeProductsNumber] == 15 ? 229 : 117;

    //Position the activity image view somewhere in
    //the middle of your current view
    activityImageView.frame = CGRectMake(137, scrollView.contentSize.height+activity, 46, 45);
    
    //Start the animation
    [activityImageView startAnimating];
    [activityImageView setAlpha:1.0];
    [scrollViewMain addSubview:activityImageView];
    
    [self getResourcePathProduct];
    
    [scrollViewMain setContentSize:CGSizeMake(320,scrollView.contentSize.height+frameSize)];
    
}
-(void)showPublicity:(UIScrollView *)scrollView{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSString *learnMoreRANGER;
    NSString *addProductRANGER;
    NSString *garageNameRANGER;
    
    if ([language isEqualToString:@"en"]){
        learnMoreRANGER = @"Learn more";
        addProductRANGER = @"Add a Product";
        garageNameRANGER = @"www.gsapp.me/garagename";
    }else{
        learnMoreRANGER = @"Veja mais";
        addProductRANGER = @"Adicione um produto";
        garageNameRANGER = @"www.gsapp.me/suagaragem";
    }
    
    int spacePublicity = 330;
    [scrollViewMain setContentSize:CGSizeMake(320,scrollView.contentSize.height+spacePublicity)];
    
    UIImageView *addProduct = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"publicity02"]];
    UIImageView *learnMore  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"publicity01"]];
    [addProduct setFrame:CGRectMake(0, 0, addProduct.image.size.width, addProduct.image.size.height)];
    [learnMore  setFrame:CGRectMake(0, 0, learnMore.image.size.width,  learnMore.image.size.height)];
    
    [viewSearchFooter setHidden:NO];
    [viewSearchFooter setCenter:CGPointMake(self.view.bounds.size.width/2, scrollView.contentSize.height-345)];
    [addProduct      setCenter:CGPointMake(self.view.bounds.size.width/2, scrollView.contentSize.height-280)];
    [learnMore       setCenter:CGPointMake(self.view.bounds.size.width/2, scrollView.contentSize.height-160)];
    
    UIButton *login  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *signup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    login.frame  = CGRectMake(165, scrollView.contentSize.height-300, 135, 40);
    signup.frame = CGRectMake(20,  scrollView.contentSize.height-300, 135, 40);
    
    [login  setTitle:NSLocalizedString(@"signinButton", nil)  forState:UIControlStateNormal];
    [signup setTitle:NSLocalizedString(@"signupButton", nil) forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addProduct)];
    [tap  setNumberOfTapsRequired:1];
    [addProduct addGestureRecognizer:tap];
    [addProduct setUserInteractionEnabled:YES];
     
    [login addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
    [signup addTarget:self action:@selector(gotoSignUp) forControlEvents:UIControlEventTouchUpInside];

    OHAttributedLabel *label00 = [[OHAttributedLabel alloc] initWithFrame:
                                  CGRectMake(55, 10, addProduct.image.size.width-55, addProduct.image.size.height)];
    [label00 setBackgroundColor:[UIColor clearColor]];
    [label00 setNumberOfLines:2];
    NSString *text00 = NSLocalizedString(@"needsHelp", nil); 
    NSMutableAttributedString* attrStr0 = [NSMutableAttributedString
                                          attributedStringWithString:text00];
    [attrStr0 setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14.0]];
    [attrStr0 setTextColor:[UIColor whiteColor]];
    [attrStr0 setFont:[UIFont fontWithName:@"Droid Sans" size:14.0]
               range:[text00 rangeOfString:addProductRANGER]];
    [label00 setAttributedText:attrStr0];
    

    OHAttributedLabel *label01 = [[OHAttributedLabel alloc] initWithFrame:
                                  CGRectMake(55, 10, learnMore.image.size.width-55, learnMore.image.size.height)];
    [label01 setBackgroundColor:[UIColor clearColor]];
    [label01 setNumberOfLines:7];
    NSString *text01 = NSLocalizedString(@"learnMore", nil);
    NSMutableAttributedString* attrStr1 = [NSMutableAttributedString
                                          attributedStringWithString:text01];
    [attrStr1 setFont:[UIFont fontWithName:@"Droid Sans" size:14.0]];
    [attrStr1 setTextColor:[UIColor grayColor]];
    
    [attrStr1 setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14.0]
               range:[text01 rangeOfString:learnMoreRANGER]];
    
    [attrStr1 setTextColor:[UIColor blackColor]
                     range:[text01 rangeOfString:learnMoreRANGER]];
    
    [attrStr1 setTextColor:[UIColor redColor]
                range:[text01 rangeOfString:garageNameRANGER]];
    [label01 setAttributedText:attrStr1];

    [addProduct  addSubview:label00];
    [learnMore   addSubview:label01];

    [self.scrollViewMain addSubview:learnMore];
    
    if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil)
        [self.scrollViewMain addSubview:addProduct];
    else{
        [self.scrollViewMain addSubview:login];
        [self.scrollViewMain addSubview:signup];
    }
    [self.scrollViewMain addSubview:viewSearchFooter];
    
    countLoads++;
    
    addProduct = nil;
    learnMore = nil;
    label00 = nil;
    label01 = nil;
    text00 = nil;
    text01 = nil;
    attrStr0 = nil;
    attrStr1 = nil;
    signup = nil;
    login = nil;
}
-(void)gotoLogin{
    [self performSegueWithIdentifier:@"login" sender:self];
}
-(void)gotoSignUp{
    [self performSegueWithIdentifier:@"signup" sender:self];
}
-(void)addProduct{
    self.tabBarController.selectedIndex = 1;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_lastContentOffset < (int)scrollViewMain.contentOffset.y) {
        if (!viewSearchFront.hidden || !viewTopPage.hidden){
            [viewSearchFront setAlpha:0];
            if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil) {

                [GlobalFunctions hideTabBar:self.navigationController.tabBarController animated:YES];
            }else
                [viewTopPage setAlpha:0];
            [viewSearchFront.txtFieldSearch resignFirstResponder];
        }
    }else{
        //Conditional to not showing viewSearchFront with viewSearchFooter togheter.
        if (scrollView.contentOffset.y < 2400)
            [viewSearchFront setAlpha:1.0];
        
        if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil) {
            [GlobalFunctions showTabBar:self.navigationController.tabBarController];
        }else {
            if (scrollView.contentOffset.y < 2400)
                [viewTopPage setAlpha:1.0];
        }
    }
}

- (IBAction)reloadPage:(id)sender{
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Home"
                                                     withAction:@"Reload"
                                                      withLabel:@"Reload Products Screen"
                                                      withValue:nil];

    int frameSize = [GlobalFunctions getHomeProductsNumber] == 15 ? 570 : 530;

    [buttonLogo setUserInteractionEnabled:NO];
    [mutArrayProducts removeAllObjects];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.navigationController setNavigationBarHidden:YES];
    for (UIButton *subview in [scrollViewMain subviews])
        [subview removeFromSuperview];
    [scrollViewMain addSubview:buttonLogo];
    [scrollViewMain addSubview:self.refreshControl];
    
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    
    globalFunctions = [[GlobalFunctions alloc] init];
    
    //Set Display thumbs on Home.
    [globalFunctions setCountColumnImageThumbs:-1];
    [globalFunctions setImageThumbsXorigin_Iphone:10];
    if (IS_IPHONE_5)
        [globalFunctions setImageThumbsYorigin_Iphone:85];
    else
        [globalFunctions setImageThumbsYorigin_Iphone:95];

    countLoads = 0;
    
    [self controlSearchArea];
    
    if ([mutArrayProducts count] == 0) {
        [scrollViewMain setContentSize:CGSizeMake(320,frameSize)];
    }else {
        [scrollViewMain setContentSize:CGSizeMake(320,([mutArrayProducts count]*35)+130)];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getResourcePathProduct) userInfo:nil repeats:NO];
        
    if (!isAnimationLogo) {
        [viewTopPage setHidden:YES];
        [viewSearchFront setHidden:YES];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setFlagFirstLoad) userInfo:nil repeats:NO];
    }
//    frameSize = nil;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (!isTopViewShowing) 
        [self showHideViewSearch:nil];
    return YES;
}

-(void)controlSearchArea{
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] init];
    [gest setNumberOfTouchesRequired:1];
    if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil) {
        [gest addTarget:self action:@selector(showHideViewSearch:)];
        [viewSearchFront setHidden:NO];
        [viewTopPage setHidden:YES];
        [GlobalFunctions showTabBar:self.navigationController.tabBarController];
        searchBarProduct.hidden=YES;
    }else {
        [gest addTarget:self action:@selector(showHideTopPage:)];
        [viewSearchFront setHidden:YES];
        [viewTopPage setHidden:NO];
        [GlobalFunctions hideTabBar:self.navigationController.tabBarController animated:YES];
    }
    [shadowSearch addGestureRecognizer:gest];
    gest = nil;
}

- (void)gotoProductDetailVC:(UIButton *)sender{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    prdDetailVC.product = (Product *)[mutArrayProducts objectAtIndex:sender.tag];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[[sender imageView] image]];
    [prdDetailVC setImageView:imgV];
    [self.navigationController pushViewController:prdDetailVC animated:YES];
    prdDetailVC = nil;
    imgV = nil;
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
    [self showHideTopPage:nil];
    // searchBar.text=@"";
    //[self searchBar:searchBar activate:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self gotoProductTableViewController:searchBar.text];
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
    if (isTopViewShowing)
        [self showHideTopPage:nil];
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
    viewSearchFront = nil;
    [self setViewSearchFront:nil];
    viewSearchFooter = nil;
    [self setViewSearchFooter:nil];
    [self setSearchBarProduct:nil];
    isFromSignUp = nil;
    [self setIsFromSignUp:nil];
    scrollViewMain = nil;
    [self setScrollViewMain:nil];
    self.refreshControl = nil;
    [self setRefreshControl:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end


@implementation viewSearchArea

-(void)setSettings{
    [self.txtFieldSearch setPlaceholder:NSLocalizedString(@"homeSearchField", @"")];
    [self.layer setCornerRadius:6];
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOffset:CGSizeMake(1, 2)];
    [self.layer setShadowOpacity:0.7];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    [self.txtFieldSearch setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frameCopy1 = self.imgTxtField.frame;
        frameCopy1.size.width = 213.f;
        self.imgTxtField.frame = frameCopy1;
        
        CGRect frameCopy2 = self.txtFieldSearch.frame;
        frameCopy2.size.width = 178.f;
        self.txtFieldSearch.frame = frameCopy2;
        
        [self.btCancelSearch setHidden:NO];
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frameCopy1 = self.imgTxtField.frame;
        frameCopy1.size.width = 267.f;
        self.imgTxtField.frame = frameCopy1;
        
        CGRect frameCopy2 = self.txtFieldSearch.frame;
        frameCopy2.size.width = 232.f;
        self.txtFieldSearch.frame = frameCopy2;
        
        [self.btCancelSearch setHidden:YES];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
    [(homeViewController *)_parentVC gotoProductTableViewController:theTextField.text];
	return YES;
}

@end
