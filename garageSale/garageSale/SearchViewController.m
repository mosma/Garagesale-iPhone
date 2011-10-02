#import "SearchViewController.h"

@implementation SearchViewController

@synthesize listaSearchItems;
@synthesize searchBar;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *topBarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-garagesale.png"]];
    [self.navigationController.navigationBar insertSubview:topBarImage atIndex:0];
    [topBarImage release];
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,40)];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    self.listaSearchItems = [[NSArray alloc] initWithObjects:@"Pulse", @"Dark Side Of the Moon", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listaSearchItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    if (indexPath.row==0) {
        UIImage* image = [UIImage imageNamed:@"pulse.jpg"];
        cell.imageView.image = image;        
    }
    if (indexPath.row==1) {
        UIImage* image = [UIImage imageNamed:@"darkside"];
        cell.imageView.image = image;        
    }
    cell.textLabel.text = [listaSearchItems objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*http//blog.webscale.co.in/?p=228*/
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
   [self.searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
}

-(void)dealloc {
    [searchBar release], searchBar = nil;
    [super dealloc];    
}
@end
