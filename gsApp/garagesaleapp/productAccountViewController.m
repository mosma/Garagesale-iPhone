//
//  productAccountViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//
#import "productAccountViewController.h"
#import "PostProductDelegate.h"
#import "photosGallery.h"

@class PostProductDelegate;

@interface productAccountViewController ()
@property (nonatomic, strong) PostProductDelegate *postProdDelegate;
@property (nonatomic, strong) photosGallery *gallery;
@end

@implementation productAccountViewController

@synthesize RKObjManeger;
@synthesize txtFieldTitle;
@synthesize txtFieldValue;
@synthesize txtFieldState;
@synthesize txtFieldCurrency;
@synthesize scrollViewPicsProduct;
@synthesize scrollView;
@synthesize textViewDescription;
@synthesize viewPicsControl;
@synthesize buttonAddPics;
@synthesize product;
@synthesize buttonDeleteProduct;
@synthesize gallery;
@synthesize countUploaded;
@synthesize buttonSaveProduct;

#define PICKERSTATE     20
#define PICKERCURRENCY  21

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Initializing the Object Manager
    RKObjManeger = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    //Set SerializationMIMEType
    [RKObjManeger setAcceptMIMEType:RKMIMETypeJSON];
    [RKObjManeger setSerializationMIMEType:RKMIMETypeJSON];
    
    IS_IPHONE_5 ? [self.view setFrame:CGRectMake(0, 0, 320, 455)] : [self.view setFrame:CGRectMake(0, 0, 320, 367)];
    
    [self loadAttributsToComponents];
}

