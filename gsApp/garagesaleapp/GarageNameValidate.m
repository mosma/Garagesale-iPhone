//
//  GarageNameValidate.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 07/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "GarageNameValidate.h"

@implementation GarageNameValidate

@synthesize message;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"message", @"message",
            nil];
}

@end
