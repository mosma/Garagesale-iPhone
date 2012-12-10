//
//  MasterViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 02/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface MasterViewController : GAITrackedViewController {
    UIView *viewMessageNet;
    UILabel *labelNotification;
    BOOL isReachability;
}

@property (nonatomic) BOOL isReachability;

@end
