//
//  viewHelper.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 04/01/13.
//  Copyright (c) 2013 MOSMA. All rights reserved.
//

#import "viewHelper.h"
#import <CommonCrypto/CommonDigest.h> //CC_MD5

@implementation viewHelper

@synthesize RKObjManeger;

-(id)init{
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    RKObjManeger = [RKObjectManager sharedManager];
    return self;
}

- (void)getResourcePathGarage {
    RKObjectMapping *garageMapping = [Mappings getGarageMapping];
    
//    if (self.isIdPersonNumber)
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", [(Profile *)[arrayProfile objectAtIndex:0] garagem]]
                                  objectMapping:garageMapping delegate:self];
//    else
//        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", self.product.idPessoa]
//                                  objectMapping:garageMapping delegate:self];
    
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathProfile:(NSString *)profile {
    
    RKObjectMapping *prolileMapping = [Mappings getProfileMapping];
    
//    if (self.isIdPersonNumber)
//        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", self.product.idPessoa]
//                                  objectMapping:prolileMapping delegate:self];
//    else
        [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", profile]
                                  objectMapping:prolileMapping delegate:self];
    
    //Set JSon Type
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourceTTImage {
    RKObjectMapping *viewHelperMapping = [Mappings getViewHelperMapping];
    
    //http://gsapi.easylikethat.com/profile/505?ttinfo=true
    
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@?ttinfo=true",
                                             [[arrayProfile objectAtIndex:0] id]]
                              objectMapping:viewHelperMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

+ (NSURL*) getGravatarURL:(NSString*) emailAddress {
	NSString *curatedEmail = [[emailAddress stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceCharacterSet]]
							  lowercaseString];
    
	const char *cStr = [curatedEmail UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    
	NSString *md5email = [NSString stringWithFormat:
                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15]
                          ];
	NSString *gravatarEndPoint = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=160&d=http://gsapp.me/images/no-profileimg.jpg", md5email];
    
	return [NSURL URLWithString:gravatarEndPoint];
}

//validates a profile for a twitter picture
- (UIImage*)getTTImage:(Profile *)profile {
    //fint for the twitter id
    
    // also got by the url http://gsapi.easylikethat.com/profile/USER_ID?ttinfo=true
    
    // on the var userId
    
    int id = [profile.id intValue];
    
    if(!id) return false;
    
    //using the returnet userId
    
    return [NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@?size=normal", [(viewHelperReturn *)[arrayViewHelper objectAtIndex:0] userId] ];
    
    
    //$obj['large'] = "http://api.twitter.com/1/users/profile_image/".$id->getUserId()."?size=original";
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([objects count] > 0) {
        

        
        if  ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
            arrayProfile = objects;
            [self getResourcePathGarage];
        }
        else if ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
            arrayGarage = objects;
            [self getResourceTTImage];
        }
        else if ([[objects objectAtIndex:0] isKindOfClass:[viewHelperReturn class]]){
            arrayViewHelper = objects;
        }
        
        
        
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered error: %@",                      error);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    if ([request isGET]) {
        // Handling GET /foo.xml
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
    } else if ([request isPOST]) {
        
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

@end
