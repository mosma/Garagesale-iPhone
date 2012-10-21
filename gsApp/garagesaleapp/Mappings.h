//
//  Mappings.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 19/10/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"
#import "Product.h"
#import "Caminho.h"
#import "Garage.h"
#import "Profile.h"
#import "Login.h"
#import "ProductPhotos.h"

@interface Mappings : NSObject {
}

+ (RKObjectMapping *)getProductMapping;
+ (RKObjectMapping *)getPhotoMapping;
+ (RKObjectMapping *)getCaminhoMapping;
+ (RKObjectMapping *)getGarageMapping;
+ (RKObjectMapping *)getProfileMapping;
+ (RKObjectMapping *)getLoginMapping;
+ (RKObjectMapping *)getProductPhotoMapping;

@end
