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
#import "PhotoReturn.h"
#import "GarageNameValidate.h"
#import "EmailValidate.h"
#import "RecoverPassword.h"
#import "viewHelperReturn.h"

@interface Mappings : NSObject {
}

+ (RKObjectMapping *)getProductMapping;
+ (RKObjectMapping *)getPhotoMapping;
+ (RKObjectMapping *)getCaminhoMapping;
+ (RKObjectMapping *)getGarageMapping;
+ (RKObjectMapping *)getProfileMapping;
+ (RKObjectMapping *)getLoginMapping;
+ (RKObjectMapping *)getProductPhotoMapping;
+ (RKObjectMapping *)getPhotosByIdProduct;
+ (RKObjectMapping *)getValidGarageNameMapping;
+ (RKObjectMapping *)getValidEmailMapping;
+ (RKObjectMapping *)getRecoverPassword;
+ (RKObjectMapping *)getViewHelperMapping;
@end
