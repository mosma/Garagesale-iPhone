//
//  Profile.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 10/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@synthesize garagem;
@synthesize senha;
@synthesize nome;
@synthesize email;
@synthesize idRole;
@synthesize idState;
@synthesize id;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"garagem", @"garagem",
            @"senha", @"senha",
            @"nome", @"nome",
            @"email", @"email",
            @"idRole", @"idRole",
            @"idState", @"idState",
            @"id", @"id",
            nil];
}

@end
