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
    __weak IBOutlet UILabel                  *productName;
    __weak IBOutlet UILabel                  *currency;
    __weak IBOutlet UILabel                  *garageName;
    __weak IBOutlet OHAttributedLabel        *valorEsperado;
    __weak IBOutlet UIImageView              *imageView;
    __weak IBOutlet UIImageView              *imageGravatar;
    __weak IBOutlet UIButton                 *imageEditButton;
}

@property (weak, nonatomic) IBOutlet UILabel                *productName;
@property (weak, nonatomic) IBOutlet UILabel                *currency;
@property (weak, nonatomic) IBOutlet UILabel                *garageName;
@property (weak, nonatomic) IBOutlet OHAttributedLabel      *valorEsperado;
@property (weak, nonatomic) IBOutlet UIImageView            *imageView;
@property (weak, nonatomic) IBOutlet UIImageView            *imageGravatar;
@property (weak, nonatomic) IBOutlet UIButton               *imageEditButton;

@end
