//
//  ProductPhotos.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 14/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface ProductPhotos : NSObject {
    Boolean sold;
    Boolean showPrice;
    NSString* currency;
    NSNumber* categorias;
    NSString* valorEsperado;
    NSString* descricao;
    NSString* nome;
    NSNumber* idEstado;
    NSString* idPessoa;
    NSArray* fotos;
    NSNumber* id;
}
@property (nonatomic) Boolean sold;
@property (nonatomic) Boolean showPrice;
@property (nonatomic, retain) NSString* currency;
@property (nonatomic, retain) NSNumber* categorias;
@property (nonatomic, retain) NSString* valorEsperado;
@property (nonatomic, retain) NSString* descricao;
@property (nonatomic, retain) NSString* nome;
@property (nonatomic, retain) NSNumber* idEstado;
@property (nonatomic, retain) NSString* idPessoa;
@property (nonatomic, retain) NSArray* fotos;
@property (nonatomic, retain) NSNumber* id;

@end