//
//  productAccountViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//
#import "productAccountViewController.h"
#import "PostProductDelegate.h"

@class PostProductDelegate;

@interface productAccountViewController ()

@property (nonatomic, strong) PostProductDelegate *postProdDelegate;

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
- (void)setupKeyboardControls;
- (void)scrollViewToTextField:(id)textField;
@end

@implementation productAccountViewController

@synthesize RKObjManeger;
@synthesize txtFieldTitle;
@synthesize txtFieldValue;
@synthesize txtFieldState;
@synthesize txtFieldCurrency;
@synthesize scrollViewPicsProduct;
@synthesize delegate;
@synthesize scrollView;
@synthesize keyboardControls;
@synthesize widthPaddingInImages;
@synthesize heightPaddingInImages;
@synthesize textViewDescription;
@synthesize viewPicsControl;
@synthesize buttonAddPics;
@synthesize product;
@synthesize buttonSaveProduct;

#define PICKERSTATE     20
#define PICKERCURRENCY  21

#define kWidthPaddingInImages 10
#define kHeightPaddingInImages 10

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Initializing the Object Manager
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    //Set SerializationMIMEType
    RKObjManeger.acceptMIMEType          = RKMIMETypeJSON;
    RKObjManeger.serializationMIMEType   = RKMIMETypeJSON;
    [self loadAttributsToComponents];
}

-(void)loadAttributsToComponents{
    
    _postProdDelegate = [[PostProductDelegate alloc] init];
    
    nsMutArrayPhotosDelegate = [[NSMutableArray alloc] init];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] 
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [txtFieldState       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldTitle       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldCurrency    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldValue       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [textViewDescription setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    txtFieldValue.keyboardType = UIKeyboardTypeDecimalPad;
    
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1200)];
    [shadowView setBackgroundColor:[UIColor blackColor]];
    [shadowView setAlpha:0];
    [viewPicsControl setAlpha:0];
    [viewPicsControl.layer setCornerRadius:5];
        
    //Menu
    UIView *tabBar = [self rotatingFooterView];
    if ([tabBar isKindOfClass:[UITabBar class]])
        ((UITabBar *)tabBar).delegate = self;
    
    self.tabBarController.delegate = self;
    
    nsMutArrayPicsProduct   = [[NSMutableArray alloc] init];
    nsArrayState    = [NSArray arrayWithObjects:NSLocalizedString(@"Avaliable", @""),
                       NSLocalizedString(@"Sold", @""), NSLocalizedString(@"notAvailable", @""), NSLocalizedString(@"invisible", @""), nil];
    
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *symbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
    NSString *code = [theLocale objectForKey:NSLocaleCurrencyCode];
        
    nsArrayCurrency = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@ - %@",code,symbol],
                       @"BRL - R$",
                       @"GBP - £",
                       @"EUR - €",
                       @"USD - $", nil];
    
    //Set Picker View State
    UIPickerView *pickerViewState = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    [pickerViewState setDelegate:self];
    [pickerViewState setTag:PICKERSTATE];
    [pickerViewState setDataSource:self];
    [pickerViewState setShowsSelectionIndicator:YES];
    [txtFieldState setInputView:pickerViewState];
    
    txtFieldState.text = NSLocalizedString(@"Avaliable", @"");
    
    //Set Picker View Currency
    UIPickerView *pickerViewCurrency = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    [pickerViewCurrency setDelegate:self];
    [pickerViewCurrency setTag:PICKERCURRENCY];
    [pickerViewCurrency setDataSource:self];
    [pickerViewCurrency setShowsSelectionIndicator:YES];
    [txtFieldCurrency setInputView:pickerViewCurrency];
    
    [txtFieldCurrency setText:[NSString stringWithFormat:@"%@ - %@",code,symbol]];
    
    //Create done button in UIPickerView
    UIToolbar       *picViewStateToolbar    = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    [picViewStateToolbar setBarStyle:UIBarStyleBlackOpaque];
    [picViewStateToolbar sizeToFit];
    NSMutableArray  *barItems               = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace              = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn                = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [picViewStateToolbar setItems:barItems animated:YES];
    
    [txtFieldState setInputAccessoryView:picViewStateToolbar];
    [txtFieldCurrency setInputAccessoryView:picViewStateToolbar];
    
    imageWidth_ = 70.0f;
    imageHeight_ = 70.0f;
    widthPaddingInImages = kWidthPaddingInImages;
    heightPaddingInImages = kHeightPaddingInImages;
    
    [self.scrollView setContentSize:CGSizeMake(320,587)];
    [self setupKeyboardControls];
    
    if (self.product != nil) {
        [self loadingProduct];
    }else {
        self.navigationItem.titleView = [GlobalFunctions getLabelTitleNavBarGeneric:UITextAlignmentCenter text:@"Add Product" width:300];
    }
}

