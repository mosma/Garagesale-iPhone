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
@synthesize strLocalResourcePath;
@synthesize strTextSearch;
@synthesize OHlabelTitleResults;
@synthesize segmentControl;
@synthesize imageURLs;
@synthesize tableView;
@synthesize viewSearch;
@synthesize txtFieldSearch;

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
    self.tableView.delegate = self;
    [self.navigationController.navigationBar setTintColor:[GlobalFunctions getColorRedNavComponets]];
    [self.navigationItem setTitle:NSLocalizedString(@"products", @"")];
    [self.navigationItem setLeftBarButtonItem:[GlobalFunctions getIconNavigationBar:
                                               @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"]];

    [segmentControl setSelectedSegmentIndex:0];
    [self.tableView setRowHeight:377];

    self.trackedViewName = [NSString stringWithFormat: @"/search/%@", strLocalResourcePath];

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
    
     if (isFromLoadObject) {
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

    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:customViewCellBlock.imageView];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:customViewCellLine.imageView];
    
    //set placeholder image or cell won't update when image is loaded
    
    
    customViewCellBlock.imageView.image = [UIImage imageNamed:@"placeHolder.png"];
    //load the image
    customViewCellBlock.imageView.imageURL = [imageURLs objectAtIndex:indexPath.row];
    
    //set placeholder image or cell won't update when image is loaded
    customViewCellLine.imageView.image = [UIImage imageNamed:@"placeHolder.png"];
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
    
    
    NSString *valorEsperadoFormat;
    if (segmentControl.selectedSegmentIndex != 0)
        valorEsperadoFormat = @"%@%@ \r\nby %@"; //break line.
    else valorEsperadoFormat = @"%@%@ by %@"; 
    
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
    
    //Set Gravatar at CellBlock.
    //NSData  *imageData  = [NSData dataWithContentsOfURL:[GlobalFunctions getGravatarURL:[[mutArrayProducts objectAtIndex:indexPath.row] email]]];
    //UIImage *image      = [[UIImage alloc] initWithData:imageData];
    
    //Set CellLine Values
    [[customViewCellLine productName] setText:(NSString *)[[mutArrayProducts objectAtIndex:indexPath.row] nome]];
    [[customViewCellLine productName] setFont:[UIFont fontWithName:@"Droid Sans" size:15]];
        
    if(segmentControl.selectedSegmentIndex == 0){
        [customViewCellLine removeFromSuperview];
        [customViewCellBlock setHidden:NO];
        [customViewCellLine setHidden:YES];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setRowHeight:122];
        return customViewCellBlock;
    }
    else{
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    if (_lastContentOffset < (int)self.tableView.contentOffset.y) {
        [txtFieldSearch resignFirstResponder];
        [viewSearch setAlpha:0];

        if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil)
            [GlobalFunctions hideTabBar:self.navigationController.tabBarController];
    }else{

        [viewSearch setAlpha:1.0];

        
        [GlobalFunctions showTabBar:self.navigationController.tabBarController];
    }
    [UIView commitAnimations];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self showSearch:nil];
	return YES;
}

-(void)cancelSearchPad{
    [txtFieldSearch resignFirstResponder];
}

-(IBAction)showSearch:(id)sender{
    if ([txtFieldSearch isFirstResponder]){
        [txtFieldSearch resignFirstResponder];
        if (![txtFieldSearch.text isEqualToString:@""]){
            
            strTextSearch = txtFieldSearch.text;
            NSString *replaceSpace = [txtFieldSearch.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            
            //Search Service
            strLocalResourcePath = [NSString stringWithFormat:@"/search?q=%@", replaceSpace];
            [mutArrayProducts removeAllObjects];
            
            self.trackedViewName = [NSString stringWithFormat: @"/search%@", replaceSpace];
            
            [segmentControl setSelectedSegmentIndex:0];
            [self.tableView setRowHeight:377];
            
            [self getResourcePathProduct];
            
            //    [self showSearch:nil];
            [txtFieldSearch resignFirstResponder];
        }
    }
    else
        [txtFieldSearch becomeFirstResponder];
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
    [GlobalFunctions showTabBar:self.navigationController.tabBarController];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{

    mutArrayProducts = nil;
    [self setMutArrayProducts:nil];
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