-(void)loadAttributsToComponents{
    
    //initialize the i18n
    [self.buttonSaveProduct setTitle:NSLocalizedString(@"save", @"") forState:UIControlStateNormal];
    [self.txtFieldTitle setPlaceholder:NSLocalizedString(@"title", @"")];
    [self.buttonDeleteProduct setTitle:NSLocalizedString(@"deleteThisProduct", @"") forState:UIControlStateNormal];
    
    //theme information
    [self.buttonSaveProduct.titleLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:14]];
    [self.buttonDeleteProduct.titleLabel setFont:[UIFont fontWithName:@"Droid Sans" size:14]];

    
    _postProdDelegate = [[PostProductDelegate alloc] init];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] 
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [txtFieldState       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldTitle       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldCurrency    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldValue       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [textViewDescription setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    txtFieldValue.keyboardType = UIKeyboardTypeDecimalPad;
    
//    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1200)];
//    [shadowView setBackgroundColor:[UIColor blackColor]];
//    [shadowView setAlpha:0];
    [viewPicsControl setAlpha:0];
    [viewPicsControl.layer setCornerRadius:5];
    
    [buttonAddPics setEnabled:NO];
    
    //Menu
//    UIView *tabBar = [self rotatingFooterView];
//    if ([tabBar isKindOfClass:[UITabBar class]])
//        ((UITabBar *)tabBar).delegate = self;
//    tabBar = nil;
    
    gallery = [[photosGallery alloc] init];
    [gallery setProdAccount:self];
    [gallery setScrollView:self.scrollViewPicsProduct];
    
    [txtFieldState       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    waiting = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 200, 40)];
    [waiting setFont:[UIFont fontWithName:@"Droid Sans" size:12]];
    [waiting setBackgroundColor:[UIColor clearColor]];
    [waiting setTextColor:[UIColor colorWithRed:152.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.f]];
    [waiting setText:NSLocalizedString(@"waiting...", @"")];    

    nsArrayState    = [NSArray arrayWithObjects:NSLocalizedString(@"Avaliable", @""),
                                                NSLocalizedString(@"Sold", @""),
                                                NSLocalizedString(@"notAvailable", @""),
                                                NSLocalizedString(@"invisible", @""), nil];
    
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *symbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
    NSString *code = [theLocale objectForKey:NSLocaleCurrencyCode];
        
    NSString *currencyDefault = [NSString stringWithFormat:@"%@ - %@",code,symbol];
    
    nsArrayCurrency = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects: currencyDefault,
                                                             @"BRL - R$",
                                                             @"GBP - £",
                                                             @"EUR - €",
                                                             @"USD - $", nil]];
    //remove repeat currency.
    for (int i=1;  i < [nsArrayCurrency count]; i++)
        if ([[nsArrayCurrency objectAtIndex:i] isEqualToString:currencyDefault])
            [nsArrayCurrency removeObjectAtIndex:i];

    theLocale = nil;
    symbol = nil;
    code = nil;
    
    //Set Picker View State
    UIPickerView *pickerViewState = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    [pickerViewState setDelegate:self];
    [pickerViewState setTag:PICKERSTATE];
    [pickerViewState setDataSource:self];
    [pickerViewState setShowsSelectionIndicator:YES];
    [txtFieldState setInputView:pickerViewState];
    [txtFieldState setTag:PICKERSTATE];
    txtFieldState.delegate = self;
    
    pickerViewState = nil;
    
    if (self.product != nil)
        txtFieldState.text = [nsArrayState objectAtIndex:[product.idEstado intValue]-1];
    else
        txtFieldState.text = NSLocalizedString(@"Avaliable", @"");
        
    //Set Picker View Currency
    UIPickerView *pickerViewCurrency = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    [pickerViewCurrency setDelegate:self];
    [pickerViewCurrency setTag:PICKERCURRENCY];
    [pickerViewCurrency setDataSource:self];
    [pickerViewCurrency setShowsSelectionIndicator:YES];
    [txtFieldCurrency setInputView:pickerViewCurrency];
    [txtFieldCurrency setTag:PICKERCURRENCY];
    [txtFieldCurrency setDelegate:self];
    
    pickerViewCurrency = nil;
    
    if (self.product != nil)
        [txtFieldCurrency setText:[NSString stringWithFormat:@"%@ - %@", product.currency,
                                   [GlobalFunctions getCurrencyByCode:product.currency]]];
    else
        [txtFieldCurrency setText:currencyDefault];
    
    //Create done button in UIPickerView
    UIToolbar       *picViewStateToolbar    = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    [picViewStateToolbar setBarStyle:UIBarStyleBlackOpaque];
    [picViewStateToolbar sizeToFit];
    NSMutableArray  *barItems               = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace              = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                               UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn                = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                               UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [picViewStateToolbar setItems:barItems animated:YES];
    
    [txtFieldState setInputAccessoryView:picViewStateToolbar];
    [txtFieldCurrency setInputAccessoryView:picViewStateToolbar];
   
    pickerViewState = nil;
    barItems = nil;
    doneBtn = nil;
    currencyDefault = nil;

    [self.scrollView setContentSize:CGSizeMake(320,587)];
    [self setupKeyboardFields];
    
    if (self.product != nil) {
        [buttonDeleteProduct setHidden:NO];
        self.trackedViewName = [NSString stringWithFormat:@"/%@/%@/edit", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"], self.product.id];
        if ([self.product.fotos count] > 0)
            [scrollViewPicsProduct addSubview:waiting];
        [self loadingProduct];
    }else {
        [self getResourcePathPhotoReturnNotSaved];
        self.trackedViewName = [NSString stringWithFormat:@"/%@/new", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]];
        self.navigationItem.titleView = [GlobalFunctions getLabelTitleNavBarGeneric: UITextAlignmentCenter
                                                                               text: NSLocalizedString(@"menu-add-product", nil)
                                                                              width: 300];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    return YES;
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
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@/?idProduct=%@", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"], self.product.id] objectMapping:productMapping delegate:self];
    
    productMapping = nil;
    photoMapping = nil;
    caminhoMapping = nil;
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathPhotoReturnEdit{
    RKObjectMapping *photoReturnEdit = [Mappings getPhotosByIdProduct];

    //LoadUrlResourcePath
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/photo/?idProduct=%i&token=%@",
                                             [self.product.id intValue], [[GlobalFunctions getUserDefaults] objectForKey:@"token"] ]
                              objectMapping:photoReturnEdit delegate:self];
    photoReturnEdit = nil;
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathPhotoReturnNotSaved{
    [scrollViewPicsProduct addSubview:waiting];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    RKObjectMapping *photoReturnEdit = [Mappings getPhotosByIdProduct];
    
    //LoadUrlResourcePath
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/photo/?token=%@",
                                             [[GlobalFunctions getUserDefaults] objectForKey:@"token"] ]
                              objectMapping:photoReturnEdit delegate:self];
    photoReturnEdit = nil;
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    @try {
        if ([objects count] == 0){
            [self removeWaiting];
            [buttonAddPics setEnabled:YES];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[Product class]]){
            self.product = nil;
            self.product = (Product *)[objects objectAtIndex:0];
            [self loadAttributsToProduct];
            if ([self.product.fotos count] > 0)
                [self getResourcePathPhotoReturnEdit];
            else
                [buttonAddPics setEnabled:YES];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[PhotoReturn class]]){
            [buttonSaveProduct setUserInteractionEnabled:NO];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^(void) {
                [self loadAttributsToPhotos:objects];
            });
            queue = nil;
        }
    }@catch (NSException *exception) {
        NSLog(@"%@", exception.name);
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    [buttonAddPics setEnabled:YES];
    [self removeWaiting];
    [self.view setUserInteractionEnabled:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)loadingProduct{
    UIBarButtonItem *barItem = [GlobalFunctions getIconNavigationBar:@selector(backPage)
                                viewContr:self
                               imageNamed:@"btBackNav.png" rect:CGRectMake(0, 0, 40, 30)];
    [self getResourcePathProduct];
    [self.navigationItem setLeftBarButtonItem:barItem];
    
    [self.navigationItem setTitleView:[GlobalFunctions getLabelTitleNavBarGeneric:UITextAlignmentCenter
                                                                             text:product.nome
                                                                            width:200]];
    barItem = nil;
}

-(void)removeWaiting{
    [waiting removeFromSuperview];
    [waiting setHidden:YES];
}

-(void)backPage{
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self releaseMemoryCache];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)isNumberKey:(UITextField *)textField{
    [GlobalFunctions onlyNumberKey:textField.text];
}