- (void)getResourcePathProduct{
    RKObjectMapping *productMapping = [Mappings getProductMapping];
    RKObjectMapping *photoMapping = [Mappings getPhotoMapping];
    RKObjectMapping *caminhoMapping = [Mappings getCaminhoMapping];
    
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    
    //Relationship
    [photoMapping mapKeyPath:@"caminho" toRelationship:@"caminho" withMapping:caminhoMapping serialize:NO];
    
    //LoadUrlResourcePath    
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@/?idProduct=%@", self.product.idPessoa, self.product.id] objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([[objects objectAtIndex:0] isKindOfClass:[Product class]]){
        self.product = (Product *)[objects objectAtIndex:0];
        [self loadAttributsToProduct];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    UIAlertView *alV = [[UIAlertView alloc] initWithTitle:error.domain message:@"Houve um erro de comunicação com o servidor" delegate:self
                                        cancelButtonTitle:@"Ok" otherButtonTitles:@"tentar novamente", nil];
    [alV show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)loadingProduct{
    [self getResourcePathProduct];
     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.navigationItem setLeftBarButtonItem:[GlobalFunctions getIconNavigationBar:
                                               @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"]];
    [self.navigationItem setTitleView:[GlobalFunctions getLabelTitleNavBarGeneric:UITextAlignmentCenter text:[NSString stringWithFormat:@"Edit:%@",product.nome] width:300]];
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)isNumberKey:(UITextField *)textField{
    [GlobalFunctions onlyNumberKey:textField];
}

-(void)pickerDoneClicked{
    [txtFieldState resignFirstResponder];
    [txtFieldCurrency resignFirstResponder];
}

- (IBAction)animationPicsControl{
    //Limited Maximum At Pics Add Gallery
    if ([nsMutArrayPicsProduct count] == 10) 
        buttonAddPics.enabled = NO;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];
    
    if (viewPicsControl.hidden) {
        [self.scrollView insertSubview:shadowView belowSubview:viewPicsControl];
        viewPicsControl.hidden = NO;
        viewPicsControl.alpha = 1.0;
        shadowView.alpha = 0.7;
    } else {
        viewPicsControl.alpha = 0;
        shadowView.alpha = 0;
        viewPicsControl.hidden = YES;
        [shadowView removeFromSuperview];
    }
    
    [UIView commitAnimations];
}

-(IBAction)goBack:(id)sender {
    [self goToTabBarController:[[[GlobalFunctions getUserDefaults] objectForKey:@"oldTabBar"] intValue]];
}

-(void)goToTabBarController:(int)index{
    if (index == 1) index = 0;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"1" forKey:@"oldTabBar"];  
    [userDefaults setInteger:index forKey:@"activateTabBar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Get views. controllerIndex is passed in as the controller we want to go to. 
    UIView * fromView = self.view.superview;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:index] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView 
                        toView:toView 
                      duration:0.5 
                       options:(index > self.tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCrossDissolve : UIViewAnimationOptionTransitionCrossDissolve)
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.tabBarController.selectedIndex = index;
                        }
                    }];
}

//- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
//    [GlobalFunctions tabBarController:theTabBarController didSelectViewController:viewController];
//}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
    if (indexOfTab == 1 && ![[[GlobalFunctions getUserDefaults] objectForKey:@"isProductDisplayed"] boolValue]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Cancel" 
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Camera", @"Library", @"Produto Sem Foto", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        sheet.delegate = self;
        [sheet showFromTabBar:self.tabBarController.tabBar];
        return NO;
    } else {
        return YES;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [GlobalFunctions setActionSheetAddProduct:self.tabBarController clickedButtonAtIndex:buttonIndex];
}

