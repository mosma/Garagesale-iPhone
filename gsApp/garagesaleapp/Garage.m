//
//  Garage.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 10/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "Garage.h"

@implementation Garage

@synthesize link;
@synthesize about;
@synthesize country;
@synthesize district;
@synthesize city;
@synthesize address;
@synthesize localization;
@synthesize idState;
@synthesize idPerson;
@synthesize id;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"link", @"link",
            @"about", @"about",
            @"country", @"country",
            @"district", @"district",
            @"city", @"city",
            @"address", @"address",
            @"localization", @"localization",
            @"idState", @"idState",
            @"idPerson", @"idPerson",
            @"id", @"id",
            nil];
}

@end
