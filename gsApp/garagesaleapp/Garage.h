//
//  Garage.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 10/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Garage : NSObject{
    
    NSString* link;
    NSString* about;
    NSString* country;
    NSString* district;
    NSString* city;
    NSString* address;
    NSString* localization;
    NSNumber* idState;
    NSNumber* idPerson;
    NSNumber* id;
}

@property (nonatomic, retain) NSString* link;
@property (nonatomic, retain) NSString* about;
@property (nonatomic, retain) NSString* country;
@property (nonatomic, retain) NSString* district;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* localization;
@property (nonatomic, retain) NSNumber* idState;
@property (nonatomic, retain) NSNumber* idPerson;
@property (nonatomic, retain) NSNumber* id;

@end
