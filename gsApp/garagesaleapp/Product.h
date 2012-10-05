//
//  Product.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 06/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface Product : NSObject {
    Boolean sold;
    Boolean showPrice;
    NSString* currency;
    NSArray* categorias;
    NSString* valorEsperado;
    NSString* descricao;
    NSString* nome;
    NSNumber* idEstado;
    NSString* idPessoa;
    NSString* link;
    NSNumber* id;
    NSArray* fotos;
}
@property (nonatomic) Boolean sold;
@property (nonatomic) Boolean showPrice;
@property (nonatomic, retain) NSString* currency;
@property (nonatomic, retain) NSArray* categorias;
@property (nonatomic, retain) NSString* valorEsperado;
@property (nonatomic, retain) NSString* descricao;
@property (nonatomic, retain) NSString* nome;
@property (nonatomic, retain) NSNumber* idEstado;
@property (nonatomic, retain) NSString* idPessoa;
@property (nonatomic, retain) NSString* link;
@property (nonatomic, retain) NSNumber* id;
@property (nonatomic, retain) NSArray* fotos;

@end