-(BOOL)isValidMoneyValue:(NSString*)moneyValue {
    NSString *regExPattern = @"^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:.[0-9]{2})?$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:moneyValue options:0 range:NSMakeRange(0, [moneyValue length])];
    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else
        return YES;
}

-(void)pickerDoneClicked{
    [txtFieldState resignFirstResponder];
    [txtFieldCurrency resignFirstResponder];
}

- (IBAction)animationPicsControl{
    //Limited Maximum At Pics Add Gallery
    UIActionSheet *gallerySheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"keyboard-cancel-btn", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"sheet-camera-item", nil),
                                                                NSLocalizedString(@"sheet-library-item", nil),
                                                                nil];
    gallerySheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    gallerySheet.delegate = self;
    [gallerySheet showInView:self.view];
    [gallerySheet showFromTabBar:self.tabBarController.tabBar];
    [gallerySheet setTag:99];
    gallerySheet = nil;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.product != nil && actionSheet.tag != 99)
         [GlobalFunctions setActionSheetAddProduct:self.tabBarController clickedButtonAtIndex:buttonIndex];
    else {
        if (buttonIndex == 0)
            [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeCamera];
        else if (buttonIndex == 1)
            [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypePhotoLibrary];
        else if (buttonIndex == 2)
            ;
    }
}

-(IBAction)getPicsByCamera:(id)sender {
    [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeCamera];
}

