//
//  garageDetailViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 09/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "garageDetailViewController.h"

@implementation garageDetailViewController

@synthesize RKObjManeger;
@synthesize garage;
@synthesize profile;
@synthesize arrayTags;
@synthesize gravatarUrl;
@synthesize emailLabel;
@synthesize imageView;
@synthesize garageName;
@synthesize description;
@synthesize city;
@synthesize link;
@synthesize scrollView;
@synthesize seeAllButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    [self loadAttribsToComponents];
}

- (void)setupCategoryMapping {
    //Configure Object Mapping Category
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[Category class]];
    [categoryMapping mapKeyPath:@"id"           toAttribute:@"identifier"];
    [categoryMapping mapKeyPath:@"descricao"    toAttribute:@"descricao"];
    [categoryMapping mapKeyPath:@"idPessoa"     toAttribute:@"idPessoa"];
    //set path
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/category/%@", [[self.profile objectAtIndex:0] garagem]] objectMapping:categoryMapping delegate:self];
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];  
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if([objects count] > 0){
        self.arrayTags = objects;
        [GlobalFunctions drawTagsButton:self.arrayTags scrollView:self.scrollView viewController:self];
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

-(void)loadAttribsToComponents{
    self.scrollView.contentSize     = CGSizeMake(320,630);
    self.description.text           = [[self.garage objectAtIndex:0] about];
    self.garageName.text            = [[self.profile objectAtIndex:0] nome];
    self.city.text                  = [NSString stringWithFormat:@"%@, %@, %@", 
                                       [[self.garage objectAtIndex:0] city],
                                       [[self.garage objectAtIndex:0] district],
                                       [[self.garage objectAtIndex:0] country]];
    self.link.text                  = [[self.garage objectAtIndex:0] link];
    self.navigationItem.title       = NSLocalizedString(@"garage", @"");
    
    self.imageView.image            = [UIImage imageWithData: [NSData dataWithContentsOfURL:self.gravatarUrl]];
    seeAllButton.layer.cornerRadius = 5.0f;
    
    [seeAllButton setTitle: NSLocalizedString(@"seeAllProducts", @"") forState:UIControlStateNormal];
    self.navigationItem.hidesBackButton = NO;
    [self setupCategoryMapping];
}

- (IBAction)gotoUserProductTableVC{
    productTableViewController *prdTabVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    prdTabVC.strLocalResourcePath = [NSString stringWithFormat:@"/product/%@", [[self.profile objectAtIndex:0] garagem]];
    [self.navigationController pushViewController:prdTabVC animated:YES];
}

- (void)gotoCategoryProductTableVC:(id)sender{
    UIButton *button = (UIButton *)sender; 
    productTableViewController *prdTabVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    prdTabVC.strLocalResourcePath = [NSString stringWithFormat:@"/product/?category=%@", button.currentTitle];
    [self.navigationController pushViewController:prdTabVC animated:YES];
}

- (void)gotoProductTableVC:(UIButton *)sender{
    productTableViewController *prdTbl = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    //filter by Category
    prdTbl.strLocalResourcePath = [NSString stringWithFormat:@"/product?category=%@", [[sender titleLabel] text] ];
    [self.navigationController pushViewController:prdTbl animated:YES];
}

- (void)viewDidUnload
{
    emailLabel = nil;
    imageView = nil;
    garageName = nil;
    description = nil;
    city = nil;
    link = nil;
    [self setEmailLabel:nil];
    [self setImageView:nil];
    [self setGarageName:nil];
    [self setDescription:nil];
    [self setCity:nil];
    [self setLink:nil];
    scrollView = nil;
    [self setScrollView:nil];
    seeAllButton = nil;
    [self setSeeAllButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
