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
@synthesize imageAvatar;
@synthesize avatarName;
@synthesize isCancelRequests;

-(id)init{
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    RKObjManeger = [RKObjectManager sharedManager];
    return self;
}

//receive a user profie and returns its image
-(UIImage *)getGarageAvatar:(NSArray *)profile {
    //first validates if there is a facebook profile
    BOOL isFBConnect = [[[profile objectAtIndex:0] fbConnect] boolValue];
    if(isFBConnect) {
        imageAvatar =  [self getFBImage:[[profile objectAtIndex:0] fbId]];
        if(imageAvatar) {
            [self updateAvatar];
            return imageAvatar;
        }
    }
    
    //validates then if there is a twitter account
    else {
        imageAvatar = [self getTTImage:arrayTTReturn];
        
        //in case of twitter login, uses the twitter image
        if(imageAvatar){
            [self updateAvatar];
            return imageAvatar;
        }
        //in the case there is no fb ow twitter, we find for the gravatar
        
        imageAvatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self getGravatarURL:[[profile objectAtIndex:0] email]]]];
        
        if(imageAvatar) {
            [self updateAvatar];
            return imageAvatar;
        }
    }
    NSString *url = @"http://garagesaleapp.me/images/no-profileimg-small.jpg";
    imageAvatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    return imageAvatar;
}

-(void)updateAvatar{
    NSUserDefaults *gravImg = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:avatarName];
    NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:imageAvatar];
    [gravImg setObject:imageData forKey:avatarName];
    [gravImg synchronize];
}

-(NSURL*)getGravatarURL:(NSString*) emailAddress {
    @try {
        if (!emailAddress || [emailAddress isEqualToString:@""])
            return [NSURL URLWithString:@"http://garagesaleapp.me/images/no-profileimg-small.jpg"];
        
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
                              result[12], result[13], result[14], result[15]];
        NSString *gravatarEndPoint = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=160&d=http://gsapp.me/images/no-profileimg.jpg", md5email];
        
        return [NSURL URLWithString:gravatarEndPoint];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    }
}

//validates a profile for a twitter picture
- (UIImage*)getTTImage:(NSArray *)viewHelperReturn {
    //fint for the twitter id
    // also got by the url http://gsapi.easylikethat.com/profile/USER_ID?ttinfo=true
    // on the var userId
    //$obj['large'] = "http://api.twitter.com/1/users/profile_image/".$id->getUserId()."?size=original";
    
    NSNumber *idTT = [[viewHelperReturn objectAtIndex:0] userId];
    
    if(!idTT) return false;
    //using the returnet userId
    NSString *path = [NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@?size=normal", idTT];
    NSLog(@"%@", path);
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
}

//validates a profile for a facebook image
-(UIImage *)getFBImage:(NSString *)idFaceBook {
    NSString *url1 = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", idFaceBook];
   //NSString *url2 = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=250&height=250", idFaceBook];
   //NSDictionary *obj = [[NSDictionary alloc] initWithObjectsAndKeys:@"small", url1, @"large", url2, nil];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url1]]];
    return img;
}

- (void)getResourcePathGarage:(NSString *)garageName{
    RKObjectMapping *garageMapping = [Mappings getGarageMapping];
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/garage/%@", garageName]
                              objectMapping:garageMapping delegate:self];
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class]
                                          forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathProfile:(NSArray *)garage {
    RKObjectMapping *prolileMapping = [Mappings getProfileMapping];
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@", [[garage objectAtIndex:0] idPerson]]
                              objectMapping:prolileMapping delegate:self];
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class]
                                          forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourceTTimage {
    RKObjectMapping *viewHelperMapping = [Mappings getViewHelperMapping];
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/profile/%@?ttinfo=true",
                                             [[arrayProfile objectAtIndex:0] id]]
                              objectMapping:viewHelperMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class]
                                          forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([objects count] > 0) {
        if  ([[objects objectAtIndex:0] isKindOfClass:[Garage class]]){
            [self getResourcePathProfile:objects];
        }
        else if  ([[objects objectAtIndex:0] isKindOfClass:[Profile class]]){
            arrayProfile = objects;
            BOOL isFBConnect = [[[objects objectAtIndex:0] fbConnect] boolValue];
            if (isFBConnect) {
                imageAvatar = [self getGarageAvatar:arrayProfile];
            }else
                [self getResourceTTimage];
        }
        else if ([[objects objectAtIndex:0] isKindOfClass:[viewHelperReturn class]]){
            arrayTTReturn = objects;
            imageAvatar = [self getGarageAvatar:arrayProfile];
        } 
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered error: %@",                      error);
    if (!isCancelRequests) {
        imageAvatar = nil;
        imageAvatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                              [self getGravatarURL:[[arrayProfile objectAtIndex:0] email]]]];
        [self updateAvatar];    
    }
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

-(void)cancelRequestsWithDelegate{
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
}

-(void)dealloc {
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
}

@end
