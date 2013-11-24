//
//  searchCustomViewCell.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 08/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "searchCustomViewCell.h"

@implementation searchCustomViewCell

@synthesize productName;
@synthesize valorEsperado;
@synthesize currency;
@synthesize garageName;
@synthesize imageView;
@synthesize imageEditButton;
@synthesize imageGravatar;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
