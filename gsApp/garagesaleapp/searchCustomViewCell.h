//
//  searchCustomViewCell.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 08/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@interface searchCustomViewCell : UITableViewCell {
    IBOutlet UILabel                  *productName;
    IBOutlet UILabel                  *currency;
    IBOutlet UILabel                  *garageName;
    IBOutlet OHAttributedLabel        *valorEsperado;
    IBOutlet UIImageView              *imageView;
    IBOutlet UIImageView              *imageGravatar;
    IBOutlet UIButton                 *imageEditButton;
}

@property (retain, nonatomic) IBOutlet UILabel                *productName;
@property (retain, nonatomic) IBOutlet UILabel                *currency;
@property (retain, nonatomic) IBOutlet UILabel                *garageName;
@property (retain, nonatomic) IBOutlet OHAttributedLabel      *valorEsperado;
@property (retain, nonatomic) IBOutlet UIImageView            *imageView;
@property (retain, nonatomic) IBOutlet UIImageView            *imageGravatar;
@property (retain, nonatomic) IBOutlet UIButton               *imageEditButton;

@end