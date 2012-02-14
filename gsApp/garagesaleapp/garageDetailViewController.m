//
//  garageDetailViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 09/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "garageDetailViewController.h"
#import "productTableViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Category.h"

@implementation garageDetailViewController

@synthesize manager;
@synthesize garage;
@synthesize profile;
@synthesize tags;
@synthesize gravatarUrl;
@synthesize emailLabel;
@synthesize imageView;
@synthesize garageName;
@synthesize description;
@synthesize city;
@synthesize link;
@synthesize scrollView;
@synthesize tagsScrollView;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)loadAttributesSettings{
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    manager = [RKObjectManager objectManagerWithBaseURL:@"http://api.garagesaleapp.in"];
    [self loadAttributesSettings];
}

- (void)setupCategoryMapping {
    //Configure Object Mapping Category
    RKObjectMapping *categoryMapping = [RKObjectMapping mappingForClass:[Category class]];
    [categoryMapping mapKeyPath:@"id"           toAttribute:@"identifier"];
    [categoryMapping mapKeyPath:@"descricao"    toAttribute:@"descricao"];
    [categoryMapping mapKeyPath:@"idPessoa"     toAttribute:@"idPessoa"];
    //set path
    [manager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/category/%@", [[self.profile objectAtIndex:0] garagem]] objectMapping:categoryMapping delegate:self];
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];  
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if([objects count] > 0){
        self.tags = objects;
        [self drawTagsButton];
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

-(void)drawTagsButton{
    //define x,y position
    //sumY draw y positio
    int sumY = 0;
    int sumX = 0;
    int y = 0;
    int x;
    for(int i=0;i<[self.tags count];i++){
        //initial position x
        x = 20;
        
        Category *category = [self.tags objectAtIndex:i];
        //get size of button string
        CGSize stringSize = [[category.descricao lowercaseString] sizeWithFont:[UIFont systemFontOfSize:14]]; 
        
        //set new position x
        if (sumX != 0)
            x = sumX;
        
        //draw Buttom
        UIButton *tagsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tagsButton.frame = CGRectMake(x, y, /* 135 */  stringSize.width+20 , 35);
        [tagsButton setTintColor:[UIColor greenColor]];
        [tagsButton setTag:(NSInteger)category.identifier];
        [tagsButton setTitle:[category.descricao lowercaseString] forState:UIControlStateNormal];
        tagsButton.layer.masksToBounds = YES;
        tagsButton.layer.cornerRadius = 5.0f;
        tagsButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.466666666666667 blue:0 alpha:0.7];
        tagsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [tagsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tagsButton setTitleColor:[UIColor blackColor] forState:UIControlEventTouchDown];
        [tagsButton addTarget:self action:@selector(gotoProductTableVC:) forControlEvents:UIControlEventTouchUpInside];
        
        //check if self.tags have index out of bounds
        if ([self.tags count] > i+1)
            category = [self.tags objectAtIndex:i+1];
        
        //get size of next button string
        CGSize NextStringSize = [[category.descricao lowercaseString] sizeWithFont:[UIFont systemFontOfSize:14]]; 
        
        //check and set all new values control
        if ((sumX+20)+NextStringSize.width>200) {
            sumY++;
            y = sumY*40;
            sumX=0;
        } else if (sumX == 0)
            sumX = stringSize.width + sumX + 45;
        else
            sumX = stringSize.width + sumX + 25;
        
        [self.tagsScrollView addSubview:tagsButton];
    }
    self.tagsScrollView.contentSize	= CGSizeMake(300,y+40);
}

- (IBAction)gotoUserProductTableVC{
    productTableViewController *prdTabVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    prdTabVC.localResourcePath = [NSString stringWithFormat:@"/product/%@", [[self.profile objectAtIndex:0] garagem]];
    [self.navigationController pushViewController:prdTabVC animated:YES];
}

- (void)gotoCategoryProductTableVC:(id)sender{
    UIButton *button = (UIButton *)sender; 
    productTableViewController *prdTabVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    prdTabVC.localResourcePath = [NSString stringWithFormat:@"/product/?category=%@", button.currentTitle];
    [self.navigationController pushViewController:prdTabVC animated:YES];
}

- (void)gotoProductTableVC:(UIButton *)sender{
    productTableViewController *prdTbl = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductsTable"];
    //filter by Category
    prdTbl.localResourcePath = [NSString stringWithFormat:@"/product?category=%@", [[sender titleLabel] text] ];
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
    tagsScrollView = nil;
    [self setTagsScrollView:nil];
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
