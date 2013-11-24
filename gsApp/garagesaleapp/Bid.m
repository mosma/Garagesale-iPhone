//
//  Bid.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 27/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "Bid.h"

@implementation Bid

@synthesize email;
@synthesize value;
@synthesize comment;
@synthesize idProduct;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"email", @"email",
            @"value", @"value",
            @"comment", @"comment",
            @"idProduct", @"idProduct",
            nil];
}

@end
