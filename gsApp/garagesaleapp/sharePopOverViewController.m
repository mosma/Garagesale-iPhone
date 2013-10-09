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
    [self.view setFrame:CGRectMake(0, 20, 320, 460)];
}

-(IBAction)facebook:(id)sender
{
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Product"
                                                     withAction:@"Share"
                                                      withLabel:@"FaceBook"
                                                      withValue:nil];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",
                     [GlobalFunctions getUrlApplication],
                     self.garageName,
                     self.idProduct];
    
    [self showFeedDialog];
    
    url = nil;
}
/**
 * Helper method for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}
/**
 * Method that displays the Feed dialog.
 */
- (void)showFeedDialog {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",
                     [GlobalFunctions getUrlApplication],
                     self.garageName,
                     self.idProduct];
    
    // Put together the dialog parameters
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     prodName, @"name",
     @"See more in gsapp.me", @"caption",
     description, @"description",
     url, @"link",
     strUrlImg, @"picture",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:[FBSession activeSession]
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Case A: Error launching the dialog or publishing story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // Case B: User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Case C: Dialog shown and the user clicks Cancel or Share
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *postID = [urlParams valueForKey:@"post_id"];
                     NSLog(@"Posted story, id: %@", postID);
                 }
             }
         }
     }];
    url = nil;
}

-(IBAction)twitter:(id)sender
{
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Product"
                                                     withAction:@"Share"
                                                      withLabel:@"Twitter"
                                                      withValue:nil];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",
                     [GlobalFunctions getUrlApplication],
                     self.garageName,
                     self.idProduct];

    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:[NSString stringWithFormat:@"%@ - %@", prodName, description]];
    if (![strUrlImg isEqualToString:@""])
        [twitter addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrlImg]]]];
    [twitter addURL:[NSURL URLWithString:url]];
    
    [self presentViewController:twitter animated:YES completion:nil];
}

- (IBAction)actionEmailComposer {
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Product"
                                                     withAction:@"Share"
                                                      withLabel:@"Email"
                                                      withValue:nil];
    
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
    
    if (imgProduct) {
        NSData *data = UIImagePNGRepresentation(imgProduct);
        [mail addAttachmentData:data mimeType:@"image/png" fileName:@"image.png"];
        data = nil;
    }
    [mail setMessageBody:content isHTML:NO];
    
    [parent presentViewController:mail animated:YES completion:nil];
    
    url = nil;
    title = nil;
    content = nil;
    mail = nil;
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
        alert = nil;
    } if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"share-response-error-title", nil)
                              message: NSLocalizedString(@"share-response-error-text", nil)
                              delegate:self
                              cancelButtonTitle: NSLocalizedString(@"share-response-error-btn1", nil)
                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)otherWayToShareWithFaceBook{
    
    /*
    
     Ref : 
     https://developers.facebook.com/docs/tutorials/ios-sdk-games/feed/#step1
     https://developers.facebook.com/docs/tutorial/iossdk/upgrading-from-3.1-to-3.2/
     */
    
    // This function will invoke the Feed Dialog to post to a user's Timeline and News Feed
    // It will attemnt to use the Facebook Native Share dialog
    // If that's not supported we'll fall back to the web based dialog.
    
    //    NSString *linkURL = [NSString stringWithFormat:@"http://www.gsapp.me"];
    //
    //    // Prepare the native share dialog parameters
    //    FBShareDialogParams *shareParams = [[FBShareDialogParams alloc] init];
    //    shareParams.link = [NSURL URLWithString:linkURL];
    //    shareParams.name = prodName;
    //    shareParams.caption= @"";
    //    shareParams.picture= [NSURL URLWithString:strUrlImg];
    //    shareParams.description = description;
    //
    //    if ([FBDialogs canPresentShareDialogWithParams:shareParams]){
    //
    //        [FBDialogs presentShareDialogWithParams:shareParams
    //                                    clientState:nil
    //                                        handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
    //                                            if(error) {
    //                                                NSLog(@"Error publishing story.");
    //                                            } else if (results[@"completionGesture"] && [results[@"completionGesture"] isEqualToString:@"cancel"]) {
    //                                                NSLog(@"User canceled story publishing.");
    //                                            } else {
    //                                                NSLog(@"Story published.");
    //                                            }
    //                                        }];
    //
    //    }else {
    //
    //        // Prepare the web dialog parameters
    //        NSDictionary *params = @{
    //                                 @"name" : shareParams.name,
    //                                 @"caption" : shareParams.caption,
    //                                 @"description" : shareParams.description,
    //                                 @"picture" : strUrlImg,
    //                                 @"link" : linkURL
    //                                 };
    //
    //        // Invoke the dialog
    //        [FBWebDialogs presentFeedDialogModallyWithSession:nil
    //                                               parameters:params
    //                                                  handler:
    //         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
    //             if (error) {
    //                 NSLog(@"Error publishing story.");
    //             } else {
    //                 if (result == FBWebDialogResultDialogNotCompleted) {
    //                     NSLog(@"User canceled story publishing.");
    //                 } else {
    //                     NSLog(@"Story published.");
    //                 }
    //             }}];
    //    }
}

- (void)viewDidUnload{
    imgProduct = nil;
    [self setImgProduct:nil];
    idProduct = nil;
    [self setIdProduct:nil];
    priceProduct = nil;
    [self setPriceProduct:nil];
    garageName = nil;
    [self setGarageName:nil];
    strUrlImg = nil;
    [self setStrUrlImg:nil];
    description = nil;
    [self setDescription:nil];
    prodName = nil;
    [self setProdName:nil];
    parent = nil;
    [self setParent:nil];
}

@end
