//
//  productDetailViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 08/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "galleryScrollViewController.h"
#import "garageDetailViewController.h"
#import "Product.h"
#import "Garage.h"
#import "Profile.h"
#import "RestKit/RestKit.h"
#import "RestKit/RKJSONParserJSONKit.h"

@interface productDetailViewController : UIViewController {
    RKObjectManager                             *manager;
    Product                                     *product;
    NSArray                                     *garage;
    NSArray                                     *profile;
    NSArray                                     *tags;
    BOOL                                        isIdPersonNumber;
    IBOutlet UILabel                            *nomeLabel;
    IBOutlet UITextView                         *descricaoTextView;
    IBOutlet UILabel                            *valorEsperadoLabel;
    IBOutlet UIScrollView                       *scrollView;
    IBOutlet UIImageView                        *imageView;
    __unsafe_unretained IBOutlet UIButton       *bidButton;
    __unsafe_unretained IBOutlet UITextField    *emailTextField;
    __unsafe_unretained IBOutlet UITextField    *offerTextField;
    __unsafe_unretained IBOutlet UILabel        *nameProfile;
    __unsafe_unretained IBOutlet UILabel        *cityProfile;
    __unsafe_unretained IBOutlet UILabel        *emailProfile;
    __unsafe_unretained IBOutlet UIImageView    *imgProfile;
    __unsafe_unretained IBOutlet UIScrollView   *tagsScrollView;
    __unsafe_unretained IBOutlet UIButton       *showPicsButton;
    __unsafe_unretained IBOutlet UIButton       *garageDetailButton;
    __unsafe_unretained IBOutlet UIButton       *seeAllButton;
    __unsafe_unretained IBOutlet UIImageView    *imageLoad;
    __unsafe_unretained IBOutlet UILabel        *offerLabel;
    __unsafe_unretained IBOutlet UILabel        *descriptionLabel;
    __unsafe_unretained IBOutlet UILabel        *msgBidSentLabel;
    __unsafe_unretained IBOutlet UIView         *secondView;
}

@property (strong, nonatomic) id detailItem;
@property (retain, nonatomic) RKObjectManager *manager;
@property (retain, nonatomic) Product *product;
@property (retain, nonatomic) NSArray *garage;
@property (retain, nonatomic) NSArray *profile;
@property (retain, nonatomic) NSArray *tags;
@property (nonatomic) BOOL isIdPersonNumber;
@property (retain, nonatomic) IBOutlet UILabel *nomeLabel;
@property (retain, nonatomic) IBOutlet UILabel *currencyLabel;
@property (retain, nonatomic) IBOutlet UITextView *descricaoTextView;
@property (retain, nonatomic) IBOutlet UILabel *valorEsperadoLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *bidButton;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *emailTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *offerTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *cityProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *emailProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *tagsScrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *showPicsButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *garageDetailButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *seeAllButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageLoad;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *offerLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *msgBidSentLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *secondView;

- (void)loadAttributesSettings;
- (IBAction)actionEmailComposer;
- (IBAction)textFieldEditingEnded:(id)sender;
- (void)setupGarageMapping;
- (void)setupProfileMapping;
- (void)setupProductMapping;
- (NSURL*) getGravatarURL:(NSString*) emailAddress;
- (IBAction)gotoGalleryScrollVC;
- (IBAction)gotoGarageDetailVC;
- (IBAction)gotoUserProductTableVC;
- (void)gotoProductTableVC:(UIButton *)sender;
- (IBAction)isNumberKey:(UITextField *)textField;
- (void)drawTagsButton;
- (void)setLoadAnimation;
- (void)hideMsgBidSent;
- (BOOL)validEmail:(NSString*) emailString;

@end
