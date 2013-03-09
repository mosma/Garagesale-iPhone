//
//  GSCategory.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 05/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCategory : NSObject {
    NSNumber* identifier;
    NSString* descricao;
    NSNumber* idPessoa;
}

@property (nonatomic, retain) NSNumber* identifier;
@property (nonatomic, retain) NSString* descricao;
@property (nonatomic, retain) NSNumber* idPessoa;

@end
