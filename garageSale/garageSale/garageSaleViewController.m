#import "garageSaleViewController.h"
#import "MyGarageViewController.h"

@implementation garageSaleViewController

@synthesize listaSecoes;
@synthesize customTableView;

-(IBAction) openCategoriesSection {
    MyGarageViewController* myGarage = [[MyGarageViewController alloc] init];
    [self.navigationController pushViewController:myGarage animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *array = [[NSArray alloc] initWithObjects:
					  @"CDs", 
                      @"DVDs", 
                      @"Eletronicos", 
                      @"Jogos Eletronicos",
                      @"Livros", 
                      @"Moveis",
                      nil];
	
	self.listaSecoes = array;
    
    [array release];
    
    UIImageView *topBarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-garagesale.png"]];
    [self.navigationController.navigationBar insertSubview:topBarImage atIndex:0];
    [topBarImage release];

//    self.customTableView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"background.jpg"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listaSecoes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.row==0) {
        UIImage* image = [UIImage imageNamed:@"cds"];
        cell.imageView.image = image;        
    }
    if (indexPath.row==1) {
        UIImage* image = [UIImage imageNamed:@"dvds"];
        cell.imageView.image = image;        
    }
    if (indexPath.row==2) {
        UIImage* image = [UIImage imageNamed:@"eletronicos"];
        cell.imageView.image = image;        
    }
    if (indexPath.row==3) {
        UIImage* image = [UIImage imageNamed:@"jogos"];
        cell.imageView.image = image;        
    }
    if (indexPath.row==4) {
        UIImage* image = [UIImage imageNamed:@"livros"];
        cell.imageView.image = image;
    }
    if (indexPath.row==5) {
        UIImage* image = [UIImage imageNamed:@"moveis"];
        cell.imageView.image = image;
    }
    
   
	cell.textLabel.text = [listaSecoes objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSString *rowValue = [listaSecoes objectAtIndex:row];
    
    NSLog(@">>>> %@ ", rowValue);
}

@end

