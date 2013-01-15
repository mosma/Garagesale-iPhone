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
    NSArray                                     *arrayGarage;
    NSArray                                     *arrayProfile;
    NSArray                                     *arrayViewHelper;

}

@property (nonatomic, retain) RKObjectManager *RKObjManeger;

-(void)getResourcePathProfile:(NSString *)garage;
+(NSURL*) getGravatarURL:(NSString*) emailAddress;
-(UIImage*)getTTImage:(Profile *)profile;

@end
