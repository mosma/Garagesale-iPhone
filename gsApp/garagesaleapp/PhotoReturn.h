//
//  PhotoReturn.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 01/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoReturn : NSObject {
    NSString* name;
    NSString* size;
    NSString* type;
    NSString* url;
    NSString* mobile_url;
    NSString* listing_url;
    NSString* listing_scaled_url;
    NSString* icon_url;
    NSString* delete_url;
    NSString* delete_type;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* size;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* mobile_url;
@property (nonatomic, retain) NSString* listing_url;
@property (nonatomic, retain) NSString* listing_scaled_url;
@property (nonatomic, retain) NSString* icon_url;
@property (nonatomic, retain) NSString* delete_url;
@property (nonatomic, retain) NSString* delete_type;

@end
