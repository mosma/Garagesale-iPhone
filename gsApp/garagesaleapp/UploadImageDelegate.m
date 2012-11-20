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
@synthesize photoReturn;
@synthesize buttonSaveProduct;

-(void)uploadPhotos:(NSMutableArray *)mutArrayPicsProduct idProduct:(int)idProduct{
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

    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progressView setFrame:CGRectMake(5, 50, 60, 5)];
    progressView.progress = 0;
    [imageView addSubview: progressView];
    
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
    
    if (idProduct == -1)
        [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo?token=%@", [[GlobalFunctions getUserDefaults] objectForKey:@"token"]] params:params delegate:self];
    else
        [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo?token=%@&idProduct=%i", [[GlobalFunctions getUserDefaults] objectForKey:@"token"], idProduct ] params:params delegate:self];
    
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
        [progressView setHidden:YES];
        [imageView setUserInteractionEnabled:YES];
        
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

    double uu = ((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
    NSLog(@"%f", uu);

    [progressView setProgress:uu];
    
    if (totalBytesExpectedToWrite != totalBytesWritten)
        [self setEnableSaveButton:NO];
    else
        [self setEnableSaveButton:YES];
}

@end
