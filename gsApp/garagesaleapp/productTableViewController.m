//
//  productTableViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 07/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "productTableViewController.h"
#import "NSAttributedString+Attributes.h"
#import "AsyncImageView.h"

@interface productTableViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation productTableViewController

@synthesize mutArrayProducts;
@synthesize RKObjManeger;
@synthesize searchBarProduct;
@synthesize strLocalResourcePath;
@synthesize strTextSearch;
@synthesize OHlabelTitleResults;
@synthesize segmentControl;
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
                    urlThumb = @"http://s3-sa-east-1.amazonaws.com/garagesale-static-content/images/nopicture.png";
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
                NSLog(@"xxx : %i",x);
            }
            self.imageURLs = URLs;
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            ;
        }
        [self changeSegControl];
    }
    [super awakeFromNib];
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

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
    //Initializing the Object Managers
    RKObjManeger = [RKObjectManager sharedManager];
    [self getResourcePathProduct];
}

- (void)loadAttribsToComponents:(BOOL)isFromLoadObject{
   
        //set searchBar settings
        searchBarProduct = [[UISearchBar alloc]initWithFrame:CGRectMake(0,-200,320,40)];
        searchBarProduct.delegate = self;
        [searchBarProduct setPlaceholder:NSLocalizedString(@"searchProduct", @"")];
        
        self.tableView.delegate = self;
        [GlobalFunctions setSearchBarLayout:searchBarProduct];
        
        [self.navigationController.navigationBar setTintColor:[GlobalFunctions getColorRedNavComponets]];
        
        [self.navigationItem setTitle:NSLocalizedString(@"products", @"")];
        [self.tableView addSubview:searchBarProduct];

        [self.navigationItem setLeftBarButtonItem:[GlobalFunctions getIconNavigationBar:
                                                   @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"]];
 
        [self.navigationItem setRightBarButtonItem:[GlobalFunctions getIconNavigationBar:
                                                    @selector(showSearch:) viewContr:self imageNamed:@"btSearchAccount.png"]];
        [segmentControl setSelectedSegmentIndex:0];
        [self.tableView setRowHeight:377];
    
        self.trackedViewName = [NSString stringWithFormat: @"/search/%@", strLocalResourcePath];

     if (isFromLoadObject) {
            
        if ([strTextSearch length] != 0)
            [searchBarProduct setText:strTextSearch];

        NSString *text = [NSString stringWithFormat:@"%i results for \"%@\"", [mutArrayProducts count], strTextSearch];
        NSString *count = [NSString stringWithFormat:@"%i", [mutArrayProducts count]];
        
        [self.tableView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.f]];
        
        NSMutableAttributedString  *attrStr         = [NSMutableAttributedString attributedStringWithString:text];
        [attrStr setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
        [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:15] range:[text rangeOfString:@"results for"]];
        [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.f]];
        [attrStr setTextColor:[UIColor redColor] range:[text rangeOfString:count]];
        [attrStr setTextColor:[UIColor redColor] range:[text rangeOfString:[NSString stringWithFormat:@"\"%@\"", strTextSearch]]];
        
        OHlabelTitleResults.attributedText = attrStr;
    }
}

