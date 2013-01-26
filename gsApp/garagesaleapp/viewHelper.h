//
//  viewHelper.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 04/01/13.
//  Copyright (c) 2013 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RestKit/RKJSONParserJSONKit.h"
#import "GlobalFunctions.h"

@interface viewHelper : NSObject <RKObjectLoaderDelegate> {
    RKObjectManager *RKObjManeger;
    NSArray                                    *arrayProfile;
    NSArray                                    *arrayTTReturn;
}

@property (nonatomic, retain) RKObjectManager *RKObjManeger;
@property (nonatomic, retain) UIImage         *imageAvatar;
@property (nonatomic, retain) NSString        *avatarName;

-(UIImage *)getGarageAvatar:(NSArray *)profile;
-(void)getResourcePathGarage:(NSString *)garageName;
-(void)cancelRequestsWithDelegate;

@end