-(IBAction)getPicsByPhotosAlbum:(id)sender {
    [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *newImage = originalImage;
    
    int maxSize = 900;
    float w = originalImage.size.width;
    float h = originalImage.size.height;
    if (originalImage.size.width > maxSize || originalImage.size.height > maxSize) {
        float ratio;
        if (w > h)
            ratio = w/h;
        else
            ratio = h/w;
        
        CGSize newSize;
        if (w > h)
            newSize = CGSizeMake(maxSize, roundf(maxSize/ratio));
        else
            newSize = CGSizeMake(roundf(maxSize/ratio), maxSize);

        UIGraphicsBeginImageContext(newSize);
        [originalImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera)
        UIImageWriteToSavedPhotosAlbum(originalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    [scrollViewPicsProduct setFrame:CGRectMake(0,
                                               scrollViewPicsProduct.frame.origin.y,
                                               scrollViewPicsProduct.frame.size.width,
                                               scrollViewPicsProduct.frame.size.height)];

    [gallery addImageToScrollView:newImage
                      photoReturn:nil
                          product:self.product
                     isFromPicker:YES];
    [picker dismissModalViewControllerAnimated:YES];
    originalImage = nil;
    newImage = nil;
    
    if(!viewPicsControl.hidden)
        [self animationPicsControl];
}

-(IBAction)deleteProduct:(id)sender {
    if (isReachability) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"delete-product-title", nil)
                                                         message:NSLocalizedString(@"delete-product-desc", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"delete-product-btn1", nil)
                                               otherButtonTitles:NSLocalizedString(@"delete-product-btn2", nil), nil];
        [alertV show];
        alertV = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [self.view setUserInteractionEnabled:NO];
            [[RKClient sharedClient] delete:
             [NSString stringWithFormat:@"/product/%i?token=%@&garage=%@",
              [self.product.id intValue] ,
              [[GlobalFunctions getUserDefaults] valueForKey:@"token"],
              [[GlobalFunctions getUserDefaults] valueForKey:@"garagem"]] delegate:self];
            break;
        default:
            break;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary *)contextInfo {  
    if (error != NULL){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"image-upload-error-title", nil)
                                                        message: NSLocalizedString(@"image-upload-error-imgerror", nil)
                                                       delegate:nil
                                              cancelButtonTitle: NSLocalizedString(@"image-upload-error-btn1", nil)
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([request isGET]) {
        // Handling GET /foo.xml
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
            if (self.product == nil){
                [buttonAddPics setEnabled:YES];
                [self removeWaiting];
            }
        }
    } else if ([request isPOST]) {
        // Handling POST /other.json
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
    } else if ([request isDELETE]) {
        // Handling DELETE /missing_resource.txt
        if (self.product != nil) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"YES" forKey:@"reloadGarage"];
            [userDefaults synchronize];
            userDefaults = nil;
            [self.navigationController popToRootViewControllerAnimated:YES];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^(void) {
                [self releaseMemoryCache];
            });
            queue = nil;
        }
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

- (void)getTypeCameraOrPhotosAlbum:(UIImagePickerControllerSourceType)type{
    //check presence of a camera:
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        [imagePicker setSourceType:type];
        
        // Delegate is self
        [imagePicker setDelegate:self];
        
        // Allow editing of image ?
         [imagePicker setWantsFullScreenLayout:YES];
        //imagePicker.allowsEditing = YES;

        //[imagePicker.cameraOverlayView addSubview:libraryButton];
        
        // Show image picker
        [self presentModalViewController:imagePicker animated:YES];	
    } 
}

