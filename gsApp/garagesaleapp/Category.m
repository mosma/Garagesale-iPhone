//
//  Category.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 05/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "Category.h"

@implementation Category

@synthesize identifier;
@synthesize descricao;
@synthesize idPessoa;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"id", @"identifier",
            @"descricao", @"descricao",
            @"idPessoa", @"idPessoa",
            nil];
}

@end