-(IBAction)getPicsByCamera:(id)sender {
    [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeCamera];
}

-(IBAction)getPicsByPhotosAlbum:(id)sender {
    [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *imageThumb = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) 
        UIImageWriteToSavedPhotosAlbum(imageThumb, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [self addImageToScrollView:imageThumb isNew:YES];
    [picker dismissModalViewControllerAnimated:YES];
    
    if(!viewPicsControl.hidden)
        [self animationPicsControl];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary *)contextInfo {  
    if (error != NULL){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image was not saved, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)deletePicsAtGallery:(UITapGestureRecognizer*)sender {
    //if (sender.state == UIGestureRecognizerStateBegan) {
        UIImageView *imageView      = (UIImageView *)sender.view;
       
        //Remove imgViewDelete
        for (UIView *subview in [imageView subviews]) 
            if (subview.tag == 455) 
                [subview removeFromSuperview];

        NSArray *imageViews         = [scrollViewPicsProduct subviews];
        int indexOfRemovedImageView = [imageViews indexOfObject:imageView];
        
        [UIView animateWithDuration:0.75 animations: ^{
            [self reconfigureImagesAfterRemoving:imageView];
        } completion:^(BOOL finished){
            [imageView removeFromSuperview];
            [nsMutArrayPicsProduct removeObject:imageView.image];	
            [self.delegate removedImageAtIndex:indexOfRemovedImageView];
            //            if ([nsMutArrayPicsProduct count]==0) {
            //                [self showNoPhotoAdded];
            //            }
        }];
        
        if ([nsMutArrayPicsProduct count] < 11) 
            buttonAddPics.enabled = YES;
    //}
}

-(void)reconfigureImagesAfterRemoving:(UIImageView *)aImageView{
    NSArray *imageViews         = [scrollViewPicsProduct subviews];
    int indexOfRemovedImageView = [imageViews indexOfObject:aImageView];
    
    for (int viewNumber = 0; viewNumber < [imageViews count]; viewNumber ++) {
        if (viewNumber == indexOfRemovedImageView ) {  
            UIImageView * imageViewToBeRemoved= [imageViews objectAtIndex:viewNumber] ;
            [imageViewToBeRemoved setFrame:CGRectMake(imageViewToBeRemoved.frame.size.width/2+imageViewToBeRemoved.frame.origin.x,scrollViewPicsProduct.frame.size.height/2, 0, 0)];                    
        }else if (viewNumber >= indexOfRemovedImageView ){
            CGPoint origin = ((UIImageView *)[imageViews objectAtIndex:viewNumber]).frame.origin;
            origin.x = origin.x - self.widthPaddingInImages - imageWidth_;
            origin.y = self.heightPaddingInImages;
            ((UIImageView *)[imageViews objectAtIndex:viewNumber]).frame = CGRectMake(origin.x, origin.y, imageWidth_, imageHeight_);
            scrollViewPicsProduct.showsVerticalScrollIndicator = NO;
            scrollViewPicsProduct.showsHorizontalScrollIndicator = NO;
        }
    }
    
    CGSize size = scrollViewPicsProduct.contentSize;
    size.width = size.width - imageWidth_ -self.widthPaddingInImages;
    scrollViewPicsProduct.contentSize = size;
}

-(void)addImageToScrollView:(UIImage *)aImage isNew:(BOOL)isNew{
    // [self removeNoPhotoAdded];
//    if (nsMutArrayPicsProduct == nil) {
        //[self displayImages:[NSArray arrayWithObject:aImage]];
//    }else{
        [nsMutArrayPicsProduct addObject:aImage];
        
        UIImageView *picViewAtGallery       = [[UIImageView alloc] initWithImage:aImage];
        picViewAtGallery.frame = CGRectMake(scrollViewPicsProduct.contentSize.width+7 , self.heightPaddingInImages, imageWidth_, imageHeight_);
        [scrollViewPicsProduct addSubview:picViewAtGallery];
        [picViewAtGallery setUserInteractionEnabled:NO];
        
        UploadImageDelegate *uplImageDelegate = [[UploadImageDelegate alloc] init];
        [nsMutArrayPhotosDelegate addObject:uplImageDelegate];
        [uplImageDelegate setImageView:picViewAtGallery];
        [uplImageDelegate setButtonSaveProduct:buttonSaveProduct];
    
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletePicsAtGallery:)];
        [tapGesture setNumberOfTapsRequired:2];
        
        UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:uplImageDelegate action:@selector(deletePhoto)];
        [tapGesture setNumberOfTapsRequired:2];
        
        UILongPressGestureRecognizer * longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(animePicsGallery:)];
        
        
        [uplImageDelegate.imageView addGestureRecognizer:tapGesture];
        [uplImageDelegate.imageView addGestureRecognizer:tapGesture2];
        [uplImageDelegate.imageView addGestureRecognizer:longGesture];

        
        
        
        [uplImageDelegate setScrollViewPicsProduct:scrollViewPicsProduct];
        
        CGSize size = scrollViewPicsProduct.contentSize;
        size.width = size.width + imageWidth_ + self.widthPaddingInImages;
        scrollViewPicsProduct.contentSize = size;
        //scrollViewPicsProduct.showsVerticalScrollIndicator = NO;
        //scrollViewPicsProduct.showsHorizontalScrollIndicator = NO;
        //scrollViewPicsProduct.scrollsToTop = YES;

        if(isNew)
            [uplImageDelegate uploadPhotos:nsMutArrayPicsProduct];

}