-(IBAction)saveProduct{
    if ([self validateForm]) {
        [txtFieldValue resignFirstResponder];
        NSMutableDictionary *prodParams = [[NSMutableDictionary alloc] init];
        
        //get idEstado indice
        int idEstado = [nsArrayState indexOfObject:txtFieldState.text] + 1;
        
        //User and password params
        NSString *idPerson = [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"];

        [prodParams setObject:idPerson                      forKey:@"idPessoa"];
        

        if (txtFieldValue.text.length > 7)
            [txtFieldValue setText:[txtFieldValue.text substringWithRange:NSMakeRange(0, 7)]];
        if (txtFieldTitle.text.length > 80)
            [txtFieldTitle setText:[txtFieldTitle.text substringWithRange:NSMakeRange(0, 80)]];
        
        [prodParams setObject:txtFieldValue.text            forKey:@"valorEsperado"];
        [prodParams setObject:txtFieldTitle.text            forKey:@"nome"];
        [prodParams setObject:textViewDescription.text      forKey:@"descricao"];
        [prodParams setObject:[NSString stringWithFormat:@"%i", idEstado]
                       forKey:@"idEstado"];
        [prodParams setObject:idPerson                      forKey:@"idUser"];
        [prodParams setObject:@""                           forKey:@"categorias"];

        
        for (int x=0;  x < [gallery.nsMutArrayNames count]; x++)
            if ([(NSString *)[gallery.nsMutArrayNames objectAtIndex:x] isEqualToString:@""])
                [gallery.nsMutArrayNames removeObjectAtIndex:x];
        
        NSString *dictPhot = [gallery.nsMutArrayNames JSONRepresentation];
        [prodParams setObject:dictPhot                           forKey:@"newPhotos"];

        [prodParams setObject:[txtFieldCurrency.text
                               substringToIndex:3]          forKey:@"currency"];

        if (self.product != nil){
            [prodParams setObject:[self.product.id stringValue] forKey:@"id"];
            [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Product"
                                                             withAction:@"Edit"
                                                              withLabel:@"Product Modified"
                                                              withValue:nil];
        }else{
            [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"Product"
                                                             withAction:@"Register"
                                                              withLabel:@"New Product Registered"
                                                              withValue:nil];
        }
        if (![super isReachability])
            [_postProdDelegate setIsSaveProductFail:YES];
        else{
            [_postProdDelegate postProduct:prodParams];
            [self setEnableButtonSave:NO];
        }
        prodParams = nil;
        dictPhot = nil;
        [self initProgressHUDSaveProduct];
    }
}

-(void)setEnableButtonSave:(BOOL)enable{
    if (enable) {
        [buttonSaveProduct setUserInteractionEnabled:YES];
        [buttonSaveProduct setAlpha:1.0f];
    }else{
        [buttonSaveProduct setUserInteractionEnabled:NO];
        [buttonSaveProduct setAlpha:0.3f];
    }
}

- (void)initProgressHUDSaveProduct {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    
    [HUD setMode:MBProgressHUDModeAnnularDeterminate];
    [HUD setLabelFont:[UIFont fontWithName:@"Droid Sans" size:14]];
	[HUD setDelegate:self];
	[HUD setLabelText:NSLocalizedString(@"image-uploading", nil)];
	[HUD setColor:[UIColor blackColor]];
    [HUD setDimBackground:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (void)myProgressTask {
	// This just increases the progress indicator in a loop
    float progress = 0.0f;
    
    int count = 0;
    while (!_postProdDelegate.isSaveProductDone) {
		progress += 0.01f;
		[HUD setProgress:progress];
        if (progress > 1) progress = 0.0f;
		usleep(30000);
        count++;
        if (_postProdDelegate.isSaveProductFail)
            break;
	}
    
    if (_postProdDelegate.isSaveProductFail){
        [HUD setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconDeletePicsAtGalleryProdAcc.png"]]];
        [HUD setMode:MBProgressHUDModeCustomView];
        [HUD setLabelText:NSLocalizedString(@"image-upload-error-check", nil)];
        sleep(2);
    }else if (_postProdDelegate.isSaveProductDone && !_postProdDelegate.isSaveProductFail) {
        [HUD setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]]];
        [HUD setMode:MBProgressHUDModeCustomView];
        [HUD setLabelText: @"Completed"];
        sleep(1);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"YES" forKey:@"reloadGarage"];
        [userDefaults synchronize];
        userDefaults = nil;

        [[self.tabBarController.viewControllers objectAtIndex:2] popToRootViewControllerAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self newProductFinished:(self.product == nil)];
        });
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self setEnableButtonSave:YES];
    _postProdDelegate.isSaveProductFail = NO;
}

