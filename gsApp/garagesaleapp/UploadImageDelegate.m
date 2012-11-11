//
//  UploadImageDelegate.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 31/10/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "UploadImageDelegate.h"

@implementation UploadImageDelegate

@synthesize imageView;
@synthesize scrollViewPicsProduct;
@synthesize photoReturn;
@synthesize buttonSaveProduct;

-(void)uploadPhotos:(NSMutableArray *)mutArrayPicsProduct{
    int index = ([mutArrayPicsProduct count]-1);
    
    RKParams* params = [RKParams params];
    //for(int i = 0; i < [nsMutArrayPicsProduct count]; i++){
    NSData              *dataImage  = UIImageJPEGRepresentation([mutArrayPicsProduct objectAtIndex:index], 1.0);
    UIImage *loadedImage = (UIImage *)[mutArrayPicsProduct objectAtIndex:index];
    float w = loadedImage.size.width;
    float h = loadedImage.size.height;
    float ratio = w/h;
    
    int neww = 900;
    //get image height proportionally;
    float newh = neww/ratio;
    
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(scrollViewPicsProduct.contentSize.width-50, scrollViewPicsProduct.contentSize.height+32, 25, 25)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    [activityIndicator setHidesWhenStopped:YES];
    
    [scrollViewPicsProduct addSubview:activityIndicator];
    
    [self setEnableSaveButton:NO];
    
    [imageView setAlpha:0];
    
    UIImage *image = [UIImage imageWithData:dataImage];
    CGRect rect = CGRectMake(0.0, 0.0, neww, newh);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imgdata1 = UIImageJPEGRepresentation(img, 1.0);
    
    RKParamsAttachment  *attachment = [params setData:imgdata1 forParam:@"files"];
    attachment.MIMEType = @"image/png";
    attachment.fileName = [NSString stringWithFormat:@"foto%i.jpg", index];
    
    [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo?token=%@", [[GlobalFunctions getUserDefaults] objectForKey:@"token"]] params:params delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [imageView removeFromSuperview];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self setEnableSaveButton:YES];
    
    NSLog(@"Encountered error: %@",                      error);
    NSLog(@"Encountered error.domain: %@",               error.domain);
    NSLog(@"Encountered error.localizedDescription: %@", error.localizedDescription);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
    } else if ([request isPOST]) {
        [imageView setAlpha:1.0];
        [imageView setUserInteractionEnabled:YES];
        [activityIndicator stopAnimating];
        
        [self setEnableSaveButton:YES];
        
        NSLog(@"after posting to server, %@", [response bodyAsString]);
        
        @try {
            [self setValuesResponseToVC:[response bodyAsString]];
        }
        @catch (NSException *exception) {
            NSLog(@"Response Not is A JSON : %@", response);
        }
        
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

-(void)setEnableSaveButton:(BOOL)enable{
    [buttonSaveProduct setEnabled:enable];
    enable ? [buttonSaveProduct setAlpha:1.0] : [buttonSaveProduct setAlpha:0.3];
}

-(void)setValuesResponseToVC:(NSString *)response{
    //transform in json
    NSArray *jsonArray = (NSArray *)[response JSONValue];
    photoReturn = [jsonArray objectAtIndex:0];
    
    //UIImage *imgDelete                  = [UIImage imageNamed:@"iconDeletePicsAtGalleryProdAcc.png"];
    //imgViewDelete          = [[UIImageView alloc] initWithImage:imgDelete];
    //[imgViewDelete setFrame:CGRectMake(-7, -7, 17, 17)];
    [imageView setUserInteractionEnabled:YES];
    //imgViewDelete.tag = 455;
    // [self.imageView addSubview:imgViewDelete];
}

- (void)deletePhoto {
    NSLog(@"%@", [photoReturn valueForKey:@"delete_url"]);
    [[RKClient sharedClient] delete:[photoReturn valueForKey:@"delete_url"] delegate:self];
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    NSLog(@"%i - bytesWritten", bytesWritten);
    NSLog(@"%i - totalBytesWritten", totalBytesWritten);
    NSLog(@"%i - totalBytesExpectedToWrite", totalBytesExpectedToWrite);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionShowHideTransitionViews];
    [imageView setAlpha:(totalBytesWritten/totalBytesExpectedToWrite)];
    [UIView commitAnimations];
}

@end
