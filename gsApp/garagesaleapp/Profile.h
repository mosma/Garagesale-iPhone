//
//  Profile.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 10/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject{
    NSString* garagem;
    NSString* senha;
    NSString* nome;
    NSString* email;
    NSString* lang;
    NSNumber* fbId;
    BOOL      fbConnect;
    NSNumber* idRole;
    NSNumber* idState;
    NSNumber* id;
}

@property (nonatomic, retain) NSString* garagem;
@property (nonatomic, retain) NSString* senha;
@property (nonatomic, retain) NSString* nome;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* lang;
@property (nonatomic, retain) NSNumber* fbId;
@property (unsafe_unretained, nonatomic) BOOL      fbConnect;
@property (nonatomic, retain) NSNumber* idRole;
@property (nonatomic, retain) NSNumber* idState;
@property (nonatomic, retain) NSNumber* id;

@end

