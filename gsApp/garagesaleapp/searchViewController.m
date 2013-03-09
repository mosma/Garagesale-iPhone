//
//  searchViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 07/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "searchViewController.h"
#import "NSAttributedString+Attributes.h"
#import "AsyncImageView.h"

@interface searchViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation searchViewController

@synthesize mutArrayProducts;
@synthesize mutArrayViewHelpers;
@synthesize RKObjManeger;
@synthesize searchBarProduct;
@synthesize strLocalResourcePath;
@synthesize strTextSearch;
@synthesize OHlabelTitleResults;
@synthesize segmentControl;
@synthesize viewSegmentArea;
@synthesize imageURLs;
@synthesize tableView;

- (void)awakeFromNib
{
    NSMutableArray *URLs = [NSMutableArray array];
    if ([mutArrayProducts count ] > 0) {
        @try {
            for (int x=0; x<[mutArrayProducts count]; x++) {
                NSString* urlThumb;
                @try {
                    urlThumb = [[[[[[mutArrayProducts objectAtIndex:x] fotos] objectAtIndex:0] caminho] objectAtIndex:0] mobile];
                }
                @catch (NSException *exception) {
                    urlThumb = @"http://garagesaleapp.me/images/nopicture.png";
                    NSLog(@"%@", exception.description);
                }
                @finally {
                }
                
                NSURL *URL = [NSURL URLWithString:urlThumb];
                if (URL)
                {
                    [URLs addObject:URL];
                }
                else
                {
                    NSLog(@"'%@' is not a valid URL", urlThumb);
                }
                //NSLog(@"mutArrayProducts indice : %i",x);
            }
            self.imageURLs = URLs;
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            ;
        }
        [self changeSegControl:nil];
    }
    [super awakeFromNib];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IPHONE_5) {
        [self.view setFrame:CGRectMake(0, 0, 320, 568)];
        [self.tableView setFrame:CGRectMake(0, 0, 320, 553)];
    } else {
        [self.view setFrame:CGRectMake(0, 0, 320, 480)];
        [self.tableView setFrame:CGRectMake(0, 0, 320, 465)];
    }
    
    if(searchBarProduct == nil){
    
        // Uncomment the following line to preserve selection between presentations.
        //self.clearsSelectionOnViewWillAppear = NO;
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self loadAttribsToComponents:NO];
        [self.navigationController setNavigationBarHidden:NO];
        
        //set searchBar settings
        searchBarProduct = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
        
        //define searchbar theme
        for(int i =0; i<[searchBarProduct.subviews count]; i++) {
            
            //textfield
            if([[searchBarProduct.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]){
                [(UITextField*)[searchBarProduct.subviews objectAtIndex:i] setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
            }
            
            //button
            if([[searchBarProduct.subviews objectAtIndex:i] isKindOfClass:[UIButton class]]){
                UIButton * btn = (UIButton *)[searchBarProduct.subviews objectAtIndex:i];
                [btn.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14]];
            }
        }
        
        searchBarProduct.delegate = self;
        [searchBarProduct setPlaceholder:NSLocalizedString(@"searchProduct", @"")];
        [GlobalFunctions setSearchBarLayout:searchBarProduct];
        [searchBarProduct setHidden:YES];
        [self.navigationController.navigationBar addSubview:searchBarProduct];
        
        shadowSearch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
        [shadowSearch setBackgroundColor:[UIColor blackColor]];
        [shadowSearch setAlpha:0.7];
        [shadowSearch setHidden:YES];
        [self.view addSubview:shadowSearch];
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearch:)];
        [gest setNumberOfTouchesRequired:1];
        [shadowSearch addGestureRecognizer:gest];
        
        //Initializing the Object Managers
        RKObjManeger = [RKObjectManager sharedManager];
        [self getResourcePathProduct];
    }
}

