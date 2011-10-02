//
//  ProductsDetailViewController.h
//  garageSale
//
//  Created by Tarek Abdala on 23/09/11.
//  Copyright 2011 UFSC - Universidade Federal Santa Catarina. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductDetailViewController : UIViewController {
    
    IBOutlet UIScrollView *scrollFotos;
    IBOutlet UIView *viewDetail;
    IBOutlet UIView *viewOffers;
}

-(IBAction)pushViewOffers:(id)sender;
-(IBAction)pushViewDetail:(id)sender;

@property(retain,nonatomic) UIScrollView *scrollFotos;
@property(retain,nonatomic) UIView *viewDetail;
@property(retain,nonatomic) UIView *viewOffers;

@end
