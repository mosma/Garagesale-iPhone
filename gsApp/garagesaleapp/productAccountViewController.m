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

//@synthesize mutDictPicsProduct;
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

    //Menu
    UIView *tabBar = [self rotatingFooterView];
    if ([tabBar isKindOfClass:[UITabBar class]]) {
        ((UITabBar *)tabBar).delegate = self;
    }
    
    //mutDictPicsProduct      = [[NSMutableDictionary alloc] init];
    
    nsMutArrayPicsProduct   = [[NSMutableArray alloc] init];
    nsArrayState    = [NSArray arrayWithObjects:NSLocalizedString(@"Avaliable", @""),
                                                NSLocalizedString(@"Sold", @""), nil];
    
    nsArrayCurrency = [NSArray arrayWithObjects:@"BRL",
                                                @"GBP",
                                                @"EUR",
                                                @"USD", nil];
    
    //Set Picker View State
    UIPickerView *pickerViewState = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    pickerViewState.delegate = self;
    pickerViewState.tag = PICKERSTATE;
    pickerViewState.dataSource = self;
    pickerViewState.showsSelectionIndicator = YES;
    //txtFieldState.inputView = pickerViewState;
    txtFieldState.text = NSLocalizedString(@"Avaliable", @"");
    
    //Set Picker View Currency
    UIPickerView *pickerViewCurrency = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    pickerViewCurrency.delegate = self;
    pickerViewCurrency.tag = PICKERCURRENCY;
    pickerViewCurrency.dataSource = self;
    pickerViewCurrency.showsSelectionIndicator = YES;
    txtFieldCurrency.inputView = pickerViewCurrency;
    txtFieldCurrency.text = @"BRL";
    
    // Create done button in UIPickerView
    UIToolbar*  picViewStateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    picViewStateToolbar.barStyle = UIBarStyleBlackOpaque;
    [picViewStateToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    	 
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    	 
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    	 
    [picViewStateToolbar setItems:barItems animated:YES];
    	 
    txtFieldState.inputAccessoryView = picViewStateToolbar;
    txtFieldCurrency.inputAccessoryView = picViewStateToolbar;
    
    imageWidth_ = 50.0f;
    imageHeight_ = 50.0f;
    widthPaddingInImages = kWidthPaddingInImages;
    heightPaddingInImages = kHeightPaddingInImages;
    
    self.scrollView.contentSize             = CGSizeMake(320,650);
    
    [self setupKeyboardControls];

}

////Disable Select, Copy, Select All on TextField
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    if (menuController) {
//        [UIMenuController sharedMenuController].menuVisible = NO;
//    }
//    return NO;
//} 
//
//- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//    //This line dismisses the keyboard.       
//    [theTextField resignFirstResponder];
//    //Your view manipulation here if you moved the view up due to the keyboard etc.       
//    return NO;
//}

-(void)pickerDoneClicked{
    [txtFieldState resignFirstResponder];
    [txtFieldCurrency resignFirstResponder];
}

-(IBAction)addProduct:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Adicionar Produto"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancela"
                                               destructiveButtonTitle:@"Tirar foto"
                                                    otherButtonTitles:nil];
    
    NSDictionary *colors = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor redColor], @"Biblioteca",
                            [UIColor greenColor], @"Produto sem foto", nil];
    
    [colors enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
		[actionSheet addButtonWithTitle:key];
    }];
    
    [actionSheet showInView:self.view];
}

