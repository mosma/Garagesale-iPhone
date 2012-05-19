//
//  aboutViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 21/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "aboutViewController.h"

@implementation aboutViewController
@synthesize mosmaWebView;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    // Load URL
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:@"http://www.garagesaleapp.me/about"];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.mosmaWebView loadRequest:requestObj];
    
    self.mosmaWebView.scalesPageToFit = YES;
    
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    mosmaWebView = nil;
    [self setMosmaWebView:nil];
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
