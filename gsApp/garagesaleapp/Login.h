//
//  Login.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 18/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login : NSObject{
    NSNumber* idPerson;
    NSString* token;
}

@property (nonatomic, retain) NSNumber* idPerson;
@property (nonatomic, retain) NSString* token;

@end