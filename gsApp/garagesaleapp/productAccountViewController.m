//
//  productAccountViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//
#import "productAccountViewController.h"

@interface productAccountViewController ()
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
@synthesize labelTitle;
@synthesize labelDescription;
@synthesize labelValue;
@synthesize labelState;
@synthesize widthPaddingInImages;
@synthesize heightPaddingInImages;
@synthesize textViewDescription;
@synthesize viewPicsControl;
@synthesize product;

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.jpg"] 
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem   = [GlobalFunctions getIconNavigationBar:
                                               @selector(backPage) viewContr:self imageNamed:@"btBackNav.png"];
    
    [self.navigationController.navigationBar setTintColor:[GlobalFunctions getColorRedNavComponets]];
    self.navigationItem.titleView = [GlobalFunctions getLabelTitleGaragesaleNavBar:UITextAlignmentLeft width:300];
    
    labelState.font        = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelTitle.font        = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelDescription.font  = [UIFont fontWithName:@"Droid Sans" size:13 ];
    labelValue.font        = [UIFont fontWithName:@"Droid Sans" size:13 ];
    
    [txtFieldState       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldTitle       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldCurrency    setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [txtFieldValue       setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    [textViewDescription setFont:[UIFont fontWithName:@"Droid Sans" size:14]];
    
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1200)];
    [shadowView setBackgroundColor:[UIColor blackColor]];
    shadowView.alpha = 0;
    viewPicsControl.alpha = 0;
    viewPicsControl.layer.cornerRadius = 5;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    
    //Menu
    UIView *tabBar = [self rotatingFooterView];
    if ([tabBar isKindOfClass:[UITabBar class]])
        ((UITabBar *)tabBar).delegate = self;
    
    self.tabBarController.delegate = self;
    
    nsMutArrayPicsProduct   = [[NSMutableArray alloc] init];
    nsArrayState    = [NSArray arrayWithObjects:NSLocalizedString(@"Avaliable", @""),
                       NSLocalizedString(@"Sold", @""), nil];
    
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
    pickerViewState.delegate = self;
    pickerViewState.tag = PICKERSTATE;
    pickerViewState.dataSource = self;
    pickerViewState.showsSelectionIndicator = YES;
    txtFieldState.inputView = pickerViewState;
    txtFieldState.text = NSLocalizedString(@"Avaliable", @"");
    
    //Set Picker View Currency
    UIPickerView *pickerViewCurrency = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    pickerViewCurrency.delegate = self;
    pickerViewCurrency.tag = PICKERCURRENCY;
    pickerViewCurrency.dataSource = self;
    pickerViewCurrency.showsSelectionIndicator = YES;
    txtFieldCurrency.inputView = pickerViewCurrency;
    
    txtFieldCurrency.text = [NSString stringWithFormat:@"%@ - %@",code,symbol];
    
    //Create done button in UIPickerView
    UIToolbar       *picViewStateToolbar    = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    picViewStateToolbar.barStyle            = UIBarStyleBlackOpaque;
    [picViewStateToolbar sizeToFit];
    NSMutableArray  *barItems               = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace              = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn                = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [picViewStateToolbar setItems:barItems animated:YES];
    
    txtFieldState.inputAccessoryView = picViewStateToolbar;
    txtFieldCurrency.inputAccessoryView = picViewStateToolbar;
    
    imageWidth_ = 50.0f;
    imageHeight_ = 50.0f;
    widthPaddingInImages = kWidthPaddingInImages;
    heightPaddingInImages = kHeightPaddingInImages;
    
    self.scrollView.contentSize = CGSizeMake(320,710);
    [self setupKeyboardControls];

    
    
    
    
    if (self.product != nil) {
        [self setupProductPhotosMapping];
        
    }else {
        [self animationPicsControl];
    }
    
}

-(void)backPage{
    [self.navigationController popViewControllerAnimated:YES];
}

