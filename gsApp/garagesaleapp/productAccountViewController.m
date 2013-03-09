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
    
    IS_IPHONE_5 ? [self.view setFrame:CGRectMake(0, 0, 320, 455)] : [self.view setFrame:CGRectMake(0, 0, 320, 367)];
    
    [self loadAttributsToComponents];
}

-(void)loadAttributsToComponents{
    
    //initialize the i18n
    [self.buttonSaveProduct setTitle: NSLocalizedString(@"save", @"") forState:UIControlStateNormal];
    [self.txtFieldTitle setPlaceholder:NSLocalizedString(@"title", @"")];
    //[self.textViewDescription setText:NSLocalizedString(@"description", @"")];
    [self.buttonDeleteProduct setTitle: NSLocalizedString(@"deleteThisProduct", @"") forState:UIControlStateNormal];
    
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
    
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1200)];
    [shadowView setBackgroundColor:[UIColor blackColor]];
    [shadowView setAlpha:0];
    [viewPicsControl setAlpha:0];
    [viewPicsControl.layer setCornerRadius:5];
    
    [buttonAddPics setEnabled:NO];
    
    //Menu
    UIView *tabBar = [self rotatingFooterView];
    if ([tabBar isKindOfClass:[UITabBar class]])
        ((UITabBar *)tabBar).delegate = self;
    
    //self.tabBarController.delegate = self;
    
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

    //Set Picker View State
    UIPickerView *pickerViewState = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    [pickerViewState setDelegate:self];
    [pickerViewState setTag:PICKERSTATE];
    [pickerViewState setDataSource:self];
    [pickerViewState setShowsSelectionIndicator:YES];
    [txtFieldState setInputView:pickerViewState];
    [txtFieldState setTag:PICKERSTATE];
    txtFieldState.delegate = self;
    
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
    txtFieldCurrency.delegate = self;
    
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
    UIBarButtonItem *flexSpace              = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                            target:self
                                                                                            action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn                = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [picViewStateToolbar setItems:barItems animated:YES];
    
    [txtFieldState setInputAccessoryView:picViewStateToolbar];
    [txtFieldCurrency setInputAccessoryView:picViewStateToolbar];
   
    [self.scrollView setContentSize:CGSizeMake(320,587)];
    [self setupKeyboardFields];
    
    if (self.product != nil) {
        [buttonDeleteProduct setHidden:NO];
        self.trackedViewName = [NSString stringWithFormat:@"%@/%@/edit", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"], self.product.id];
        if ([self.product.fotos count] > 0)
            [scrollViewPicsProduct addSubview:waiting];
        [self loadingProduct];
    }else {
        [self getResourcePathPhotoReturnNotSaved];
        self.trackedViewName = [NSString stringWithFormat:@"%@/new", [[GlobalFunctions getUserDefaults] objectForKey:@"garagem"]];
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
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@/?idProduct=%@", self.product.idPessoa, self.product.id] objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}

- (void)getResourcePathPhotoReturnEdit{
    RKObjectMapping *photoReturnEdit = [Mappings getPhotosByIdProduct];

    //LoadUrlResourcePath
    [RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/photo/?idProduct=%i&token=%@",
                                             [self.product.id intValue], [[GlobalFunctions getUserDefaults] objectForKey:@"token"] ]
                              objectMapping:photoReturnEdit delegate:self];
    
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
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:[GlobalFunctions getMIMEType]];
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    @try {
        
        if ([objects count] == 0){
            [waiting removeFromSuperview];
            [buttonAddPics setEnabled:YES];
        }else if ([[objects objectAtIndex:0] isKindOfClass:[Product class]]){
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
        }


    }@catch (NSException *exception) {
        NSLog(@"%@", exception.name);
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    UIAlertView *alV = [[UIAlertView alloc] initWithTitle:error.domain
                                                  message: NSLocalizedString(@"image-upload-error", nil)
                                                 delegate:self
                                        cancelButtonTitle: NSLocalizedString(@"image-upload-error-btn1", nil)
                                        otherButtonTitles: NSLocalizedString(@"image-upload-error-btn2", nil), nil];
    [buttonAddPics setEnabled:YES];
    [waiting removeFromSuperview];
    
    [alV show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)loadingProduct{
    [self getResourcePathProduct];
    [self.navigationItem setLeftBarButtonItem:[GlobalFunctions getIconNavigationBar:@selector(backPage)
                                                                          viewContr:self
                                                                         imageNamed:@"btBackNav.png"
                                                                               rect:CGRectMake(0, 0, 40, 30)]];
    
    [self.navigationItem setTitleView:[GlobalFunctions getLabelTitleNavBarGeneric:UITextAlignmentCenter
                                                                             text:product.nome
                                                                            width:200]];
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"keyboard-cancel-btn", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"sheet-camera-item", nil),
                                                                NSLocalizedString(@"sheet-library-item", nil),
                                                                nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    sheet.delegate = self;
    [sheet showInView:self.view];
    [sheet showFromTabBar:self.tabBarController.tabBar];
    [sheet setTag:99];
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
    UIImage *imageThumb = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) 
        UIImageWriteToSavedPhotosAlbum(imageThumb, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    [scrollViewPicsProduct setFrame:CGRectMake(0,
                                               scrollViewPicsProduct.frame.origin.y,
                                               scrollViewPicsProduct.frame.size.width,
                                               scrollViewPicsProduct.frame.size.height)];

    //if ([buttonAddPics isEnabled]) {
        [gallery addImageToScrollView:imageThumb
                          photoReturn:nil
                              product:self.product
                         isFromPicker:YES];
    //}
    [picker dismissModalViewControllerAnimated:YES];
    
    if(!viewPicsControl.hidden)
        [self animationPicsControl];
}

-(IBAction)deleteProduct:(id)sender {
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"delete-product-title", nil)
                                                     message:NSLocalizedString(@"delete-product-desc", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"delete-product-btn1", nil)
                                           otherButtonTitles:NSLocalizedString(@"delete-product-btn2", nil), nil];
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
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
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
            if (self.product == nil){
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [buttonAddPics setEnabled:YES];
                [waiting removeFromSuperview];
            }
        }
        
    } else if ([request isPOST]) {
        
        // Handling POST /other.json
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }

        //Set Delay to Hide msgBidSentLabel