- (void)loadAttribsToComponents:(BOOL)isFromLoadObject{
    if (!isFromLoadObject) {
    
    self.tableView.delegate = self;
    
    [self.navigationController.navigationBar setTintColor:[GlobalFunctions getColorRedNavComponets]];
    [self.navigationItem setTitle:NSLocalizedString(@"products", @"")];
    
    [self.navigationItem setLeftBarButtonItem:[GlobalFunctions getIconNavigationBar:
                                               @selector(backPage) viewContr:self imageNamed:@"btBackNav.png" rect:CGRectMake(0, 0, 40, 30)]];
    
    [self.navigationItem setRightBarButtonItem:[GlobalFunctions getIconNavigationBar:@selector(showSearch:) viewContr:self imageNamed:@"btSearch.png" rect:CGRectMake(0, 0, 38, 31)]];
    
    NSArray *objects = [NSArray arrayWithObjects:[UIImage imageNamed:@"btSearchBlock"], [UIImage imageNamed:@"btProdList"], nil];
    
	segmentControl = [[STSegmentedControl alloc] initWithItems:objects];
	segmentControl.frame = CGRectMake(0, 0, 92, 31);
	[segmentControl addTarget:self action:@selector(changeSegControl:) forControlEvents:UIControlEventValueChanged];
	segmentControl.selectedSegmentIndex = 0;
	segmentControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[viewSegmentArea addSubview:segmentControl];

    [self.tableView setRowHeight:377];
    
    } else {
         if ([strTextSearch length] != 0)
            [searchBarProduct setText:strTextSearch];
         
        NSString *text = [NSString stringWithFormat:NSLocalizedString(@"search-result", nil), [mutArrayProducts count], strTextSearch];
        NSString *count = [NSString stringWithFormat:@"%i", [mutArrayProducts count]];
        
        [self.tableView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.f]];
        
        NSMutableAttributedString  *attrStr         = [NSMutableAttributedString attributedStringWithString:text];
        [attrStr setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:15] range:[text rangeOfString:NSLocalizedString(@"results-for", nil)]];
        [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
        [attrStr setTextColor:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                        range:[text rangeOfString:count]];
        [attrStr setTextColor:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                        range:[text rangeOfString:[NSString stringWithFormat:@"\"%@\"", strTextSearch]]];
        
        OHlabelTitleResults.attributedText = attrStr;
        
        //logic block to load avatares search.
        mutArrayViewHelpers = [[NSMutableArray alloc] initWithCapacity:[mutArrayProducts count]];
        for (int i = 0; i < [mutArrayProducts count]; i++) {
            NSString *avatarName = [NSString stringWithFormat:@"%@_AvatarImg",
                                    [[mutArrayProducts objectAtIndex:i] idPessoa]];
            if ([[GlobalFunctions getUserDefaults] objectForKey:avatarName] == nil){
                NSString *garageName = [[mutArrayProducts objectAtIndex:i] idPessoa];
                viewHelper *vH = [[viewHelper alloc] init];
                vH.avatarName = avatarName;
                [vH getResourcePathGarage:garageName];
                [mutArrayViewHelpers addObject:vH];
            }
        }
        
        [segmentControl setEnabled:YES];
        [tableView setScrollEnabled:YES];
    }
    self.trackedViewName = [NSString stringWithFormat: @"/search%@", strLocalResourcePath];
}


- (void)getResourcePathProduct{
    RKObjectMapping *productMapping = [Mappings getProductMapping];
    RKObjectMapping *photoMapping = [Mappings getPhotoMapping];
    RKObjectMapping *caminhoMapping = [Mappings getCaminhoMapping];
    [segmentControl setEnabled:NO];
    [tableView setScrollEnabled:NO];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //set Local Resource Defautl
    if ([strLocalResourcePath length] == 0)
        strLocalResourcePath = @"/product";
    
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    
    //Relationship
    [photoMapping mapKeyPath:@"caminho" toRelationship:@"caminho" withMapping:caminhoMapping serialize:NO];
    
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:strLocalResourcePath objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    //set Array objects Products
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if([objects count] > 0){
        mutArrayProducts = (NSMutableArray *)objects;
        
        [self awakeFromNib];
        
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"search-not-found", nil)
                              message: NSLocalizedString(@"search-not-found-info", nil)
                              delegate: nil
                              cancelButtonTitle:NSLocalizedString(@"search-not-found-ok", nil)
                              otherButtonTitles:nil];
        [alert show];
    }
    [self loadAttribsToComponents:YES];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showSearch:(id)sender{
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
}

// Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrayProducts count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // static NSString             *CellIdentifier = @"CellProduct";
    //productCustomViewCell       *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //create new cell
    searchCustomViewCell *customViewCellBlock = [self.tableView dequeueReusableCellWithIdentifier:@"customViewCellBlock"];
    searchCustomViewCell *customViewCellLine = [self.tableView dequeueReusableCellWithIdentifier:@"customViewCellLine"];

    
    if ([mutArrayProducts count] > 0) {
    
        //display image path
       // cell.productName.text = [[[imageURLs objectAtIndex:indexPath.row] path] lastPathComponent];

        NSString *garageName = [[mutArrayProducts objectAtIndex:indexPath.row] idPessoa ];
        
        //Attibuted at strFormat values : Currency, Valor Esperado.
        NSString                   *currency        = [GlobalFunctions getCurrencyByCode:(NSString *)
                                                       [[mutArrayProducts objectAtIndex:indexPath.row] currency]];
        NSString                   *valorEsperado   = [[mutArrayProducts objectAtIndex:indexPath.row] valorEsperado ];
        
        NSString *valorEsperadoFormat;
        if (segmentControl.selectedSegmentIndex != 0)
            valorEsperadoFormat = NSLocalizedString(@"format-expected-value-2line", nil); //break line.
        else valorEsperadoFormat = NSLocalizedString(@"format-expected-value-1line", nil); 
        
        NSString                   *strFormat       = [NSString stringWithFormat: valorEsperadoFormat, currency, valorEsperado,
                                                       [[mutArrayProducts objectAtIndex:indexPath.row] idPessoa ]];
        
        //Set Default Size/Color
        NSMutableAttributedString  *attrStr         = [NSMutableAttributedString attributedStringWithString:strFormat];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:15]];
        [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
        
        //Set Valor Esperado Size/Color
        [attrStr setTextColor:[UIColor colorWithRed:91.0/255.0 green:148.0/255.0 blue:67.0/255.0 alpha:1.f]
                        range:[strFormat rangeOfString:valorEsperado]];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:22] range:[strFormat rangeOfString:valorEsperado]];
        
        //Set GarageName Size/Color
        [attrStr setTextColor:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]  
                        range:[strFormat rangeOfString:garageName]];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:13] range:[strFormat rangeOfString:
                                                                            [NSString stringWithFormat:NSLocalizedString(@"format-expected-value-by", nil), garageName]]];
            
        int state = [[[self.mutArrayProducts objectAtIndex:indexPath.row] idEstado] intValue];
        
        if (state > 1) {
            [[customViewCellBlock valorEsperado] setFont:[UIFont fontWithName:@"Droid Sans" size:20 ]];
            [[customViewCellBlock valorEsperado] setTextColor:[UIColor colorWithRed:(float)255/255.0 \
                                                               green:(float)102/255.0 \
                                                                blue:(float)102/255.0 alpha:1.0]];
            
            [[customViewCellLine valorEsperado] setFont:[UIFont fontWithName:@"Droid Sans" size:20 ]];
            [[customViewCellLine valorEsperado] setTextColor:[UIColor colorWithRed:(float)255/255.0 \
                                                                              green:(float)102/255.0 \
                                                                               blue:(float)102/255.0 alpha:1.0]];
        }
        switch (state) {
            case 2:
                [[customViewCellBlock valorEsperado] setText:@"Vendido"];
                [[customViewCellLine valorEsperado] setText:@"Vendido"];
                break;
            case 3:
                [[customViewCellBlock valorEsperado] setText:@"N/D"];
                [[customViewCellLine valorEsperado] setText:@"N/D"];
                break;
            case 4:
                [[customViewCellBlock valorEsperado] setText:@"Invisible"];
                [[customViewCellLine valorEsperado] setText:@"Invisible"];
                break;
            default:
                customViewCellBlock.valorEsperado.attributedText = attrStr;
                customViewCellLine.valorEsperado.attributedText = attrStr;
                break;
        }

        UIImage *image = (UIImage*)[NSKeyedUnarchiver unarchiveObjectWithData:[[GlobalFunctions getUserDefaults]
                                                                                   objectForKey:[NSString stringWithFormat:@"%@_AvatarImg", [[mutArrayProducts objectAtIndex:indexPath.row] idPessoa]]]];
        customViewCellBlock.imageGravatar.image = image;
        customViewCellBlock.imageGravatar.tag = indexPath.row;

        UITapGestureRecognizer *gestGrav = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoGarageDetailVC:)];
        [gestGrav setNumberOfTouchesRequired:1];
        
        [customViewCellBlock.imageGravatar addGestureRecognizer:gestGrav];
        
        //Set CellBlock Values
        [[customViewCellBlock productName] setText:(NSString *)[[mutArrayProducts objectAtIndex:indexPath.row] nome]];
        [[customViewCellBlock productName] setFont:[UIFont fontWithName:@"Droid Sans" size:15]];    
        
        //Set Gravatar at CellBlock.
        //NSData  *imageData  = [NSData dataWithContentsOfURL:[GlobalFunctions getGravatarURL:[[mutArrayProducts objectAtIndex:indexPath.row] email]]];
        //UIImage *image      = [[UIImage alloc] initWithData:imageData];
        
        //Set CellLine Values
        [[customViewCellLine productName] setText:(NSString *)[[mutArrayProducts objectAtIndex:indexPath.row] nome]];
        [[customViewCellLine productName] setFont:[UIFont fontWithName:@"Droid Sans" size:15]];
    }
    
    if(segmentControl.selectedSegmentIndex == 0){
        
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:customViewCellBlock.imageView];
        
        //set placeholder image or cell won't update when image is loaded
        customViewCellBlock.imageView.image = [UIImage imageNamed:@"placeHolder.png"];
        //load the image
        customViewCellBlock.imageView.imageURL = [imageURLs objectAtIndex:indexPath.row];
        
        customViewCellBlock.imageView.layer.masksToBounds = YES;
        customViewCellBlock.imageView.layer.cornerRadius = 3;
        
        //[customViewCellLine removeFromSuperview];
        [customViewCellBlock setHidden:NO];
        [customViewCellLine setHidden:YES];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setRowHeight:122];
        return customViewCellBlock;
    }
    else{
        
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:customViewCellLine.imageView];

        
        //set placeholder image or cell won't update when image is loaded
        customViewCellLine.imageView.image = [UIImage imageNamed:@"placeHolder.png"];
        //load the image
        customViewCellLine.imageView.imageURL = [imageURLs objectAtIndex:indexPath.row];
        
        customViewCellLine.imageView.layer.masksToBounds = YES;
        
        customViewCellLine.imageView.layer.cornerRadius = 3;
        
      //  [customViewCellBlock removeFromSuperview];
        [customViewCellBlock setHidden:YES];
        [customViewCellLine setHidden:NO];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.tableView setRowHeight:367];
        return customViewCellLine;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    productDetailViewController *prdDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailProduct"];
    [prdDetailVC setProduct:(Product *)[mutArrayProducts objectAtIndex:indexPath.row]];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[[(searchCustomViewCell *)[tableView cellForRowAtIndexPath:indexPath] imageView] image]];
    
    [prdDetailVC setImageView:imageV];
    [self.navigationController pushViewController:prdDetailVC animated:YES];
}


