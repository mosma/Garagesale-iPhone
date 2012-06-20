//
//  garageAccountViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalFunctions.h"

@interface garageAccountViewController : UIViewController {
    
    __weak IBOutlet UILabel *token;
}

@property (weak, nonatomic) IBOutlet UILabel *token;

-(void)loadAttributsToComponents;

@end
