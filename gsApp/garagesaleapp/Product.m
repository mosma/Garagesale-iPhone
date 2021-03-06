//
//  Product.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 06/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "Product.h"

@implementation Product

@synthesize sold;
@synthesize showPrice;
@synthesize currency;
@synthesize fotos;
@synthesize categorias;
@synthesize valorEsperado;
@synthesize descricao;
@synthesize nome;
@synthesize idEstado;
@synthesize idPessoa;
@synthesize link;
@synthesize id;

+ (NSDictionary*) elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"sold", @"sold",
            @"showPrice", @"showPrice",
            @"currency", @"currency",
            @"categorias", @"categorias",
            @"valorEsperado", @"valorEsperado",
            @"descricao", @"descricao",
            @"nome", @"nome",
            @"idEstado", @"idEstado",
            @"idPessoa", @"idPessoa",
            @"link", @"link",
            @"id", @"id",
            nil];
}

+ (NSDictionary*) elementToRelationshipMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"fotos", @"fotos",
            nil];
}

@end
