//
//  PhotoReturn.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 01/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "PhotoReturn.h"

@implementation PhotoReturn

@synthesize name;
@synthesize size;
@synthesize type;
@synthesize url;
@synthesize mobile_url;
@synthesize listing_url;
@synthesize listing_scaled_url;
@synthesize icon_url;
@synthesize delete_url;
@synthesize delete_type;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"name", @"name",
            @"size", @"size",
            @"type", @"type",
            @"url", @"url",
            @"mobile_url", @"mobile_url",
            @"listing_url", @"listing_url",
            @"listing_scaled_url", @"listing_scaled_url",
            @"icon_url", @"icon_url",
            @"delete_url", @"delete_url",
            @"delete_type", @"delete_type",
            nil];
}

@end
