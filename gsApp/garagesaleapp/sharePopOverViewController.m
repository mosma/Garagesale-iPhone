//
//  sharePopOverViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 14/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "sharePopOverViewController.h"

@interface sharePopOverViewController ()

@end

@implementation sharePopOverViewController

@synthesize strUrlImg;
@synthesize description;
@synthesize imgProduct;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //configure addthis -- (this step is optional)
    //[AddThisSDK setNavigationBarColor:[GlobalFunctions getColorRedNavComponets]];
    [AddThisSDK setToolBarColor:[UIColor whiteColor]];
    [AddThisSDK setSearchBarColor:[UIColor lightGrayColor]];
    
    //Facebook connect settings
    //CHANGE THIS FACEBOOK API KEY TO YOUR OWN!!
    [AddThisSDK setFacebookAPIKey:@"280819525292258"];
    [AddThisSDK setFacebookAuthenticationMode:ATFacebookAuthenticationTypeFBConnect];
    
    [AddThisSDK shouldAutoRotate:NO];
    [AddThisSDK setInterfaceOrientation:UIInterfaceOrientationPortrait];
    
    [AddThisSDK setAddThisPubId:@"ra-4f9585050fbd99b4"];
    
    
    
//    addThisButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
//	[AddThisSDK canUserEditServiceMenu:YES];
//	[AddThisSDK canUserReOrderServiceMenu:YES];
//	[AddThisSDK setDelegate:self];
    
    //[AddThisSDK setAddThisApplicationId:@""];
    
    //        addThisButton = [AddThisSDK showAddThisButtonInView: self.navigationItem.rightBarButtonItem
    //                                                  withFrame:CGRectMake(225, 305, 36, 30)
    //                                                   forImage:imageView.image
    //                                                  withTitle:@"Product Send from Garagesaleapp.me"
    //                                                description:labelDescricao.text];
    
    
    
    
    
	// Do any additional setup after loading the view.
}

-(IBAction)twitter:(id)sender
{
    if (imgProduct == nil) 
            [AddThisSDK shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrlImg]]] withService:@"twitter" title:@"Product Send from Garagesaleapp.me" description:self.description];
    else
        [AddThisSDK shareImage:imgProduct withService:@"twitter" title:@"Product Send from Garagesaleapp.me" description:description];
}

-(IBAction)facebook:(id)sender
{
    if (imgProduct == nil)
        [AddThisSDK shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrlImg]]] withService:@"facebook" title:@"Product Send from Garagesaleapp.me" description:self.description];
    else
        [AddThisSDK shareImage:imgProduct withService:@"facebook" title:@"Product Send from Garagesaleapp.me" description:description];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
