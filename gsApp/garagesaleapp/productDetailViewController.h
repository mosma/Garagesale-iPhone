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
#import "BSKeyboardControls.h"
#import "AddThis.h"
#import "productTableViewController.h"
#import "garageDetailViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Category.h"
#import "Photo.h"
#import "Bid.h"
#import "GlobalFunctions.h"

@interface productDetailViewController : UIViewController <UITextFieldDelegate, 
                                                           UITextViewDelegate, BSKeyboardControlsDelegate> {
    RKObjectManager                             *RKObjManeger;
    Product                                     *product;
    NSArray                                     *arrayGarage;
    NSArray                                     *arrayProfile;
    NSArray                                     *arrayTags;
    BOOL                                        isIdPersonNumber;
    IBOutlet UILabel                            *nomeLabel;
    UILabel                                     *descricaoLabel;
    IBOutlet UILabel                            *valorEsperadoLabel;
    IBOutlet UIScrollView                       *scrollView;
    IBOutlet UIImageView                        *imageView;
    __unsafe_unretained IBOutlet UIButton       *bidButton;
    __unsafe_unretained IBOutlet UITextField    *emailTextField;
    __unsafe_unretained IBOutlet UITextField    *offerTextField;
    __unsafe_unretained IBOutlet UITextView     *commentTextView;
    __unsafe_unretained IBOutlet UILabel        *nameProfile;
    __unsafe_unretained IBOutlet UILabel        *cityProfile;
    __unsafe_unretained IBOutlet UILabel        *emailProfile;
    __unsafe_unretained IBOutlet UIImageView    *imgProfile;
    __unsafe_unretained IBOutlet UIButton       *showPicsButton;
    __unsafe_unretained IBOutlet UIButton       *garageDetailButton;
    __unsafe_unretained IBOutlet UIButton       *seeAllButton;
    __unsafe_unretained IBOutlet UIImageView    *imgViewLoading;
    __unsafe_unretained IBOutlet UILabel        *offerLabel;
    __unsafe_unretained IBOutlet UILabel        *descriptionLabel;
    __unsafe_unretained IBOutlet UILabel        *msgBidSentLabel;
    __unsafe_unretained IBOutlet UIView         *secondView;
    IBOutlet UIView                             *garageDetailView;
    UIButton                                    *addThisButton;
}

@property (strong, nonatomic) id detailItem;
@property (retain, nonatomic) RKObjectManager                   *RKObjManeger;
@property (retain, nonatomic) Product                           *product;
@property (retain, nonatomic) NSArray                           *arrayGarage;
@property (retain, nonatomic) NSArray                           *arrayProfile;
@property (retain, nonatomic) NSArray                           *arrayTags;
@property (nonatomic) BOOL                                      isIdPersonNumber;
@property (retain, nonatomic) IBOutlet UILabel                  *nomeLabel;
@property (retain, nonatomic) IBOutlet UILabel                  *currencyLabel;
@property (retain, nonatomic) UILabel                           *descricaoLabel;
@property (retain, nonatomic) IBOutlet UILabel                  *valorEsperadoLabel;
@property (retain, nonatomic) IBOutlet UIScrollView             *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView              *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton      *bidButton;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField   *emailTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField   *offerTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView    *commentTextView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *nameProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *cityProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *emailProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView   *imgProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton      *showPicsButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton      *garageDetailButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton      *seeAllButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView   *imgViewLoading;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *offerLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *descriptionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *msgBidSentLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *secondView;
@property (retain, nonatomic) IBOutlet UIView                   *garageDetailView;

- (void)loadAttribsToComponents;
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
- (void)setLoadAnimation;
- (void)hideMsgBidSent;
- (IBAction)isNumberKey:(UITextField *)textField;

@end
