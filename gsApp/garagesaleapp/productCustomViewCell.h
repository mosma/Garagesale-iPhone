//
//  productCustomViewCell.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 08/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@interface productCustomViewCell : UITableViewCell {
    IBOutlet UILabel                  *productName;
    IBOutlet OHAttributedLabel        *valorEsperado;
    IBOutlet UILabel                  *currency;
    IBOutlet UILabel                  *garageName;
    IBOutlet UIImageView              *imageView;
    IBOutlet UIImageView              *imageEditButton;
    IBOutlet UIImageView              *imageGravatar;
}

@property (retain, nonatomic) IBOutlet UILabel                *productName;
@property (retain, nonatomic) IBOutlet OHAttributedLabel      *valorEsperado;
@property (retain, nonatomic) IBOutlet UILabel                *currency;
@property (retain, nonatomic) IBOutlet UILabel                *garageName;
@property (retain, nonatomic) IBOutlet UIImageView            *imageView;
@property (retain, nonatomic) IBOutlet UIImageView            *imageEditButton;
@property (retain, nonatomic) IBOutlet UIImageView            *imageGravatar;

@end
