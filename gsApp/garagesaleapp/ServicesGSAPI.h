//
//  ServicesGSAPI.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 22/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"
#import "RestKit/RKJSONParserJSONKit.h"
#import "Product.h"
#import "GlobalFunctions.h"


#import <UIKit/UIKit.h>

@interface ServicesGSAPI : NSObject <RKObjectLoaderDelegate>{
    RKObjectManager      *RKObjManeger;
    NSArray              *arrayProducts;
}

@property (nonatomic, retain) NSArray               *arrayProducts;
@property (nonatomic, retain) RKObjectManager       *RKObjManeger;

- (void)setupProductMapping;
- (void)reachability;
@end