//
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if (textField==txtFieldCurrency){
//        textField.hidden = YES;
//    }
//    else {
//        txtFieldCurrency.hidden = NO;
//    }
//    return YES;
//}

- (IBAction)isNumberKey:(UITextField *)textField{
    [GlobalFunctions onlyNumberKey:textField];
}

-(void)pickerDoneClicked{
    [txtFieldState resignFirstResponder];
    [txtFieldCurrency resignFirstResponder];
}

- (IBAction)animationPicsControl{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionFlipFromLeft];
    
    if (viewPicsControl.hidden) {
        [self.scrollView insertSubview:shadowView belowSubview:viewPicsControl];
        viewPicsControl.hidden = NO;
        viewPicsControl.alpha = 1.0;
        shadowView.alpha = 0.7;
        [UIView commitAnimations];
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

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    [GlobalFunctions tabBarController:theTabBarController didSelectViewController:viewController];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    if (isImagesProductPosted) {
        txtFieldTitle.text          = @"";
        textViewDescription.text    = @"";
        txtFieldValue.text          = @"";
        isImagesProductPosted       = !isImagesProductPosted;
        isLoading                   = !isLoading;
        imageWidth_                 = 50.0f;
        imageHeight_                = 50.0f;
        NSLocale *theLocale         = [NSLocale currentLocale];
        txtFieldCurrency.text       = [NSString stringWithFormat:@"%@ - %@",
                                       [theLocale objectForKey:NSLocaleCurrencyCode],
                                       [theLocale objectForKey:NSLocaleCurrencySymbol]]; 
        txtFieldState.text          = NSLocalizedString(@"Avaliable", @"");
        [self animationPicsControl];
    }
}

-(IBAction)getPicsByCamera:(id)sender {
    [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeCamera];
}

-(IBAction)getPicsByPhotosAlbum:(id)sender {
    [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{    
    UIImage *imageThumb = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self addImageToScrollView:imageThumb];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)sender { 
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIImageView *imageView      = (UIImageView *)sender.view;
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
    }
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

-(void)addImageToScrollView:(UIImage *)aImage{
    // [self removeNoPhotoAdded];
    if (nsMutArrayPicsProduct == nil) {
        [self displayImages:[NSArray arrayWithObject:aImage]];
    }else{
        [nsMutArrayPicsProduct addObject:aImage];
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:aImage];
        imageView.frame = CGRectMake(scrollViewPicsProduct.contentSize.width , self.heightPaddingInImages, imageWidth_, imageHeight_);
        [scrollViewPicsProduct addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [imageView addGestureRecognizer:longPressGesture];
        CGSize size = scrollViewPicsProduct.contentSize;
        size.width = size.width + imageWidth_ + self.widthPaddingInImages;
        scrollViewPicsProduct.contentSize = size;
        scrollViewPicsProduct.showsVerticalScrollIndicator = NO;
        scrollViewPicsProduct.showsHorizontalScrollIndicator = NO;
    }
}

-(void)displayImages:(NSArray *)aImageList{
    nsMutArrayPicsProduct = [NSMutableArray arrayWithArray:aImageList];
    [self placeImages:nsMutArrayPicsProduct];
}

-(void)placeImages:(NSArray *)aImageList{
    scrollViewPicsProduct.contentSize =CGSizeZero;
    if ([aImageList count] > 0) {
        //[self removeNoPhotoAdded];
    }
    for (int imageNumber =0 ; imageNumber < [aImageList count]; imageNumber ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[aImageList objectAtIndex:imageNumber]];
        imageView.frame = CGRectMake(imageNumber * (imageWidth_ + self.widthPaddingInImages), self.heightPaddingInImages, imageWidth_, imageHeight_);
        [scrollViewPicsProduct addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [imageView addGestureRecognizer:longPressGesture];
        CGSize size = scrollViewPicsProduct.contentSize;
        size.width = size.width + imageWidth_ + self.widthPaddingInImages;
        scrollViewPicsProduct.contentSize = size;
        scrollViewPicsProduct.showsVerticalScrollIndicator = NO;
        scrollViewPicsProduct.showsHorizontalScrollIndicator = NO;
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
        imagePicker.allowsImageEditing = NO;
        
        // Show image picker
        [self presentModalViewController:imagePicker animated:YES];	
    }
}

-(IBAction)saveProduct{
    if (self.product == nil) {
        // Set determinate mode
        [self myTask];
        
        [txtFieldValue resignFirstResponder];

        if([nsMutArrayPicsProduct count] != 0) {
            [self uploadPhotos:@""];
        }else {
            [self postProduct];
        }
        
    }
}

#pragma mark -
#pragma mark Execution code

- (void)myTask {
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
    
    while (!isLoading) {
		progress += 0.01f;
		HUD.progress = progress;
        if (progress > 1) progress = 0.0f;
		usleep(50000);
	}
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
	sleep(2);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"isProductRecorded"];  
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self reloadInputViews];
}

