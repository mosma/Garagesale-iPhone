//
//  productDetailViewController.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 08/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "galleryScrollViewController.h"
#import "garageDetailViewController.h"
#import "Photo.h"
#import "Product.h"
#import "ProductPhotos.h"
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
#import "Bid.h"
#import "OHAttributedLabel.h"

@interface productDetailViewController : UIViewController <UITextFieldDelegate, 
                                                            UITextViewDelegate, 
                                                            BSKeyboardControlsDelegate,
                                                            UIScrollViewDelegate,
                                                            RKObjectLoaderDelegate> {
                                                                
    RKObjectManager                             *RKObjManeger;
    Product                                     *product;
    NSArray                                     *arrayGarage;
    NSArray                                     *arrayProfile;
    NSArray                                     *arrayTags;
    UIView                                      *shadowView;
    BOOL                                        isIdPersonNumber;
                                                                                                    
    IBOutlet UILabel                            *nomeLabel;
    IBOutlet UILabel                            *currencyLabel;
    IBOutlet UILabel                            *descricaoLabel;
    IBOutlet OHAttributedLabel                  *valorEsperadoLabel;
    IBOutlet UIScrollView                       *scrollView;
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
    __unsafe_unretained IBOutlet UILabel        *offerLabel;
    __unsafe_unretained IBOutlet UILabel        *msgBidSentLabel;
    __unsafe_unretained IBOutlet UIView         *secondView;
    __unsafe_unretained IBOutlet UIView         *viewBidSend;
    __unsafe_unretained IBOutlet UIView         *viewBidMsg;
    IBOutlet UIView                             *garageDetailView;
    UIButton                                    *addThisButton;
                                                                
    //Gallery Images Objects.
    NSMutableArray          *productPhotos;
    UIImageView             *imageView;
    IBOutlet UIScrollView   *galleryScrollView;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *activityIndicator;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *activityIndicatorGarage;

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
@property (retain, nonatomic) IBOutlet UILabel                  *descricaoLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel        *valorEsperadoLabel;
@property (retain, nonatomic) IBOutlet UIScrollView             *scrollView;
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
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *offerLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *msgBidSentLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *secondView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *viewBidSend;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *viewBidMsg;
@property (retain, nonatomic) IBOutlet UIView                   *garageDetailView;

//Gallery Images Objects.
@property (retain, nonatomic) NSMutableArray         *productPhotos;
@property (retain, nonatomic) UIImageView            *imageView;
@property (retain, nonatomic) IBOutlet UIScrollView  *galleryScrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorGarage;

- (IBAction)actionEmailComposer;
- (IBAction)animationBidView;
- (IBAction)textFieldEditingEnded:(id)sender;
- (void)setupGarageMapping;
- (void)setupProfileMapping;
- (void)setupProductMapping;
- (IBAction)gotoGalleryScrollVC;
- (IBAction)gotoGarageDetailVC;
- (IBAction)gotoUserProductTableVC;
- (void)gotoProductTableVC:(UIButton *)sender;
- (void)setLoadAnimation;
- (void)hideMsgBidSent;
- (IBAction)isNumberKey:(UITextField *)textField;
- (IBAction)bidPost:(id)sender;
- (void)loadAttribsToComponents:(BOOL)isFromLoadObject;
- (IBAction)pageControlCliked;
- (void)setupProductMapping:(NSString *)localResource;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView;

@end
