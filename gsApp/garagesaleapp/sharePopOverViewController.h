//
//  sharePopOverViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 14/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddThis.h"
//#import <MessageUI/MessageUI.h>

@interface sharePopOverViewController : UIViewController {
        NSString *strUrlImg;
    UIImage  *imgProduct;
    NSString *prodName;
    NSString *description;
        UIViewController *parent;
}

@property  (nonatomic, retain) NSString *strUrlImg;
@property  (nonatomic, retain) UIImage  *imgProduct;
@property  (nonatomic, retain) NSString *description;
@property  (nonatomic, retain) NSString *prodName;
@property  (nonatomic, retain) UIViewController *parent;

-(IBAction)facebook:(id)sender;
-(IBAction)twitter:(id)sender;
-(IBAction)actionEmailComposer;

@end
