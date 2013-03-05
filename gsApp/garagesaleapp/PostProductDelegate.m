
//
//  PostProductDelegate.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 31/10/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "PostProductDelegate.h"

@implementation PostProductDelegate

@synthesize isSaveProductDone;
@synthesize isSaveProductFail;

-(void)postProduct:(NSMutableDictionary *)productParams {
    timerSave = [NSTimer scheduledTimerWithTimeInterval:150.0 target:self selector:@selector(setSaveProductFail) userInfo:nil repeats:NO];
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    //The server ask me for this format, so I set it here:
    [postData setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"] forKey:@"token"];
    [postData setObject:[productParams valueForKey:@"idUser"] forKey:@"idUser"];
    [postData setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"garagem"] forKey:@"garage"];
    
    //Parsing prodParams to JSON!
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:[GlobalFunctions getMIMEType]];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:productParams error:&error];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
    
    //If no error we send the post, voila!
    if (!error){
        //Add ProductJson in postData for key product
        [postData setObject:json forKey:@"product"];
        [[[RKClient sharedClient] post:@"/product" params:postData delegate:self] send];
    }
}

-(void)setSaveProductFail{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[RKRequestQueue sharedQueue] cancelRequestsWithDelegate:self];
    isSaveProductFail = YES;
}

//-(void)setSaveProductDone{
//    isSaveProductDone = YES;
//}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [self setSaveProductFail];
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
        // Handling POST /other.json
        isSaveProductDone = YES;
        [timerSave invalidate];
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

@end
