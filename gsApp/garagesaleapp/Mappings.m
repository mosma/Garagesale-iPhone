//
//  Mappings.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 19/10/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "Mappings.h"

@implementation Mappings

+ (RKObjectMapping *)getProductMapping{
    //Configure Product Object Mapping
    RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[Product class]];
    [productMapping mapKeyPath:@"sold"          toAttribute:@"sold"];
    [productMapping mapKeyPath:@"showPrice"     toAttribute:@"showPrice"];
    [productMapping mapKeyPath:@"currency"      toAttribute:@"currency"];
    [productMapping mapKeyPath:@"categorias"    toAttribute:@"categorias"];
    [productMapping mapKeyPath:@"valorEsperado" toAttribute:@"valorEsperado"];
    [productMapping mapKeyPath:@"descricao"     toAttribute:@"descricao"];
    [productMapping mapKeyPath:@"nome"          toAttribute:@"nome"];
    [productMapping mapKeyPath:@"idEstado"      toAttribute:@"idEstado"];
    [productMapping mapKeyPath:@"idPessoa"      toAttribute:@"idPessoa"];
    [productMapping mapKeyPath:@"link"          toAttribute:@"link"];
    [productMapping mapKeyPath:@"id"            toAttribute:@"id"];
    return productMapping;
}

+ (RKObjectMapping *)getPhotoMapping{
    //Configure Photo Object Mapping
    RKObjectMapping *photoMapping = [RKObjectMapping mappingForClass:[Photo class]];
    [photoMapping mapAttributes:
     @"caminhoThumb",
     @"caminhoTiny",
     @"principal",
     @"idProduto",
     @"id",
     @"id_estado",
     nil];
    return photoMapping;
}

+ (RKObjectMapping *)getCaminhoMapping{
    //Configure Caminho Object Mapping
    RKObjectMapping *caminhoMapping = [RKObjectMapping mappingForClass:[Caminho class]];
    [caminhoMapping mapAttributes:
     @"icon",
     @"listing",
     @"listingscaled",
     @"mobile",
     @"original",
     nil];
    return caminhoMapping;
}

+ (RKObjectMapping *)getGarageMapping{
    //Configure Garage Object Mapping
    RKObjectMapping *garageMapping = [RKObjectMapping mappingForClass:[Garage class]];
    [garageMapping mapKeyPath:@"link"           toAttribute:@"link"];
    [garageMapping mapKeyPath:@"about"          toAttribute:@"about"];
    [garageMapping mapKeyPath:@"country"        toAttribute:@"country"];
    [garageMapping mapKeyPath:@"district"       toAttribute:@"district"];
    [garageMapping mapKeyPath:@"city"           toAttribute:@"city"];
    [garageMapping mapKeyPath:@"address"        toAttribute:@"address"];
    [garageMapping mapKeyPath:@"localization"   toAttribute:@"localization"];
    [garageMapping mapKeyPath:@"idState"        toAttribute:@"idState"];
    [garageMapping mapKeyPath:@"idPerson"       toAttribute:@"idPerson"];
    [garageMapping mapKeyPath:@"id"             toAttribute:@"id"];
    return garageMapping;
}

+ (RKObjectMapping *)getProfileMapping{
    //Configure Profile Object Mapping
    RKObjectMapping *prolileMapping = [RKObjectMapping mappingForClass:[Profile class]];
    [prolileMapping mapKeyPath:@"garagem"   toAttribute:@"garagem"];
    [prolileMapping mapKeyPath:@"senha"     toAttribute:@"senha"];
    [prolileMapping mapKeyPath:@"nome"      toAttribute:@"nome"];
    [prolileMapping mapKeyPath:@"email"     toAttribute:@"email"];
    [prolileMapping mapKeyPath:@"idRole"    toAttribute:@"idRole"];
    [prolileMapping mapKeyPath:@"idState"   toAttribute:@"idState"];
    [prolileMapping mapKeyPath:@"id"        toAttribute:@"id"];
    return prolileMapping;
}

