//
//  productCustomViewCell.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 08/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "productCustomViewCell.h"

@implementation productCustomViewCell

@synthesize productName;
@synthesize valorEsperado;
@synthesize currency;
@synthesize garageName;
@synthesize imageView;
@synthesize imageEditButton;
@synthesize imageGravatar;
@synthesize activityImageView;

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


-(void)carregaAnimate {


    
    UIImage *statusImage = [UIImage imageNamed:@"ActivityHome00.png"];
    
    
    
    activityImageView = [[UIImageView alloc] initWithImage:statusImage];
    
    activityImageView.tag = 111;
    
    [activityImageView setCenter:[self contentView].center];
    
    activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"ActivityHome00.png"],
                                         [UIImage imageNamed:@"ActivityHome01.png"],
                                         [UIImage imageNamed:@"ActivityHome02.png"],
                                         [UIImage imageNamed:@"ActivityHome03.png"],
                                         [UIImage imageNamed:@"ActivityHome04.png"],
                                         [UIImage imageNamed:@"ActivityHome05.png"],
                                         [UIImage imageNamed:@"ActivityHome06.png"],
                                         [UIImage imageNamed:@"ActivityHome07.png"],
                                         [UIImage imageNamed:@"ActivityHome00.png"],
                                         nil];
    activityImageView.animationDuration = 1.0;
    
    [activityImageView startAnimating];


    
    [self.contentView insertSubview:activityImageView belowSubview:imageView];
    
    
    
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//    
//    dispatch_async(queue, ^{
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:link]]]];
//            [self setNeedsLayout];
//        });
//    });

    
    //[aWebView addSubview:progressView];
    
    
//    [aWebView loadData:[NSData dataWithContentsOfURL:[NSURL URLWithString:link]] MIMEType:@"image/jpg" textEncodingName:nil baseURL:nil];
    
  
//    receivedData = [[NSMutableData alloc]init];
//    NSURL *urlString = [NSURL URLWithString:@"http://www.vidabesta.com/vidabesta/imagens/tiras/tira2119.gif"];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlString];
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:requestObj delegate:self];
//    [connection start];


    
    
}

@end
