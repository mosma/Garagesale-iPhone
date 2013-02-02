//
//  sharePopOverViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 14/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "sharePopOverViewController.h"
#import "GlobalFunctions.h"

@interface sharePopOverViewController ()

@end

@implementation sharePopOverViewController

@synthesize strUrlImg;
@synthesize description;
@synthesize idProduct;
@synthesize priceProduct;
@synthesize garageName;
@synthesize prodName;
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
    
    
    [AddThisSDK setTwitterAuthenticationMode:ATTwitterAuthenticationTypeOAuth];
    [AddThisSDK setTwitterConsumerKey:@"VjxdccbCQn88i0uvg8w"];
    [AddThisSDK setTwitterConsumerSecret:@"lMMbO9dtewLkuAGwRYIPByztAtHdNtVOQxao9Y"];
    [AddThisSDK setTwitterCallBackURL:@"http://garagesaleapp.me/login/ttreturn"];
    
    [AddThisSDK setTwitterViaText:@"garagesaleapp"];
    
    [AddThisSDK shouldAutoRotate:NO];
    [AddThisSDK setInterfaceOrientation:UIInterfaceOrientationPortrait];
    
    [AddThisSDK setAddThisPubId:@"ra-4f9585050fbd99b4"];
}

-(IBAction)facebook:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",
                     [GlobalFunctions getUrlApplication],
                     self.garageName,
                     self.idProduct];
    
    NSString *title = [NSString stringWithFormat:
                       NSLocalizedString(@"share-facebook-title", nil),
                       url,
                       self.priceProduct,
                       self.prodName];
    
    NSString *content = [NSString stringWithFormat:
                         NSLocalizedString(@"share-facebook-content", nil),
                         self.description];
    
    if (imgProduct == nil)
        [AddThisSDK shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrlImg]]]
                   withService:@"facebook"
                         title: title
                   description:content];
    else
        [AddThisSDK shareImage:imgProduct
                   withService:@"facebook"
                         title: title
                   description:content];
}

-(IBAction)twitter:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",
                     [GlobalFunctions getUrlApplication],
                     self.garageName,
                     self.idProduct];
    
    NSString *title = [NSString stringWithFormat:
                       NSLocalizedString(@"share-twitter-title", nil),
                       self.prodName,
                       url];
    
    NSString *content = [NSString stringWithFormat:
                         NSLocalizedString(@"share-twitter-content", nil), url];

    if (imgProduct == nil)
        [AddThisSDK shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrlImg]]]
                   withService:@"twitter"
                         title: title
                   description:content];
    else
        [AddThisSDK shareImage:imgProduct
                   withService:@"twitter"
                         title: title
                   description:content];
}

- (IBAction)actionEmailComposer {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",
                     [GlobalFunctions getUrlApplication],
                     self.garageName,
                     self.idProduct];

    
    NSString *title = [NSString stringWithFormat: NSLocalizedString(@"share-email-title", nil), self.prodName];
    NSString *content = [NSString stringWithFormat: NSLocalizedString(@"share-email-content", nil),
                         url,
                         self.prodName,
                         self.priceProduct,
                         self.description];
    
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    [mail setToRecipients:[NSArray arrayWithObject:@""]];
    [mail setSubject:title];
    
    NSData *data = UIImagePNGRepresentation(imgProduct);
    [mail addAttachmentData:data mimeType:@"image/png" fileName:@"image.png"];
    [mail setMessageBody:content isHTML:NO];
    
    [parent presentViewController:mail animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [parent dismissModalViewControllerAnimated:YES];
    
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"share-response-title", nil)
                              message: NSLocalizedString(@"share-response-text", nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"share-response-btn1", nil)
                              otherButtonTitles:nil];
        [alert show];
    } if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"share-response-error-title", nil)
                              message: NSLocalizedString(@"share-response-error-text", nil)
                              delegate:self
                              cancelButtonTitle: NSLocalizedString(@"share-response-error-btn1", nil)
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