+ (RKObjectMapping *)getLoginMapping{
    //Configure Login Object Mapping
    RKObjectMapping *loginMapping = [RKObjectMapping mappingForClass:[Login class]];
    [loginMapping mapKeyPath:@"idPerson"     toAttribute:@"idPerson"];
    [loginMapping mapKeyPath:@"token"        toAttribute:@"token"];
    return loginMapping;
}

+ (RKObjectMapping *)getProductPhotoMapping{
    //Configure Product Photo Object Mapping
    RKObjectMapping *productPhotoMapping = [RKObjectMapping mappingForClass:[ProductPhotos class]];
    [productPhotoMapping mapKeyPath:@"sold"          toAttribute:@"sold"];
    [productPhotoMapping mapKeyPath:@"showPrice"     toAttribute:@"showPrice"];
    [productPhotoMapping mapKeyPath:@"currency"      toAttribute:@"currency"];
    [productPhotoMapping mapKeyPath:@"categorias"    toAttribute:@"categorias"];
    [productPhotoMapping mapKeyPath:@"valorEsperado" toAttribute:@"valorEsperado"];
    [productPhotoMapping mapKeyPath:@"descricao"     toAttribute:@"descricao"];
    [productPhotoMapping mapKeyPath:@"nome"          toAttribute:@"nome"];
    [productPhotoMapping mapKeyPath:@"idEstado"      toAttribute:@"idEstado"];
    [productPhotoMapping mapKeyPath:@"idPessoa"      toAttribute:@"idPessoa"];
    [productPhotoMapping mapKeyPath:@"id"            toAttribute:@"id"];
    return productPhotoMapping;
}

+ (RKObjectMapping *)getPhotosByIdProduct{
    //Configure Photo By IdProduct Object Mapping
    RKObjectMapping *photoByIdProdutcMapping = [RKObjectMapping mappingForClass:[PhotoReturn class]];
    [photoByIdProdutcMapping mapKeyPath:@"name"                 toAttribute:@"name"];
    [photoByIdProdutcMapping mapKeyPath:@"size"                 toAttribute:@"size"];
    [photoByIdProdutcMapping mapKeyPath:@"type"                 toAttribute:@"type"];
    [photoByIdProdutcMapping mapKeyPath:@"url"                  toAttribute:@"url"];
    [photoByIdProdutcMapping mapKeyPath:@"mobile_url"           toAttribute:@"mobile_url"];
    [photoByIdProdutcMapping mapKeyPath:@"listing_url"          toAttribute:@"listing_url"];
    [photoByIdProdutcMapping mapKeyPath:@"listing_scaled_url"   toAttribute:@"listing_scaled_url"];
    [photoByIdProdutcMapping mapKeyPath:@"icon_url"             toAttribute:@"icon_url"];
    [photoByIdProdutcMapping mapKeyPath:@"delete_url"           toAttribute:@"delete_url"];
    [photoByIdProdutcMapping mapKeyPath:@"delete_type"          toAttribute:@"delete_type"];
    return photoByIdProdutcMapping;
}

+ (RKObjectMapping *)getValidGarageNameMapping{
    //Configure Valid Garage Name Object Mapping
    RKObjectMapping *validGarageNameMapping = [RKObjectMapping mappingForClass:[GarageNameValidate class]];
    [validGarageNameMapping mapKeyPath:@"message"    toAttribute:@"message"];
    return validGarageNameMapping;
}

+ (RKObjectMapping *)getValidEmailMapping{
    //Configure Valid Email Object Mapping
    RKObjectMapping *validEmailMapping = [RKObjectMapping mappingForClass:[GarageNameValidate class]];
    [validEmailMapping mapKeyPath:@"message"    toAttribute:@"message"];
    return validEmailMapping;
}

@end
