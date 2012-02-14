//
//  ProductPhotos.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 14/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "ProductPhotos.h"

@implementation ProductPhotos

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
            @"id", @"id",
            nil];
}

+ (NSDictionary*) elementToRelationshipMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"fotos", @"fotos",
            nil];
}

@end
