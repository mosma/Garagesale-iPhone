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
//@synthesize nsMutArrayNames;
@synthesize nsMutArrayPicsProduct;
@synthesize scrollView;
@synthesize idProduct;
@synthesize totalBytesWritten;
@synthesize totalBytesExpectedToWrite;
@synthesize moveLeftGesture;
@synthesize imagePic;
@synthesize progressView;

-(id)init{
    photoReturn = [[PhotoReturn alloc] init];
    refreshGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadPhotos)];

    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progressView setFrame:CGRectMake(5, 50, 60, 5)];
    
    
    return self;
}

-(void)uploadPhotos{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [imageView setImage:self.imagePic];
    }];
    
    int picNumber = [nsMutArrayPicsProduct count] -1;
    
    RKParams* params = [RKParams params];
    //for(int i = 0; i < [nsMutArrayPicsProduct count]; i++){

    
    [self setEnableSaveButton:NO];
    
    [self.imageView setUserInteractionEnabled:NO];

    
    NSData              *dataImage  = UIImageJPEGRepresentation(imageView.image, 1.0);
    
    
//    NSData              *dataImage  = UIImageJPEGRepresentation([(UIImageView *)[mutArrayPicsProduct objectAtIndex:index] image], 1.0);

    
   // UIImage *loadedImage = [(UIImageView *)[mutArrayPicsProduct objectAtIndex:index] image];
    
    UIImage *loadedImage = imageView.image;

    
    
    float w = loadedImage.size.width;
    float h = loadedImage.size.height;
    float ratio = w/h;
    
    if (self.totalBytesWritten == 0 && totalBytesWritten == 0)
        [imageView addSubview:progressView];
    
    
    [progressView setHidden:NO];
    progressView.progress = 0;
    
    
    
    
    int neww = 900;
    //get image height proportionally;
    float newh = neww/ratio;

    
    timerUpload = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(cancelUpload) userInfo:nil repeats:NO];

    
    UIImage *image = [UIImage imageWithData:dataImage];
    CGRect rect = CGRectMake(0.0, 0.0, neww, newh);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imgdata1 = UIImageJPEGRepresentation(img, 1.0);
    
    
    
    
    
    RKParamsAttachment  *attachment = [params setData:imgdata1 forParam:@"files"];
    attachment.MIMEType = @"image/png";
    attachment.fileName = [NSString stringWithFormat:@"foto%i.jpg", picNumber];
        
    if (idProduct == -1)
        [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo?token=%@", [[GlobalFunctions getUserDefaults] objectForKey:@"token"]] params:params delegate:self];
    else
        [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo?token=%@&idProduct=%i", [[GlobalFunctions getUserDefaults] objectForKey:@"token"], idProduct ] params:params delegate:self];
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
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
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"YES" forKey:@"isNewOrRemoveProduct"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}


-(void)cancelUpload{
    
    if (self.totalBytesWritten == self.totalBytesExpectedToWrite && self.totalBytesWritten != 0) {
        NSLog(@"ok");
    }else{
        [[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self];

    
    

//    int indexPic = [nsMutArrayPicsProduct count]-1;
//    if ([nsMutArrayPicsProduct count] == [nsMutArrayNames count])
//        [nsMutArrayNames removeObjectAtIndex:indexPic];
//    [nsMutArrayPicsProduct removeObjectAtIndex:indexPic];

        
        [self setEnableSaveButton:YES];

        


        
        [imageView removeGestureRecognizer:self.moveLeftGesture];
        [imageView addGestureRecognizer:refreshGesture];
        
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [imageView setImage:[UIImage imageNamed:@"refresh"]];

        }];
        
        
        [self.imageView setUserInteractionEnabled:YES];
        
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
}

- (void)deletePhoto {
    [progressView setHidden:YES];
    NSLog(@"%@", [photoReturn valueForKey:@"delete_url"]);
    [[RKClient sharedClient] delete:[photoReturn valueForKey:@"delete_url"] delegate:self];
    [photoReturn setValue:@"" forKey:@"name"];
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    self.totalBytesWritten = totalBytesWritten;
    self.totalBytesExpectedToWrite = totalBytesExpectedToWrite;
    
    NSLog(@"%i - bytesWritten", bytesWritten);
    NSLog(@"%i - totalBytesWritten", totalBytesWritten);
    NSLog(@"%i - totalBytesExpectedToWrite", totalBytesExpectedToWrite);

    double uu = ((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
    NSLog(@"%f", uu);

    [progressView setProgress:uu];
    
    [timerUpload invalidate];
    timerUpload = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(cancelUpload) userInfo:nil repeats:NO];
    
    
    
    if (totalBytesExpectedToWrite != totalBytesWritten)
        [self setEnableSaveButton:NO];
    else{
        [self.imageView setUserInteractionEnabled:YES];
        [progressView setHidden:YES];
        [self setEnableSaveButton:YES];
        [imageView removeGestureRecognizer:refreshGesture];
        [imageView addGestureRecognizer:moveLeftGesture];
    }
}

/**
 * Sent to the delegate when a request was cancelled
 */
- (void)requestDidCancelLoad:(RKRequest *)request{
    NSLog(@"requestDidCancelLoad");
}

/**
 * Sent to the delegate when a request has timed out. This is sent when a
 * backgrounded request expired before completion.
 */
//- (void)requestDidTimeout:(RKRequest *)request{
//    UIAlertView *alertttt = [[UIAlertView alloc] initWithTitle:@"requestDidTimeout" message:request.description delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//    
//    [alertttt show];
//}
//
//- (void)cancelAfterTimeout {
//    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
//    NSError *myError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
//                                                   code:12345 userInfo:nil];
//    //feel free to customize the error code, domain and add userInfo when needed.
//    [self handleRestKitError:myError];
//}
//
//- (void)handleRestKitError:(NSError*)error {
//    UIAlertView *alertttt = [[UIAlertView alloc] initWithTitle:@"handleRestKitError" message:error.description delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//    
//    [alertttt show];}
//
//
//- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object  {
//    UIAlertView *alertttt = [[UIAlertView alloc] initWithTitle:@"didLoadObject" message:@"" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//    
//    [alertttt show];}


@end
