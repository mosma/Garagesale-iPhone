//
//  main.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 03/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#ifndef OBJC_ARC_ENABLED

#ifdef __has_feature

#define OBJC_ARC_ENABLED __has_feature(objc_arc)

#else

#define OBJC_ARC_ENABLED 0

#endif

#endif



int main(int argc, char *argv[])
{ 
#if OBJC_ARC_ENABLED
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
#else
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
#endif
    
}