- (void)viewWillAppear:(BOOL)animated{
    [self addProduct:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
      [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == 2) {
      [self getTypeCameraOrPhotosAlbum:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    } 
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{    
    UIImage *imageThumb = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self addImageToScrollView:imageThumb];
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)sender { 
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIImageView * imageView = (UIImageView *)sender.view;
        NSArray * imageViews = [scrollViewPicsProduct subviews];
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
    NSArray * imageViews = [scrollViewPicsProduct subviews];
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


//-(void)imagePickerController:(UIImagePickerController *)imgPicker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
//{
//    [self dismissModalViewControllerAnimated:YES];
//    NSLog(@"Sauvegarde de l'image"); //Message de log
//    
//    NSData* imageData = UIImagePNGRepresentation(image);
//    NSString* imageName = @"tempImage.jpg"; 
//    
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* documentsDirectory = [paths objectAtIndex:0]; 
//    
//    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
//    [imageData writeToFile:fullPathToFile atomically:NO];
//    NSLog(@"Photo enregistrée avec succes");
//    
//    
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
        imagePicker.allowsImageEditing = YES;
        
        // Show image picker
        [self presentModalViewController:imagePicker animated:YES];	
    }
}

-(IBAction)saveProduct{
    if([nsMutArrayPicsProduct count] != 0) {
        [self uploadPhotos:@""];
    }else {
        [self postProduct];
    }
}

-(void)postProduct {
        if([nsMutArrayPicsProduct count] != 0){
            //                [self uploadPhotos:[dictProduct valueForKey:@"id"]];
            //            }else {
            NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *prodParams = [[NSMutableDictionary alloc] init];
            
            //User and password params
            NSString *idPerson = [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"];
            [prodParams setObject:idPerson               forKey:@"idPessoa"];
            [prodParams setObject:txtFieldValue.text     forKey:@"valorEsperado"];
            [prodParams setObject:txtFieldTitle.text     forKey:@"nome"];
            [prodParams setObject:textViewDescription    forKey:@"descricao"];
            [prodParams setObject:@"1"                   forKey:@"idEstado"];
            [prodParams setObject:idPerson               forKey:@"idUser"];
            [prodParams setObject:@""                    forKey:@"categorias"];
            [prodParams setObject:@""                    forKey:@"newPhotos"];
            [prodParams setObject:txtFieldCurrency.text  forKey:@"currency"];
            
            //The server ask me for this format, so I set it here:
            [postData setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"] forKey:@"token"];
            [postData setObject:idPerson              forKey:@"idUser"];
            
            //Parsing prodParams to JSON! 
            id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:@"text/html"];
            NSError *error = nil;
            NSString *json = [parser stringFromObject:prodParams error:&error];    
            
            //Add ProductJson in postData for key product
            [postData setObject:json forKey:@"product"];
            
            [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
            
            //If no error we send the post, voila!
            if (!error){
                [[[RKClient sharedClient] post:@"/product" params:postData delegate:self] send];
            }
        }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"");
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
        
//        NSError *error = nil;
//        RKJSONParserJSONKit *parser = [RKJSONParserJSONKit new]; 
//        NSDictionary *dictProduct = [parser objectFromString:[response bodyAsString] error:&error];
        
        if (!isPostProduct) {
            [self postProduct];
            isPostProduct = !isPostProduct;
        }else 
            isPostProduct = !isPostProduct;
        
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

-(void)uploadPhotos:(NSString *)idProduct{
    
    
    RKParams* params = [RKParams params];
    for(int i = 0; i < [nsMutArrayPicsProduct count]; i++){
        NSData *dataImage = UIImageJPEGRepresentation([nsMutArrayPicsProduct objectAtIndex:i], 0.75);
        [params setData:dataImage MIMEType:@"image/jpeg" forParam:[NSString stringWithFormat:@"files[%i]", i]];
     }
    
    if ([idProduct isEqualToString:@""]) {
            [[[RKObjectManager sharedManager] client] post:[NSString stringWithFormat:@"/photo?token=%@",[[GlobalFunctions getUserDefaults] objectForKey:@"token"]] params:params delegate:self];
    } else {
            [[[RKObjectManager sharedManager] client] post:[NSString stringWithFormat:@"/photo?idProduct=%@&token=%@",idProduct,[[GlobalFunctions getUserDefaults] objectForKey:@"token"]] params:params delegate:self];
    }

    // [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo/token=%@&idProduct=%@", [[GlobalFunctions getUserDefaults] objectForKey:@"token"],[[dict valueForKey:@"id"] string]] params:params delegate:self];
    
    
    //        NSArray *keys;
    //        int i, count;
    //        id key, value;
    //        
    //        keys = [dict allKeys];
    //        count = [keys count];
    //        for (i = 0; i < count; i++)
    //        {
    //            key = [keys objectAtIndex: i];
    //            value = [dict objectForKey: key];
    //            NSLog (@"Key: %@ for value: %@", key, value);
    //        }
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
