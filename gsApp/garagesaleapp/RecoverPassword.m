//
//  RecoverPassword.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 05/03/13.
//  Copyright (c) 2013 MOSMA. All rights reserved.
//

#import "RecoverPassword.h"

@implementation RecoverPassword

@synthesize message;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"message", @"message",
            nil];
}

@end