-(BOOL)validateForm{
    BOOL isValid = YES;
    if ([txtFieldTitle.text length] <= 2) {
        [txtFieldTitle setValue:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                     forKeyPath:@"_placeholderLabel.textColor"];
        [txtFieldTitle setPlaceholder: NSLocalizedString(@"form-error-product-name", nil)];
        isValid = NO;
    } 
    if ([txtFieldValue.text length] == 0) {
        [txtFieldValue setValue:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                     forKeyPath:@"_placeholderLabel.textColor"];
        isValid = NO;
    }
    else if (![self isValidMoneyValue:txtFieldValue.text]){
        [txtFieldValue setValue:[UIColor colorWithRed:253.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:1.f]
                     forKeyPath:@"_placeholderLabel.textColor"];
        [txtFieldValue setPlaceholder:txtFieldValue.text];
        [txtFieldValue setText:@""];
        isValid = NO;
    }

    return isValid;
}

-(void)newProductFinished:(BOOL)isNew{
    if (isNew){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO forKey:@"isProductDisplayed"];
        [userDefaults synchronize];
        userDefaults = nil;
        self.tabBarController.selectedIndex = 2;
        [self releaseMemoryCache];
        self.view = nil;
    }
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadAttributsToProduct{
    [txtFieldCurrency setText:[NSString stringWithFormat:@"%@ - %@", product.currency,
                               [GlobalFunctions getCurrencyByCode:product.currency]]];
    [self.txtFieldTitle setText:[product nome]];
    [self.txtFieldValue setText:[product valorEsperado]];
    [self.textViewDescription setText:[product descricao]];
}

-(void)loadAttributsToPhotos:(NSArray *)fotos{
    @try {
        [self removeWaiting];

        for (size_t i = 0; i < [fotos count]; i++) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",
                                                   [(PhotoReturn *)[fotos objectAtIndex:i] listing_url]]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            
            [gallery addImageToScrollView:image
                                photoReturn:(PhotoReturn *)[fotos objectAtIndex:i]
                                    product:self.product
                                 isFromPicker:NO];
                        
            if ([fotos count] == i + 1)
                if ([fotos count] != 10)
                    [buttonAddPics setEnabled:YES];
            
            url = nil;
        }
        [buttonSaveProduct setUserInteractionEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if(pickerView.tag == PICKERSTATE)
        [txtFieldState setText:[NSString stringWithFormat:@"%@", (NSString *)[nsArrayState objectAtIndex:row]]];
    else 
        [txtFieldCurrency setText:[NSString stringWithFormat:@"%@", (NSString *)[nsArrayCurrency objectAtIndex:row]]];
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
- (void)setupKeyboardFields
{
    [keyboardControls setTextFields:[NSArray arrayWithObjects:
                                     txtFieldState, txtFieldTitle,textViewDescription, txtFieldCurrency, txtFieldValue, nil]];
    [super addKeyboardControlsAtFields];
}

/* Scroll the view to the active text field */
- (void)scrollViewToTextField:(id)textField
{
    UIScrollView* v = (UIScrollView*) self.scrollView;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:v];

    rc.size.height = 360;
    v = nil;
    [self.scrollView scrollRectToVisible:rc animated:YES];
}

/*
* The "Done" button was pressed
* We want to close the keyboard
*/
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [controls.activeTextField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:txtFieldValue])
        if (![GlobalFunctions onlyNumberKey:string])
            return NO;
    if ([textField isEqual:txtFieldTitle]){
        int limit = 80;
        return !([textField.text length]>limit && [string length] > range.length);
    }
    else if ([textField isEqual:txtFieldValue]){
        int limit = 6;
        return !([textField.text length]>limit && [string length] > range.length);
    }
    return YES;
}

-(void)releaseMemoryCache{
    [gallery releaseMemoryCache];
    gallery = nil;
    isImagesProductPosted = nil;
    countPicsPost = nil;
    countUploaded = nil;
    RKObjManeger = nil;
    nsArrayState = nil;
    nsArrayCurrency = nil;
    singleTap = nil;
//    shadowView = nil;
    HUD = nil;
    if ([waiting isHidden])
        keyboardControls.delegate = nil;
    product = nil;
    waiting = nil;
    [super releaseMemoryCache];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == PICKERSTATE || textField.tag == PICKERCURRENCY) {
        for (UIView *v in textField.subviews)
            if ([[[v class] description] rangeOfString:@"UITextSelectionView"].location != NSNotFound)
                v.hidden = YES;
    }
    
    if ([keyboardControls.textFields containsObject:textField])
        keyboardControls.activeTextField = textField;
    [self scrollViewToTextField:textField];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([keyboardControls.textFields containsObject:textView])
        keyboardControls.activeTextField = textView;
    [self scrollViewToTextField:textView];
}

