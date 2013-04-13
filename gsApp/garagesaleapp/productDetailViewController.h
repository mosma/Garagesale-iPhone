//
// productDetailViewController.h
// garagesaleapp
//
// Created by Tarek Jradi on 08/01/12.
// Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "galleryScrollViewController.h"
#import "RestKit/RKJSONParserJSONKit.h"
#import "garageAccountViewController.h"
#import "sharePopOverViewController.h"
#import "FPPopoverController.h"
#import "OHAttributedLabel.h"
#import "viewHelper.h"
#import "GSCategory.h"
#import "Bid.h"

@interface productDetailViewController : MasterViewController <UIScrollViewDelegate,
                                                                RKObjectLoaderDelegate,
                                                                UITabBarDelegate,
                                                                UIPopoverControllerDelegate,
                                                                UIAlertViewDelegate> {
    
    RKObjectManager *RKObjManeger;
    Product *product;
    NSArray *arrayGarage;
    NSArray *arrayProfile;
    NSArray *arrayTags;
    UIView *viewShadow;
    BOOL isIdPersonNumber;
    int nextPageGallery;
    __weak IBOutlet UILabel *labelNomeProduto;
    __weak IBOutlet UILabel *labelDescricao;
    __weak IBOutlet OHAttributedLabel *OHlabelValorEsperado;
    __weak IBOutlet UIScrollView *scrollViewMain;
    __weak IBOutlet UIButton *buttonBid;
    __weak IBOutlet UIButton *buttonCancelBid;
    __weak IBOutlet UIButton *buttonOffer;
    __weak IBOutlet UIButton *buttonBack;
    __weak IBOutlet UITextField *txtFieldEmail;
    __weak IBOutlet UITextField *txtFieldOffer;
    __weak IBOutlet UITextView *txtViewComment;
    __weak IBOutlet UILabel *labelNameProfile;
    __weak IBOutlet UILabel *labelCityProfile;
    __weak IBOutlet UILabel *labelEmailProfile;
    IBOutlet UIButton *buttonGarageDetail;
    __weak IBOutlet UILabel *msgBidSentLabel;
    __weak IBOutlet UIView *secondView;
    __weak IBOutlet UIView *viewBidSend;
    __weak IBOutlet UIView *viewBidMsg;
    __weak IBOutlet UIView *viewControl;
    __weak IBOutlet UIView *viewReport;
    __weak IBOutlet UIView *garageDetailView;
    __weak IBOutlet UIView *countView;
    __weak IBOutlet OHAttributedLabel *countLabel;
    UIPageControl *PagContGallery;
    __weak IBOutlet UIButton *buttonEditProduct;
    __weak IBOutlet UIButton *buttonDeleteProduct;
    __weak IBOutlet UIButton *buttonReportThisGarage;
    //Gallery Images Objects.
    UIImageView *imageView;
    __weak IBOutlet UIScrollView *galleryScrollView;
    
    __weak IBOutlet UILabel *labelEmail;
    __weak IBOutlet UILabel *labelOffer;
    __weak IBOutlet UILabel *labelAskSomething;
    __weak IBOutlet UILabel *labelCongrats;
    __weak IBOutlet UILabel *labelBidSent;
    viewHelper *vH;
}


@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) RKObjectManager *RKObjManeger;
@property (strong, nonatomic) Product *product;
@property (strong, nonatomic) NSArray *arrayGarage;
@property (strong, nonatomic) NSArray *arrayProfile;
@property (strong, nonatomic) NSArray *arrayTags;
@property (nonatomic) BOOL isIdPersonNumber;

@property (weak, nonatomic) IBOutlet UILabel *labelNomeProduto;
@property (weak, nonatomic) IBOutlet UILabel *labelDescricao;
@property (weak, nonatomic) IBOutlet OHAttributedLabel *OHlabelValorEsperado;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIButton *buttonBid;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancelBid;
@property (weak, nonatomic) IBOutlet UIButton *buttonOffer;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldOffer;
@property (weak, nonatomic) IBOutlet UITextView *txtViewComment;
@property (weak, nonatomic) IBOutlet UILabel *labelNameProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelCityProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelEmailProfile;
@property (strong, nonatomic) IBOutlet UIButton *buttonGarageDetail;
@property (weak, nonatomic) IBOutlet UILabel *msgBidSentLabel;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *viewBidSend;
@property (weak, nonatomic) IBOutlet UIView *viewBidMsg;
@property (weak, nonatomic) IBOutlet UIView *viewControl;
@property (weak, nonatomic) IBOutlet UIView *viewReport;
@property (weak, nonatomic) IBOutlet UIView *garageDetailView;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet OHAttributedLabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonEditProduct;
@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteProduct;
@property (weak, nonatomic) IBOutlet UIButton *buttonReportThisGarage;

//Gallery Images Objects.
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIPageControl *PagContGallery;
@property (weak, nonatomic) IBOutlet UIScrollView *galleryScrollView;

@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelOffer;
@property (weak, nonatomic) IBOutlet UILabel *labelAskSomething;
@property (weak, nonatomic) IBOutlet UILabel *labelCongrats;
@property (weak, nonatomic) IBOutlet UILabel *labelBidSent;

- (IBAction)animationBidView;
- (IBAction)textFieldEditingEnded:(id)sender;
- (void)getResourcePathGarage;
- (void)getResourcePathProfile;
- (void)getResourcePathProduct;
- (IBAction)gotoGarageDetailVC;
- (IBAction)gotoUserProductTableVC;
- (void)gotoProductTableVC:(UIButton *)sender;
- (IBAction)gotoProductAccountVC:(id)sender;
- (void)setLoadAnimation;
- (void)hideMsgBidSent;
- (IBAction)isNumberKey:(UITextField *)textField;
- (IBAction)bidPost:(id)sender;
- (void)loadAttribsToComponents:(BOOL)isFromLoadObject;
- (void)getResourcePathProduct:(NSString *)localResource;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView;

@end