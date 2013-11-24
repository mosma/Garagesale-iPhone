//
//  Caminho.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 28/09/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "Caminho.h"

@implementation Caminho

@synthesize icon;
@synthesize listing;
@synthesize listingscaled;
@synthesize mobile;
@synthesize original;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"icon", @"icon",
            @"listing", @"listing",
            @"listingscaled", @"listingscaled",
            @"mobile", @"mobile",
            @"original", @"original",
            nil];
}

@end
