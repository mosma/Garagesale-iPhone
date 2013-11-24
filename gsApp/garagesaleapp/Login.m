//
//  Login.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 18/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "Login.h"

@implementation Login

@synthesize idPerson;
@synthesize token;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"idPerson", @"idPerson",
            @"token", @"token",
            nil];
}

@end
