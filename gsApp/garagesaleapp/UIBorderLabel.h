//
//  UIBorderLabel.h
//  garagesaleapp
//
//  Created by Tarek Abdala Rfaei Jradi on 1/16/14.
//  Copyright (c) 2014 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBorderLabel : UILabel
{
    CGFloat topInset;
    CGFloat leftInset;
    CGFloat bottomInset;
    CGFloat rightInset;
}

@property (nonatomic) CGFloat topInset;
@property (nonatomic) CGFloat leftInset;
@property (nonatomic) CGFloat bottomInset;
@property (nonatomic) CGFloat rightInset;

@end