- (void)gotoGarageDetailVC:(UITapGestureRecognizer *)sender{
    garageAccountViewController *garaAcc = [self.storyboard instantiateViewControllerWithIdentifier:@"garageAccount"];
//    [garaAcc setProfile:(Profile *)[mutArrayProducts objectAtIndex:0]];
//    [garaAcc setGarage:(Garage *)[arrayGarage objectAtIndex:0]];
    
    NSString *garageName = [[mutArrayProducts objectAtIndex:sender.view.tag] idPessoa];
    UIImageView *imgV = (UIImageView *)sender.view;
    garaAcc.garageNameSearch = garageName;
    [garaAcc setImageGravatar:imgV.image];
    garaAcc.isGenericGarage = YES;
    [self.navigationController pushViewController:garaAcc animated:YES];
    
    
//    garageAccountViewController *garaAcc = [self.storyboard instantiateViewControllerWithIdentifier:@"garageAccount"];
//    [garaAcc setProfile:(Profile *)[arrayProfile objectAtIndex:0]];
//    [garaAcc setGarage:(Garage *)[arrayGarage objectAtIndex:0]];
//    [garaAcc setImageGravatar:buttonGarageDetail.imageView.image];
//    [self.navigationController pushViewController:garaAcc animated:YES];
    
}


