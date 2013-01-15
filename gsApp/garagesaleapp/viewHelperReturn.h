//
//  viewHelperReturn.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 04/01/13.
//  Copyright (c) 2013 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface viewHelperReturn : NSObject {
    NSString* requestToken;
    NSString* validateUrl;
    NSString* oauthVerifier;
    NSString* oauthToken;
    NSNumber* userId;
    NSNumber* idPessoa;
    NSNumber* id;
}

@property (nonatomic, retain) NSString* requestToken;
@property (nonatomic, retain) NSString* validateUrl;
@property (nonatomic, retain) NSString* oauthVerifier;
@property (nonatomic, retain) NSString* oauthToken;
@property (nonatomic, retain) NSNumber* userId;
@property (nonatomic, retain) NSNumber* idPessoa;
@property (nonatomic, retain) NSNumber* id;

@end