//        [NSTimer scheduledTimerWithTimeInterval:5.0
//                                         target:self
//                                       selector:@selector(hideMsgBidSent)
//                                       userInfo:nil
//                                        repeats:NO];
        
    } else if ([request isDELETE]) {
        // Handling DELETE /missing_resource.txt
        if (self.product != nil) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"YES" forKey:@"isNewOrRemoveProduct"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
        imagePicker.sourceType = type;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Allow editing of image ?
         imagePicker.wantsFullScreenLayout = YES;
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
            txtFieldValue.text = [txtFieldValue.text substringWithRange:NSMakeRange(0, 7)];
        if (txtFieldTitle.text.length > 80)
            txtFieldTitle.text = [txtFieldTitle.text substringWithRange:NSMakeRange(0, 80)];
        
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
            _postProdDelegate.isSaveProductFail = YES;
        else{
            [_postProdDelegate postProduct:prodParams];
            [self setEnableButtonSave:NO];
        }

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
    
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.labelFont = [UIFont fontWithName:@"Droid Sans" size:14];
	HUD.delegate = self;
	HUD.labelText = NSLocalizedString(@"image-uploading", nil);
	HUD.color = [UIColor blackColor];
    HUD.dimBackground = YES;
    
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (void)myProgressTask {
	// This just increases the progress indicator in a loop
    float progress = 0.0f;
    
    int count = 0;
    while (!_postProdDelegate.isSaveProductDone) {
		progress += 0.01f;
		HUD.progress = progress;
        if (progress > 1) progress = 0.0f;
		usleep(30000);
        count++;
        if (_postProdDelegate.isSaveProductFail)
            break;
	}
    
    if (_postProdDelegate.isSaveProductFail){
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconDeletePicsAtGalleryProdAcc.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = NSLocalizedString(@"image-upload-error-check", nil);
        sleep(2);
    }else if (_postProdDelegate.isSaveProductDone && !_postProdDelegate.isSaveProductFail) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"Completed";
        sleep(1);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"YES" forKey:@"isNewOrRemoveProduct"];
        [userDefaults setBool:NO forKey:@"isProductDisplayed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self newProductFinished:(self.product == nil)];
            
        });
    }
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
    return isValid;
}

-(void)newProductFinished:(BOOL)isNew{
    if (isNew){
        self.tabBarController.selectedIndex = 2;
        self.view = nil;
        //[self viewDidLoad];
        //[scrollView setContentOffset:CGPointZero animated:NO];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)loadAttributsToProduct{
    self.txtFieldTitle.text = [product nome];
    self.txtFieldValue.text = [product valorEsperado];
    self.textViewDescription.text = [product descricao];
}

-(void)loadAttributsToPhotos:(NSArray *)fotos{
    @try {
        [waiting removeFromSuperview];

        for (size_t i = 0; i < [fotos count]; i++) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",
                                                   [(PhotoReturn *)[fotos objectAtIndex:i] listing_url]]];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            
            [gallery addImageToScrollView:image
                                photoReturn:(PhotoReturn *)[fotos objectAtIndex:i]
                                    product:self.product
                                 isFromPicker:NO];
            
            if ([[scrollViewPicsProduct subviews] count] == [fotos count]){
                if ([fotos count] != 10)
                    [buttonAddPics setEnabled:YES];
                [buttonSaveProduct setUserInteractionEnabled:YES];
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
- (void)setupKeyboardFields
{
    keyboardControls.textFields = [NSArray arrayWithObjects:
                                        txtFieldState, txtFieldTitle,textViewDescription, txtFieldCurrency, txtFieldValue, nil];
    [super addKeyboardControlsAtFields];
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
    
    if ([[[GlobalFunctions getUserDefaults] objectForKey:@"isNewOrRemoveProduct"] isEqual:@"YES"])
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    if (![[[GlobalFunctions getUserDefaults]
          objectForKey:@"isProductDisplayed"] boolValue] && self.product == nil) {
        int action = [[[GlobalFunctions getUserDefaults] objectForKey:@"controlComponentsAtFirstDisplay"] intValue];
        
        if (action == 0)
            [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeCamera];
        else if (action == 1)
            [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypePhotoLibrary];
              
       NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
       [userDefaults setBool:YES forKey:@"isProductDisplayed"];
       [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    viewPicsControl = nil;
    [self setViewPicsControl:nil];
    buttonAddPics = nil;
    [self setButtonAddPics:nil];
    
    gallery = nil;
    [self setGallery:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end