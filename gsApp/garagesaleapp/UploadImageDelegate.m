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
@synthesize imageViewDelete;
@synthesize photoReturn;
@synthesize nsMutArrayPicsProduct;
@synthesize idProduct;
@synthesize totalBytesW;
@synthesize totalBytesExpectedToW;
@synthesize moveLeftGesture;
@synthesize imagePic;
@synthesize progressView;
@synthesize prodAccount;

-(id)init{
    photoReturn = [[PhotoReturn alloc] init];
    refreshGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadPhotos)];

    progressView = [[PDColoredProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progressView setFrame:CGRectMake(5, 50, 60, 7)];
    [progressView setTintColor:[UIColor colorWithRed:105.0/255.0 green:159.0/255.0 blue:77.0/255.0 alpha:1.0]];
    return self;
}
-(void)setTimmer{
    timerUpload = [NSTimer scheduledTimerWithTimeInterval:40.0 target:self selector:@selector(cancelUpload) userInfo:nil repeats:NO];
}

-(void)uploadPhotos{
    [UIView animateWithDuration:0.2 animations:^{
        
        [imageView setImage:self.imagePic];
    }];
    
    int picNumber = [nsMutArrayPicsProduct count] -1;
    
    RKParams* params = [RKParams params];

    self.prodAccount.countUploaded = self.prodAccount.countUploaded + 1;
    [self setEnableSaveButton:self.prodAccount.countUploaded];
    [self.imageView setUserInteractionEnabled:NO];

    [self setTimmer];
    
    NSData              *dataImage  = UIImageJPEGRepresentation(imageView.image, 1.0);
    UIImage *loadedImage = imageView.image;
    
    float w = loadedImage.size.width;
    float h = loadedImage.size.height;
    float ratio = w/h;
    
    if (self.totalBytesW == 0 && totalBytesW == 0)
        [imageView addSubview:progressView];
    
    [progressView setHidden:NO];
    progressView.progress = 0;
    
    int neww = 900;
    //get image height proportionally;
    float newh = neww/ratio;
    
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

    [self.imageViewDelete setHidden:YES];
    
    if (idProduct == -1)
        [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo?token=%@", [[GlobalFunctions getUserDefaults] objectForKey:@"token"]] params:params delegate:self];
    else
        [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo?token=%@&idProduct=%i", [[GlobalFunctions getUserDefaults] objectForKey:@"token"], idProduct ] params:params delegate:self];
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [prodAccount.scrollViewPicsProduct setUserInteractionEnabled:YES];
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

-(void)cancelUpload{
    if (self.totalBytesW == self.totalBytesExpectedToW && self.totalBytesW != 0 && ![self.imageViewDelete isHidden])
        return;
    else {
        [[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self];
        self.prodAccount.countUploaded = self.prodAccount.countUploaded -1;
        [self setEnableSaveButton:self.prodAccount.countUploaded];
        [imageView removeGestureRecognizer:self.moveLeftGesture];
        [imageView addGestureRecognizer:refreshGesture];
        [UIView animateWithDuration:0.2 animations:^{
            [imageView setImage:[UIImage imageNamed:@"refresh"]];
        }];
        [self.imageView setUserInteractionEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [timerUpload invalidate];
    }
}

-(void)setEnableSaveButton:(int)count{
    if (count == 0) {
        [prodAccount.buttonSaveProduct setEnabled:YES];
        [prodAccount.buttonSaveProduct setAlpha:1.0];
    } else {
        [prodAccount.buttonSaveProduct setEnabled:NO];
        [prodAccount.buttonSaveProduct setAlpha:0.3];
    }
}

-(void)setValuesResponseToVC:(NSString *)response{
    [timerUpload invalidate];
    [imageView setUserInteractionEnabled:YES];
    //transform in json
    NSArray *jsonArray = (NSArray *)[response JSONValue];
    photoReturn = [jsonArray objectAtIndex:0];
    [NSThread detachNewThreadSelector:@selector(setImageIconReturn) toTarget:self withObject:nil];
    [self.imageViewDelete setHidden:NO];
    self.prodAccount.countUploaded = self.prodAccount.countUploaded -1;
    [self setEnableSaveButton:self.prodAccount.countUploaded];
    [progressView setHidden:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
-(void)setImageIconReturn{
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                              [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [GlobalFunctions getUrlApplication], [photoReturn valueForKey:@"listing_url"]]]]];
}

- (void)deletePhoto {
    if (prodAccount.isReachability) {
        [progressView setHidden:YES];
        NSLog(@"%@", [photoReturn valueForKey:@"delete_url"]);
        [[RKClient sharedClient] delete:[photoReturn valueForKey:@"delete_url"] delegate:self];
        [photoReturn setValue:@"" forKey:@"name"];
    }
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    self.totalBytesW = totalBytesWritten;
    self.totalBytesExpectedToW = totalBytesExpectedToWrite;

    double uu = ((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
    [progressView setProgress:uu];
    
    [timerUpload invalidate];
    [self setTimmer];
    
    if (totalBytesExpectedToWrite == totalBytesWritten){
        [self.imageView setUserInteractionEnabled:YES];
        [imageView removeGestureRecognizer:refreshGesture];
        [imageView addGestureRecognizer:moveLeftGesture];
    } 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/**
 * Sent to the delegate when a request was cancelled
 */
- (void)requestDidCancelLoad:(RKRequest *)request{
    NSLog(@"requestDidCancelLoad");
}

@end
