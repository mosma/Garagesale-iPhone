//
//  Photo.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 06/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject{
    NSArray*  caminho;
    NSString* caminhoThumb;
    NSString* caminhoTiny;
    NSNumber* principal;
    NSNumber* idProduto;
    NSNumber* idEstado;
    NSNumber* id;
    NSNumber* id_estado;
}

@property (nonatomic, retain) NSArray*  caminho;
@property (nonatomic, retain) NSString* caminhoThumb;
@property (nonatomic, retain) NSString* caminhoTiny;
@property (nonatomic, retain) NSNumber* principal;
@property (nonatomic, retain) NSNumber* idProduto;
@property (nonatomic, retain) NSNumber* idEstado;
@property (nonatomic, retain) NSNumber* id;
@property (nonatomic, retain) NSNumber* id_estado;



@end