-(void)reloadInputViews{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    for (UIView *subview in [scrollViewPicsProduct subviews]){
        if([subview isKindOfClass:[UIImageView class]])
            [subview removeFromSuperview];
    }
    [HUD.customView removeFromSuperview];
    [nsMutArrayPicsProduct removeAllObjects];
    nsMutArrayPicsProduct = nil;
    sleep(2);
    [self goToTabBarController:2];
}

-(void)postProduct {
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
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
    
    //The server ask me for this format, so I set it here:
    [postData setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"] forKey:@"token"];
    [postData setObject:idPerson              forKey:@"idUser"];
    
    //Parsing prodParams to JSON! 
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:@"text/html"];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:prodParams error:&error];    
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    //If no error we send the post, voila!
    if (!error){
        
        //Add ProductJson in postData for key product
        [postData setObject:json forKey:@"product"];
        
        [[[RKClient sharedClient] post:@"/product" params:postData delegate:self] send];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if ([[objects objectAtIndex:0] isKindOfClass:[ProductPhotos class]]){
        
        
        self.txtFieldTitle.text = [(ProductPhotos *)[objects objectAtIndex:0] nome];
        self.txtFieldValue.text = [(ProductPhotos *)[objects objectAtIndex:0] valorEsperado];
        self.textViewDescription.text = [(ProductPhotos *)[objects objectAtIndex:0] descricao];
        
        for (int i=0; i < [[(ProductPhotos *)[objects objectAtIndex:0]fotos] count]; i++) {
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [GlobalFunctions getUrlImagePath], [[[(ProductPhotos *)[objects objectAtIndex:0]fotos]objectAtIndex:i]caminhoThumb]]];

            UIImage *image                   = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            
            [self addImageToScrollView:image];
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
        
    } else if ([request isPOST]) {
        NSLog(@"after posting to server, %@", [response bodyAsString]);
        
        [self setPostFlags];
        
        // Handling POST /other.json        
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isDELETE]) {
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}


- (void)setupProductPhotosMapping{
    //Initializing the Object Manager
    // RKObjManeger = [RKObjectManager sharedManager];
    
    //Configure Photo Object Mapping
    RKObjectMapping *photoMapping = [RKObjectMapping mappingForClass:[Photo class]];
    [photoMapping mapAttributes:@"caminho",
     @"caminhoThumb",
     @"caminhoTiny",
     @"principal",
     @"idProduto",
     @"id",
     @"id_estado",
     nil];
    
    //Configure Product Object Mapping
    RKObjectMapping *productPhotoMapping = [RKObjectMapping mappingForClass:[ProductPhotos class]];    
    [productPhotoMapping mapKeyPath:@"sold"          toAttribute:@"sold"];
    [productPhotoMapping mapKeyPath:@"showPrice"     toAttribute:@"showPrice"];
    [productPhotoMapping mapKeyPath:@"currency"      toAttribute:@"currency"];
    [productPhotoMapping mapKeyPath:@"categorias"    toAttribute:@"categorias"];
    [productPhotoMapping mapKeyPath:@"valorEsperado" toAttribute:@"valorEsperado"];    
    [productPhotoMapping mapKeyPath:@"descricao"     toAttribute:@"descricao"];
    [productPhotoMapping mapKeyPath:@"nome"          toAttribute:@"nome"];
    [productPhotoMapping mapKeyPath:@"idEstado"      toAttribute:@"idEstado"];
    [productPhotoMapping mapKeyPath:@"idPessoa"      toAttribute:@"idPessoa"];
    [productPhotoMapping mapKeyPath:@"id"            toAttribute:@"id"];
    //Relationship
    [productPhotoMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%@/?idProduct=%@", self.product.idPessoa, self.product.id] objectMapping:productPhotoMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/plain"];
    
}

