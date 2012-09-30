//
//  Caminho.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 28/09/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Caminho : NSObject{
    NSString *icon;
    NSString *listing;
    NSString *listingscaled;
    NSString *mobile;
    NSString *original;
}

@property (nonatomic, retain) NSString* icon;
@property (nonatomic, retain) NSString* listing;
@property (nonatomic, retain) NSString* listingscaled;
@property (nonatomic, retain) NSString* mobile;
@property (nonatomic, retain) NSString* original;

@end