-(void)animePicsGallery:(UILongPressGestureRecognizer *)sender{
    //if (sender.state == UIGestureRecognizerStateBegan) {

    if (sender.state == UIGestureRecognizerStateBegan) {
        for (UIImageView * imgV in scrollViewPicsProduct.subviews) {
            //if (imgV.)
                [imgV setAlpha:0.2];
        }
    }
    
    else if (sender.state == UIGestureRecognizerStateEnded){

        for (UIImageView *imgV in scrollViewPicsProduct.subviews) {
            [imgV setAlpha:1.0];
        }
    }
    //}

}


//-(void)displayImages:(NSArray *)aImageList{
//    nsMutArrayPicsProduct = [NSMutableArray arrayWithArray:aImageList];
//    [self placeImages:nsMutArrayPicsProduct];
//}





//-(void)placeImages:(NSArray *)aImageList{
//    scrollViewPicsProduct.contentSize =CGSizeZero;
//    if ([aImageList count] > 0) {
//        //[self removeNoPhotoAdded];
//    }
//    for (int imageNumber =0 ; imageNumber < [aImageList count]; imageNumber ++) {
//        UIImageView * imageView = [[UIImageView alloc] initWithImage:[aImageList objectAtIndex:imageNumber]];
//        imageView.frame = CGRectMake(imageNumber * (imageWidth_ + self.widthPaddingInImages), self.heightPaddingInImages, imageWidth_, imageHeight_);
//        [scrollViewPicsProduct addSubview:imageView];
//        [imageView setUserInteractionEnabled:YES];
//        
//        
//        //Esse Metodo vai entrar quando for atualizacão do produto, neste caso eu vou pegar os caminhos de deletes do objeto produto que vier.
//        
//        
//        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//        [tapGesture setNumberOfTapsRequired:2];
//        
////        UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:uplImageDelegate action:@selector(deletePhoto)];
////        [tapGesture setNumberOfTapsRequired:2];
//        
//        UILongPressGestureRecognizer * longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(animePicsGallery:)];
//        
//        [imageView addGestureRecognizer:tapGesture];
//       // [imageView addGestureRecognizer:tapGesture2];
//        [imageView addGestureRecognizer:longGesture];
//
//        
//        
//        
//        CGSize size = scrollViewPicsProduct.contentSize;
//        size.width = size.width + imageWidth_ + self.widthPaddingInImages;
//        scrollViewPicsProduct.contentSize = size;
//        scrollViewPicsProduct.showsVerticalScrollIndicator = NO;
//        scrollViewPicsProduct.showsHorizontalScrollIndicator = NO;
//    }
//}

