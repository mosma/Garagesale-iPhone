//
//  viewHelperReturn.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 04/01/13.
//  Copyright (c) 2013 MOSMA. All rights reserved.
//

#import "viewHelperReturn.h"

@implementation viewHelperReturn

@synthesize requestToken;
@synthesize validateUrl;
@synthesize oauthVerifier;
@synthesize oauthToken;
@synthesize userId;
@synthesize idPessoa;
@synthesize id;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"requestToken", @"requestToken",
            @"validateUrl", @"validateUrl",
            @"oauthVerifier", @"oauthVerifier",
            @"oauthToken", @"oauthToken",
            @"userId", @"userId",
            @"idPessoa", @"idPessoa",
            @"id", @"id",
            nil];
}

@end
