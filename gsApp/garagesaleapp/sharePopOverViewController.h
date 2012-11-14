//
//  sharePopOverViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 14/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddThis.h"

@interface sharePopOverViewController : UIViewController {
        NSString *strUrlImg;
        UIImage  *imgProduct;
        NSString *description;
}

@property  (nonatomic, retain) NSString *strUrlImg;
@property  (nonatomic, retain) UIImage  *imgProduct;
@property  (nonatomic, retain) NSString *description;


-(IBAction)twitter:(id)sender;
-(IBAction)facebook:(id)sender;

@end