- (void)getTypeCameraOrPhotosAlbum:(UIImagePickerControllerSourceType)type{
    
    //check presence of a camera:
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType = type;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Allow editing of image ?
        imagePicker.allowsImageEditing = NO;
        
        // Show image picker
        [self presentModalViewController:imagePicker animated:YES];	
    }    
}

-(IBAction)saveProduct{
    if ([self validateForm]) {
        [txtFieldValue resignFirstResponder];
        if (self.product == nil) {
            NSMutableDictionary *prodParams = [[NSMutableDictionary alloc] init];
            
            //get idEstado indice
            int idEstado = [nsArrayState indexOfObject:txtFieldState.text] + 1;
            
            //User and password params
            NSString *idPerson = [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"];
            [prodParams setObject:idPerson                      forKey:@"idPessoa"];
            [prodParams setObject:txtFieldValue.text            forKey:@"valorEsperado"];
            [prodParams setObject:txtFieldTitle.text            forKey:@"nome"];
            [prodParams setObject:textViewDescription.text      forKey:@"descricao"];
            [prodParams setObject:[NSString stringWithFormat:@"%i", idEstado]
                           forKey:@"idEstado"];
            [prodParams setObject:idPerson                      forKey:@"idUser"];
            [prodParams setObject:@""                           forKey:@"categorias"];
            [prodParams setObject:@""                           forKey:@"newPhotos"];
            [prodParams setObject:[txtFieldCurrency.text
                                   substringToIndex:3]          forKey:@"currency"];

            [_postProdDelegate postProduct:prodParams];
            [self initProgressHUDSaveProduct];
        }
    }
}

- (void)initProgressHUDSaveProduct {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.labelFont = [UIFont fontWithName:@"Droid Sans" size:14];
	HUD.delegate = self;
	HUD.labelText = @"Saving";
	HUD.color = [UIColor colorWithRed:219.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
    HUD.dimBackground = YES;
    
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (void)myProgressTask {
	// This just increases the progress indicator in a loop
    float progress = 0.0f;
    
    int count = 0;
    while (!_postProdDelegate.isLoadingDone) {
		progress += 0.01f;
		HUD.progress = progress;
        if (progress > 1) progress = 0.0f;
		usleep(30000);
        count++;
        if (count > 200){
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconDeletePicsAtGalleryProdAcc.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"Fail! Check your connection.";
            sleep(2);
            break;
        }
	}
    
    if (_postProdDelegate.isLoadingDone) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"Completed";
        sleep(1);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"YES" forKey:@"isProductRecorded"];
        [userDefaults setBool:NO forKey:@"isProductDisplayed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self newProductFinished];
    }
}

-(BOOL)validateForm{
    BOOL isValid = YES;

    if ([txtFieldTitle.text length] <= 2) {
        [txtFieldTitle setValue:[UIColor redColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
        [txtFieldTitle setPlaceholder:@"Hey, your product must have a name!"];
        isValid = NO;
    } 
    
    if ([txtFieldValue.text length] == 0) {
        [txtFieldValue setValue:[UIColor redColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
        isValid = NO;
    } 
    
    return isValid;
}

-(void)newProductFinished{
    [self goToTabBarController:2];
    self.view = nil;
    [self viewDidLoad];
    [scrollView setContentOffset:CGPointZero animated:NO];
}

-(void)loadAttributsToProduct{
    self.txtFieldTitle.text = [product nome];
    self.txtFieldValue.text = [product valorEsperado];
    self.textViewDescription.text = [product descricao];
    
    @try {
        for (int i=0; i < [[product fotos] count]; i++) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",
                                               [[[[[product fotos] objectAtIndex:i] caminho] objectAtIndex:0] icon]]];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [self addImageToScrollView:image isNew:NO];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if(pickerView.tag == PICKERSTATE)
        txtFieldState.text = [NSString stringWithFormat:@"%@", (NSString *)[nsArrayState objectAtIndex:row]];
    else 
        txtFieldCurrency.text = [NSString stringWithFormat:@"%@", (NSString *)[nsArrayCurrency objectAtIndex:row]];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView.tag == PICKERSTATE)
        return nsArrayState.count;
    else 
        return nsArrayCurrency.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView.tag == PICKERSTATE)
        return [nsArrayState objectAtIndex:row];
    else 
        return [nsArrayCurrency objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {    
    return 300;
}

/* Setup the keyboard controls BSKeyboardControls.h */
- (void)setupKeyboardControls
{
    // Initialize the keyboard controls
    self.keyboardControls = [[BSKeyboardControls alloc] init];
    
    // Set the delegate of the keyboard controls
    self.keyboardControls.delegate = self;
    
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    
    self.keyboardControls.textFields = [NSArray arrayWithObjects:
                                        txtFieldState, txtFieldTitle,textViewDescription, txtFieldCurrency, txtFieldValue, nil];
    
    // Set the style of the bar. Default is UIBarStyleBlackTranslucent.
    self.keyboardControls.barStyle = UIBarStyleBlackTranslucent;
    
    // Set the tint color of the "Previous" and "Next" button. Default is black.
    self.keyboardControls.previousNextTintColor = [UIColor blackColor];
    
    // Set the tint color of the done button. Default is a color which looks a lot like the original blue color for a "Done" butotn
    self.keyboardControls.doneTintColor = [UIColor colorWithRed:34.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    // Set title for the "Previous" button. Default is "Previous".
    self.keyboardControls.previousTitle = @"Previous";
    
    // Set title for the "Next button". Default is "Next".
    self.keyboardControls.nextTitle = @"Next";
    
    // Add the keyboard control as accessory view for all of the text fields
    // Also set the delegate of all the text fields to self
    for (id textField in self.keyboardControls.textFields)
    {
        if ([textField isKindOfClass:[UITextField class]])
        {
            ((UITextField *) textField).inputAccessoryView = self.keyboardControls;
            ((UITextField *) textField).delegate = self;
        }
        else if ([textField isKindOfClass:[UITextView class]])
        {
            ((UITextView *) textField).inputAccessoryView = self.keyboardControls;
            ((UITextView *) textField).delegate = self;
        }
    }
}

/* Scroll the view to the active text field */
- (void)scrollViewToTextField:(id)textField
{
    UIScrollView* v = (UIScrollView*) self.scrollView;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:v];

    rc.size.height = 360;
    
    [self.scrollView scrollRectToVisible:rc animated:YES];
}

#pragma mark -
#pragma mark BSKeyboardControls Delegate

/* 
 * The "Done" button was pressed
 * We want to close the keyboard
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [controls.activeTextField resignFirstResponder];
}

/* Either "Previous" or "Next" was pressed
 * Here we usually want to scroll the view to the active text field
 * If we want to know which of the two was pressed, we can use the "direction" which will have one of the following values:
 * KeyboardControlsDirectionPrevious        "Previous" was pressed
 * KeyboardControlsDirectionNext            "Next" was pressed
 */
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    [textField becomeFirstResponder];
    [self scrollViewToTextField:textField];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([GlobalFunctions onlyNumberKey:string])
        return YES;
    else
        return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.keyboardControls.textFields containsObject:textField])
        self.keyboardControls.activeTextField = textField;
    [self scrollViewToTextField:textField];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.keyboardControls.textFields containsObject:textView])
        self.keyboardControls.activeTextField = textView;
    [self scrollViewToTextField:textView];
}

-(IBAction)textFieldEditingEnded:(id)sender{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [sender resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
   if (![[[GlobalFunctions getUserDefaults] objectForKey:@"isProductDisplayed"] boolValue]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:@"isProductDisplayed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        int action = [[[GlobalFunctions getUserDefaults] objectForKey:@"controlComponentsAtFirstDisplay"] intValue];
        
        if (action == 0)
            [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeCamera];
        else if (action == 1)
            [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
}

- (void)viewDidUnload
{
    textViewDescription = nil;
    [self setTextViewDescription:nil];
    viewPicsControl = nil;
    [self setViewPicsControl:nil];
    buttonAddPics = nil;
    [self setButtonAddPics:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end