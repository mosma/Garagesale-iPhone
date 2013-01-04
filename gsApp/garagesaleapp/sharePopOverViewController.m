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
@synthesize parent;

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
}

-(IBAction)facebook:(id)sender
{
    if (imgProduct == nil)
        [AddThisSDK shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrlImg]]] withService:@"facebook" title:@"Product Send from Garagesaleapp.me" description:self.description];
    else
        [AddThisSDK shareImage:imgProduct withService:@"facebook" title:@"Product Send from Garagesaleapp.me" description:description];
}

-(IBAction)twitter:(id)sender
{
    if (imgProduct == nil)
        [AddThisSDK shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrlImg]]] withService:@"twitter" title:@"Product Send from Garagesaleapp.me" description:self.description];
    else
        [AddThisSDK shareImage:imgProduct withService:@"twitter" title:@"Product Send from Garagesaleapp.me" description:description];
}

- (IBAction)actionEmailComposer {
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    [mail setToRecipients:[NSArray arrayWithObject:@""]];
    [mail setSubject:@"Product Send from Garagesaleapp.me"];
    
    NSData *data = UIImagePNGRepresentation(imgProduct);
    [mail addAttachmentData:data mimeType:@"image/png" fileName:@"image.png"];
    [mail setMessageBody:description isHTML:YES];
    
    [parent presentViewController:mail animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [parent dismissModalViewControllerAnimated:YES];
    
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Sent!" message:@"Your message has been sent! \n Thank you for your feedback" delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil];
        [alert show];
    } if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed" message:@"Your email has failed to send \n Please try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