- (void)getResourcePathProduct{
    RKObjectMapping *productMapping = [Mappings getProductMapping];
    RKObjectMapping *photoMapping = [Mappings getPhotoMapping];
    RKObjectMapping *caminhoMapping = [Mappings getCaminhoMapping];
    
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
    if([objects count] > 0){
        mutArrayProducts = (NSMutableArray *)objects;
        
        [self awakeFromNib];
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

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showSearch:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromTop];
    
    if (!isSearch) {
        [searchBarProduct setTransform:CGAffineTransformMakeTranslation(0, self.tableView.contentOffset.y+200)];
        [searchBarProduct becomeFirstResponder];
    }
    else {
        [searchBarProduct setTransform:CGAffineTransformMakeTranslation(0, -(self.tableView.contentOffset.y+200))];
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
//    [self getResourcePathProduct];
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


    //create new cell
    productCustomViewCell *customViewCellBlock = [tableView dequeueReusableCellWithIdentifier:@"customViewCellBlock"];
    productCustomViewCell *customViewCellLine = [tableView dequeueReusableCellWithIdentifier:@"customViewCellLine"];

        //common settings
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
      //  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
      //  cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
       // cell.imageView.frame = CGRectMake(0.0f, 0.0f, 250, 250);
       // cell.imageView.clipsToBounds = YES;
        

    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:customViewCellBlock.imageView];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:customViewCellLine.imageView];
    
    //set placeholder image or cell won't update when image is loaded
    
    
    customViewCellBlock.imageView.image = [UIImage imageNamed:@"placeholder2.png"];
    //load the image
    customViewCellBlock.imageView.imageURL = [imageURLs objectAtIndex:indexPath.row];
    
    //set placeholder image or cell won't update when image is loaded
    customViewCellLine.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
    //load the image
    customViewCellLine.imageView.imageURL = [imageURLs objectAtIndex:indexPath.row];
    
    customViewCellBlock.imageView.layer.masksToBounds = YES;
    customViewCellLine.imageView.layer.masksToBounds = YES;

    customViewCellBlock.imageView.layer.cornerRadius = 3;
    customViewCellLine.imageView.layer.cornerRadius = 3;

    //display image path
   // cell.productName.text = [[[imageURLs objectAtIndex:indexPath.row] path] lastPathComponent];

    NSString *garageName = [[mutArrayProducts objectAtIndex:indexPath.row] idPessoa ];
    
    //Attibuted at strFormat values : Currency, Valor Esperado.
    NSString                   *currency        = [GlobalFunctions getCurrencyByCode:(NSString *)
                                                   [[mutArrayProducts objectAtIndex:indexPath.row] currency]];
    NSString                   *valorEsperado   = [[mutArrayProducts objectAtIndex:indexPath.row] valorEsperado ];
    NSString                   *strFormat       = [NSString stringWithFormat:@"%@%@ by %@", currency, valorEsperado, 
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
    [attrStr setTextColor:[UIColor redColor]  
                    range:[strFormat rangeOfString:garageName]];
    [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:13] range:[strFormat rangeOfString:
                                                                        [NSString stringWithFormat:@"by %@", garageName]]];
    
    //Check Flag idEstado (1 - Não Vendido, 2 - Vendido)
    if ([[[mutArrayProducts objectAtIndex:indexPath.row] idEstado] intValue] == 2){
        [[customViewCellBlock valorEsperado]       setFont:[UIFont fontWithName:@"Droid Sans" size:20 ]];
        [[customViewCellBlock valorEsperado] setText:@"Vendido"];
        [[customViewCellBlock valorEsperado] setTextColor:[UIColor colorWithRed:(float)255/255.0 \
                                                           green:(float)102/255.0 \
                                                            blue:(float)102/255.0 alpha:1.0]];
        
        [customViewCellLine setValorEsperado:customViewCellBlock.valorEsperado];
        
    }else{
        [customViewCellBlock.valorEsperado setAttributedText:attrStr];
        [customViewCellLine.valorEsperado setAttributedText:attrStr];
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
    
        
        if(segmentControl.selectedSegmentIndex == 0){
            [customViewCellLine removeFromSuperview];
            [customViewCellBlock setHidden:NO];
            [customViewCellLine setHidden:YES];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.tableView setRowHeight:122];
            return customViewCellBlock;
        }
        else{
            // [tableView deleteRowsAtIndexPaths:[self.mutArrayProducts objectAtIndex:indexPath.row] withRowAnimation:UITableViewRowAnimationNone];
            [customViewCellBlock removeFromSuperview];
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
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[[(productCustomViewCell *)[tableView cellForRowAtIndexPath:indexPath] imageView] image]];
    
    [prdDetailVC setImageView:imageV];
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
    [searchBarProduct setShowsCancelButton:YES animated:YES];
    [self searchBar:searchBar activate:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the 
    // UISearchBar loses focus
    // We don't need to do anything here.
    [searchBarProduct setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Clear the search text
    // Deactivate the UISearchBar
    [searchBarProduct resignFirstResponder];
    // searchBar.text=@"";
    //[self searchBar:searchBar activate:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // Do the search and show the results in tableview
    // Deactivate the UISearchBar
    
    strTextSearch = searchBar.text;
    
    //Search Service
    strLocalResourcePath = [NSString stringWithFormat:@"/search?q=%@", searchBar.text];
    [mutArrayProducts removeAllObjects];

    self.trackedViewName = [NSString stringWithFormat: @"/search/%@", searchBar.text];

    [segmentControl setSelectedSegmentIndex:0];
    [self.tableView setRowHeight:377];
    
    [self getResourcePathProduct];
    
    [self searchBar:searchBar activate:NO];
    [self showSearch:nil];
    [searchBarProduct resignFirstResponder];
   // [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];

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
        [sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
        sheet.delegate = self;
        [sheet showInView:self.view];
        [sheet showFromTabBar:self.tabBarController.tabBar];
        return NO;
    } else {
        return YES;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (isSearch)
        [self showSearch:nil];
    [searchBarProduct resignFirstResponder];
    
    if (_lastContentOffset < (int)self.tableView.contentOffset.y) {
        [GlobalFunctions hideTabBar:self.navigationController.tabBarController];
        
    }else{
        [GlobalFunctions showTabBar:self.navigationController.tabBarController];
    }
    
    //[self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //[self.navigationItem.rightBarButtonItem setEnabled:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [GlobalFunctions setActionSheetAddProduct:self.tabBarController clickedButtonAtIndex:buttonIndex];
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

- (void)viewDidUnload
{

    mutArrayProducts = nil;
    [self setMutArrayProducts:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