// Settings to SearchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // searchBarTextDidBeginEditing is called whenever
    // focus is given to the UISearchBar
    // call our activate method so that we can do some
    // additional things when the UISearchBar shows.
    [searchBarProduct setShowsCancelButton:YES animated:YES];
    [self searchBar:searchBar activate:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the
    // UISearchBar loses focus
    // We don't need to do anything here.
    [searchBarProduct setShowsCancelButton:NO animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Clear the search text
    // Deactivate the UISearchBar
    [self showSearch:nil];
    // searchBar.text=@"";
    //[self searchBar:searchBar activate:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // Do the search and show the results in tableview
    // Deactivate the UISearchBar
    strTextSearch = searchBar.text;
    //Search Service

    [self removeClientRequest];
    
    strLocalResourcePath = [NSString stringWithFormat:@"/search?q=%@", [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];

    [mutArrayProducts removeAllObjects];
    [mutArrayViewHelpers removeAllObjects];
    self.trackedViewName = [NSString stringWithFormat: @"/search/%@", [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    [self showSearch:nil];
    
    [segmentControl setSelectedSegmentIndex:0];
    [self.tableView setRowHeight:377];
    [self getResourcePathProduct];
    [self searchBar:searchBar activate:NO];
    [searchBarProduct resignFirstResponder];
}


// We call this when we want to activate/deactivate the UISearchBar
// Depending on active (YES/NO) we disable/enable selection and
// scrolling on the UITableView
// Show/Hide the UISearchBar Cancel button
// Fade the screen In/Out with the disableViewOverlay and
// simple Animations
-(void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active {
//    self.tableView.allowsSelection = !active;
    //    self.tableView.scrollEnabled = !active;
    if (!active) {
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
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        if (selected) {
            [self.tableView deselectRowAtIndexPath:selected animated:NO];
        }
    }
    [searchBar setShowsCancelButton:active animated:YES];
}

-(void)changeSegControl:(id)sender{
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
    [self.tableView reloadInputViews];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{    
    if ((segmentControl.selectedSegmentIndex == 0 && [mutArrayProducts count] > 1) ||
        (segmentControl.selectedSegmentIndex == 1 && [mutArrayProducts count] > 4)) {

        if (_lastContentOffset < (int)self.tableView.contentOffset.y){
            [GlobalFunctions hideTabBar:self.navigationController.tabBarController animated:YES];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        else{
            if (tableView.contentOffset.y < tableView.contentSize.height-700) {
              [GlobalFunctions showTabBar:self.navigationController.tabBarController];
              [self.navigationController setNavigationBarHidden:NO animated:YES];
            }
        }
    }
    isSearchDisplayed = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self showSearch:nil];
	return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeClientRequest];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [GlobalFunctions showTabBar:self.navigationController.tabBarController];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)removeClientRequest{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
    for (int i = 0; i < [mutArrayViewHelpers count]; i++) {
        [(viewHelper *)[mutArrayViewHelpers objectAtIndex:i] cancelRequestsWithDelegate];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    mutArrayProducts = nil;
    [self setMutArrayProducts:nil];
    mutArrayViewHelpers = nil;
    [self setMutArrayViewHelpers:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
