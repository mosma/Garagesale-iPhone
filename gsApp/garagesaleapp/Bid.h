//
//  Bid.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 27/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bid : NSObject {
    NSString* email;
    NSNumber* value;
    NSNumber* idProduct;
}

@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSNumber* value;
@property (nonatomic, retain) NSNumber* idProduct;


@end
