//
//  Photo.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 06/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@synthesize caminho;
@synthesize caminhoThumb;
@synthesize caminhoTiny;
@synthesize principal;
@synthesize idProduto;
@synthesize idEstado;
@synthesize id;
@synthesize id_estado;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"caminho", @"caminho",
            @"caminhoThumb", @"caminhoThumb",
            @"caminhoTiny", @"caminhoTiny",
            @"principal", @"principal",
            @"idProduto", @"idProduto",
            @"idEstado", @"idEstado",
            @"id", @"id",
            @"id_estado", @"id_estado",
            nil];
}

@end
