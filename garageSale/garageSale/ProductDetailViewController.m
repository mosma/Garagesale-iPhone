//
//  ProductDetailViewController.m
//  garageSale
//
//  Created by Tarek Abdala on 23/09/11.
//  Copyright 2011 UFSC - Universidade Federal Santa Catarina. All rights reserved.
//

#import "ProductDetailViewController.h"


@implementation ProductDetailViewController

@synthesize scrollFotos;
@synthesize viewDetail;
@synthesize viewOffers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    scrollFotos.contentSize = CGSizeMake(320,450);
    scrollFotos.frame = CGRectMake(0, 120, 320, 320);
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pushViewOffers:(id)sender{
    self.view = viewOffers;
}

- (IBAction)pushViewDetail:(id)sender{
    self.view = viewDetail;
}

@end
