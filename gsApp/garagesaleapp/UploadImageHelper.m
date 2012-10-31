//
//  UploadImageHelper.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 29/10/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "UploadImageHelper.h"
#import "GlobalFunctions.h"

@implementation UploadImageHelper

@synthesize imageView;
@synthesize RKObjManeger;

- (id)init
{
    self = [super init];
    if (self != nil) {
        RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
        //Set SerializationMIMEType
        RKObjManeger.acceptMIMEType          = RKMIMETypeJSON;
        RKObjManeger.serializationMIMEType   = RKMIMETypeJSON;
    }
    return self;
}


-(void)uploadPhotos:(int)index mutArrayPicsProduct:(NSMutableArray *)mutArrayPicsProduct{
    
    
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
    
    UIImage *image = [UIImage imageWithData:dataImage];
    CGRect rect = CGRectMake(0.0, 0.0, neww, newh);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imgdata1 = UIImageJPEGRepresentation(img, 1.0);
    
    
    //[params setData:imgdata1 forParam:[NSString stringWithFormat:@"foto%i.jpg", index]];
    
    
    RKParamsAttachment  *attachment = [params setData:imgdata1 forParam:@"files"];
    attachment.MIMEType = @"image/png";
    attachment.fileName = [NSString stringWithFormat:@"foto%i.jpg", index];
    
    [[[RKObjectManager sharedManager] client] post:[NSString stringWithFormat:@"/photo?token=%@",[[GlobalFunctions getUserDefaults] objectForKey:@"token"]] params:params delegate:self];
    
    
    //    if ([idProduct isEqualToString:@""]) {
    //    } else {
    //        [[[RKObjectManager sharedManager] client] post:[NSString stringWithFormat:@"/photo?idProduct=%@&token=%@",idProduct,[[GlobalFunctions getUserDefaults] objectForKey:@"token"]] params:params delegate:self];
    //    }

}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSLog(@"Encountered error: %@",                      error);
    NSLog(@"Encountered error.domain: %@",               error.domain);
    NSLog(@"Encountered error.localizedDescription: %@", error.localizedDescription);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([[objects objectAtIndex:0] isKindOfClass:[Product class]]){
       // self.product = (Product *)[objects objectAtIndex:0];
       // [self loadAttributsToProduct];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
            //transforma json
           // NSArray *jsonArray = (NSArray *)[[response bodyAsString] JSONValue];
            
     //       NSDictionary *jsonDict = [jsonArray objectAtIndex:0];
            
            //download da imagem
            
            //remove imagem da view
            //self.imageView.image = imagem do download;
            
            //[self.imageView addSubview:imgViewDelete];
            // UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            //[picViewAtGallery addGestureRecognizer:longPressGesture];

           // NSString *q = [jsonDict objectForKey:@"url"];
            
            
            NSLog(@"recebida resposta");
        }
        @catch (NSException *exception) {
            NSLog(@"Not is A JSON PhotoDelete");
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

/**
 * Sent when a request has started loading
 */
- (void)requestDidStartLoad:(RKRequest *)request{
    NSLog(@"Got a JSON response back from our POST!");

}

/**
 * Sent when a request has uploaded data to the remote site
 */
- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    NSLog(@"totalBytesWritten!");
}

/**
 * Sent when request has received data from remote site
 */
- (void)request:(RKRequest*)request didReceivedData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExectedToReceive:(NSInteger)totalBytesExpectedToReceive{
    NSLog(@"totalBytesReceived!");
}

/**
 * Sent to the delegate when a request was cancelled
 */
- (void)requestDidCancelLoad:(RKRequest *)request{
    NSLog(@"requestDidCancelLoad!");
}

/**
 * Sent to the delegate when a request has timed out. This is sent when a
 * backgrounded request expired before completion.
 */
- (void)requestDidTimeout:(RKRequest *)request{
    NSLog(@"requestDidTimeout!");
}

/**
 * Sent when a request fails authentication
 */
- (void)request:(RKRequest *)request didFailAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"didFailAuthenticationChallenge!");
}

@end
