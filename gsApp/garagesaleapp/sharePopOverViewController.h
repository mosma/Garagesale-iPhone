//
//  sharePopOverViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 14/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MessageUI/MessageUI.h>

@interface sharePopOverViewController : UIViewController {
    __weak UIImage  *imgProduct;
    __weak NSString *idProduct;
    __weak NSString *priceProduct;
    __weak NSString *garageName;
    __weak NSString *strUrlImg;
    __weak NSString *prodName;
    __weak NSString *description;
    __weak UIViewController *parent;
}

@property  (weak, nonatomic) UIImage  *imgProduct;
@property  (weak, nonatomic) NSString *idProduct;
@property  (weak, nonatomic) NSString *priceProduct;
@property  (weak, nonatomic) NSString *garageName;
@property  (weak, nonatomic) NSString *strUrlImg;
@property  (weak, nonatomic) NSString *description;
@property  (weak, nonatomic) NSString *prodName;
@property  (weak, nonatomic) UIViewController *parent;

-(IBAction)facebook:(id)sender;
-(IBAction)twitter:(id)sender;
-(IBAction)actionEmailComposer;

@end