-(IBAction)textFieldEditingEnded:(id)sender{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [sender resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillUnload:(BOOL)animated
{
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    //Bloco de verificação Temporario parametro para ajustar as 3 imagens para direita...
    if ([gallery.nsMutArrayPicsProduct count] == 1)
        [gallery.scrollView setContentOffset:CGPointMake(-180, scrollView.contentOffset.y) animated:YES];
    if ([gallery.nsMutArrayPicsProduct count] == 2)
        [gallery.scrollView setContentOffset:CGPointMake(-105, scrollView.contentOffset.y) animated:YES];
    if ([gallery.nsMutArrayPicsProduct count] == 3)
        [gallery.scrollView setContentOffset:CGPointMake(-25, scrollView.contentOffset.y) animated:YES];
    
    if (![[[GlobalFunctions getUserDefaults]
          objectForKey:@"isProductDisplayed"] boolValue] && self.product == nil) {
        int action = [[[GlobalFunctions getUserDefaults] objectForKey:@"controlComponentsAtFirstDisplay"] intValue];
        
        if (action == 0)
            [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeCamera];
        else if (action == 1)
            [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypePhotoLibrary];
              
       NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
       [userDefaults setBool:YES forKey:@"isProductDisplayed"];
       [userDefaults synchronize];
        userDefaults = nil;
    }
    
    if ([[[GlobalFunctions getUserDefaults] objectForKey:@"reloadProductAccount"] isEqual:@"YES"]){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NO" forKey:@"reloadProductAccount"];
        [userDefaults synchronize];
        userDefaults = nil;
        [self reloadPage];
    }
}

-(void)reloadPage{
    [txtFieldCurrency setText:@""];
    [txtFieldState setText:@""];
    [txtFieldTitle setText:@""];
    [txtFieldValue setText:@""];
    [textViewDescription setText:@""];
    gallery = nil;
    for (UIImageView *img in [scrollViewPicsProduct subviews])
        [img removeFromSuperview];
    [txtFieldTitle setValue:[UIColor colorWithRed:152.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.f] forKeyPath:@"_placeholderLabel.textColor"];
    [txtFieldValue setValue:[UIColor colorWithRed:152.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.f] forKeyPath:@"_placeholderLabel.textColor"];
    CGSize size = CGSizeMake(0, self.scrollViewPicsProduct.frame.size.height);
    [scrollViewPicsProduct setContentSize:size];
    [scrollView setContentOffset:CGPointZero animated:NO];
    [self loadAttributsToComponents];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    RKObjManeger = nil;
    [self setRKObjManeger:nil];
    scrollViewPicsProduct = nil;
    [self setScrollViewPicsProduct:nil];
    txtFieldTitle = nil;
    [self setTxtFieldTitle:nil];
    txtFieldValue = nil;
    [self setTxtFieldValue:nil];
    txtFieldState = nil;
    [self setTxtFieldState:nil];
    txtFieldCurrency = nil;
    [self setTxtFieldCurrency:nil];
    scrollView = nil;
    [self setScrollView:nil];
    textViewDescription = nil;
    [self setTextViewDescription:nil];
    buttonDeleteProduct = nil;
    [self setButtonDeleteProduct:nil];
    buttonSaveProduct = nil;
    [self setButtonSaveProduct:nil];
    isImagesProductPosted = nil;
    [self setIsImagesProductPosted:nil];
    product = nil;
    [self setProduct:nil];
    countUploaded = nil;
    [self setCountUploaded:nil];
    viewPicsControl = nil;
    [self setViewPicsControl:nil];
    buttonAddPics = nil;
    [self setButtonAddPics:nil];
    gallery = nil;
    [self setGallery:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end