-(void)setPostFlags{
    if (!isImagesProductPosted) {
        [self postProduct];
        isImagesProductPosted = !isImagesProductPosted;
    }else {
        isLoading = !isLoading;
    }
}

-(void)uploadPhotos:(NSString *)idProduct{
    
    RKParams* params = [RKParams params];
    for(int i = 0; i < [nsMutArrayPicsProduct count]; i++){
        NSData              *dataImage  = UIImageJPEGRepresentation([nsMutArrayPicsProduct objectAtIndex:i], 1.0);
        
        
        UIImage *loadedImage = (UIImage *)[nsMutArrayPicsProduct objectAtIndex:i];
        float w = loadedImage.size.width;
        float h = loadedImage.size.height;
        float ratio = w/h;
                
        int neww = 700;
        //get image height proportionally;
        float newh = neww/ratio;
        
        UIImage *image = [UIImage imageWithData:dataImage];
        CGRect rect = CGRectMake(0.0, 0.0, neww, newh);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *imgdata1 = UIImageJPEGRepresentation(img, 1.0); 
        
        
        
        
        RKParamsAttachment  *attachment = [params setData:imgdata1 forParam:@"files[]"];
        attachment.MIMEType = @"image/png";
        attachment.fileName = [NSString stringWithFormat:@"foto%i.jpg", (i+1)];
    }
    
    if ([idProduct isEqualToString:@""]) {
        [[[RKObjectManager sharedManager] client] post:[NSString stringWithFormat:@"/photo?token=%@",[[GlobalFunctions getUserDefaults] objectForKey:@"token"]] params:params delegate:self];
    } else {
        [[[RKObjectManager sharedManager] client] post:[NSString stringWithFormat:@"/photo?idProduct=%@&token=%@",idProduct,[[GlobalFunctions getUserDefaults] objectForKey:@"token"]] params:params delegate:self];
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

//-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if (error) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle: @"Save failed"
//                              message: @"Failed to save image/video"
//                              delegate: nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        
//        [alert show];
//    }
//}

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
                                        txtFieldState,txtFieldTitle,textViewDescription,txtFieldCurrency, txtFieldValue,nil];
    
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
    
    rc.size.height = 350;
    
    [self.scrollView scrollRectToVisible:rc animated:YES];
    
    /* 
     Use this block case use UITableView
     
     UITableViewCell *cell = nil;
     if ([textField isKindOfClass:[UITextField class]])
     cell = (UITableViewCell *) ((UITextField *) textField).superview.superview;
     else if ([textField isKindOfClass:[UITextView class]])
     cell = (UITableViewCell *) ((UITextView *) textField).superview.superview;
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
     [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
     */
}

#pragma mark -
#pragma mark BSKeyboardControls Delegate

/* 
 * The "Done" button was pressed
 * We want to close the keyboard
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
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

#pragma mark -
#pragma mark UITextField Delegate

/* Editing began */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.keyboardControls.textFields containsObject:textField])
        self.keyboardControls.activeTextField = textField;
    [self scrollViewToTextField:textField];
}

#pragma mark -
#pragma mark UITextView Delegate

/* Editing began */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.keyboardControls.textFields containsObject:textView])
        self.keyboardControls.activeTextField = textView;
    [self scrollViewToTextField:textView];
}

-(IBAction)textFieldEditingEnded:(id)sender{
    [sender resignFirstResponder];
}
/* 
 *
 End Setup the keyboard controls 
 *
 */

- (void)viewDidUnload
{
    textViewDescription = nil;
    [self setTextViewDescription:nil];
    labelState = nil;
    labelTitle = nil;
    labelDescription = nil;
    [self setLabelState:nil];
    [self setLabelTitle:nil];
    [self setLabelDescription:nil];
    [self setLabelValue:nil];
    labelValue = nil;
    viewPicsControl = nil;
    [self setViewPicsControl:nil];
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