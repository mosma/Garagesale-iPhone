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
#import "RestKit/RKJSONParserJSONKit.h"
#import "BSKeyboardControls.h"
#import "garageAccountViewController.h"
//#import "QuartzCore/QuartzCore.h"
#import "Category.h"
#import "Bid.h"
#import "OHAttributedLabel.h"
#import "FPPopoverController.h"
#import "sharePopOverViewController.h"

@interface productDetailViewController : MasterViewController <UITextFieldDelegate, 
                                                            UITextViewDelegate, 
                                                            BSKeyboardControlsDelegate,
                                                            UIScrollViewDelegate,
                                                            RKObjectLoaderDelegate,
                                                            UITabBarDelegate,
                                                            UIPopoverControllerDelegate,
                                                            UIAlertViewDelegate> {
                                                                
    
    RKObjectManager                             *RKObjManeger;
    Product                                     *product;
    NSArray                                     *arrayGarage;
    NSArray                                     *arrayProfile;
    NSArray                                     *arrayTags;
    UIView                                      *viewShadow;
    BOOL                                        isIdPersonNumber;
    int                                         nextPageGallery;
    IBOutlet UILabel                            *labelNomeProduto;
    IBOutlet UILabel                            *labelDescricao;
    IBOutlet OHAttributedLabel                  *OHlabelValorEsperado;
    IBOutlet UIScrollView                       *scrollViewMain;
    __unsafe_unretained IBOutlet UIButton       *buttonBid;
    __unsafe_unretained IBOutlet UITextField    *txtFieldEmail;
    __unsafe_unretained IBOutlet UITextField    *txtFieldOffer;
    __unsafe_unretained IBOutlet UITextView     *txtViewComment;
    __unsafe_unretained IBOutlet UILabel        *labelNameProfile;
    __unsafe_unretained IBOutlet UILabel        *labelCityProfile;
    __unsafe_unretained IBOutlet UILabel        *labelEmailProfile;
    __unsafe_unretained IBOutlet UIButton       *buttonGarageDetail;
    __unsafe_unretained IBOutlet UILabel        *offerLabel;
    __unsafe_unretained IBOutlet UILabel        *msgBidSentLabel;
    __unsafe_unretained IBOutlet UIView         *secondView;
    __unsafe_unretained IBOutlet UIView         *viewBidSend;
    __unsafe_unretained IBOutlet UIView         *viewBidMsg;
    IBOutlet UIView                             *garageDetailView;
    __weak IBOutlet UIView *countView;                                                
    __weak IBOutlet OHAttributedLabel *countLabel;
    UIPageControl  *PagContGallery;
    __unsafe_unretained IBOutlet UIButton *buttonEditProduct;
    __unsafe_unretained IBOutlet UIButton *buttonDeleteProduct;
    __unsafe_unretained IBOutlet UIButton *buttonReportThisGarage;
    //Gallery Images Objects.
    NSMutableArray          *productPhotos;
    UIImageView             *imageView;
    IBOutlet UIScrollView   *galleryScrollView;
    __unsafe_unretained IBOutlet UIActivityIndicatorView *activityIndicator;
    
}


@property (strong, nonatomic) id detailItem;
@property (retain, nonatomic) RKObjectManager                   *RKObjManeger;
@property (retain, nonatomic) Product                           *product;
@property (retain, nonatomic) NSArray                           *arrayGarage;
@property (retain, nonatomic) NSArray                           *arrayProfile;
@property (retain, nonatomic) NSArray                           *arrayTags;
@property (nonatomic) BOOL                                      isIdPersonNumber;

@property (retain, nonatomic) IBOutlet UILabel                  *labelNomeProduto;
@property (retain, nonatomic) IBOutlet UILabel                  *labelDescricao;
@property (retain, nonatomic) IBOutlet OHAttributedLabel        *OHlabelValorEsperado;
@property (retain, nonatomic) IBOutlet UIScrollView             *scrollViewMain;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton      *buttonBid;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField   *txtFieldEmail;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField   *txtFieldOffer;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView    *txtViewComment;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *labelNameProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *labelCityProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *labelEmailProfile;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton      *buttonGarageDetail;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *offerLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel       *msgBidSentLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *secondView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *viewBidSend;
@property (unsafe_unretained, nonatomic) IBOutlet UIView        *viewBidMsg;
@property (retain, nonatomic) IBOutlet UIView                   *garageDetailView;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet OHAttributedLabel *countLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *buttonEditProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *buttonDeleteProduct;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *buttonReportThisGarage;

//Gallery Images Objects.
@property (retain, nonatomic) NSMutableArray         *productPhotos;
@property (retain, nonatomic) UIImageView            *imageView;
@property (retain, nonatomic) UIPageControl          *PagContGallery;
@property (retain, nonatomic) IBOutlet UIScrollView  *galleryScrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)actionEmailComposer;
- (IBAction)animationBidView;
- (IBAction)textFieldEditingEnded:(id)sender;
- (void)getResourcePathGarage;
- (void)getResourcePathProfile;
- (void)getResourcePathProduct;
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
- (void)getResourcePathProduct:(NSString *)localResource;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView;

@end
