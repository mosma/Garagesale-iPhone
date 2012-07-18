//
//  productAccountViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/06/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "productAccountViewController.h"

@implementation productAccountViewController

@synthesize mutArrayPicsProduct;
@synthesize RKObjManeger;
@synthesize txtFieldTitle;
@synthesize txtFieldValue;
@synthesize txtFieldState;
@synthesize txtFieldCurrency;

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
    
    //Menu
    UIView *tabBar = [self rotatingFooterView];
    if ([tabBar isKindOfClass:[UITabBar class]]) {
        ((UITabBar *)tabBar).delegate = self;
    }
    
    mutArrayPicsProduct = [[NSMutableArray alloc] init];
    
    nsArrayState    = [NSArray arrayWithObjects:@"Disponivel",
                                                @"Vendido", nil];
    
    nsArrayCurrency = [NSArray arrayWithObjects:@"BRL",
                                                @"GBP",
                                                @"EUR",
                                                @"USD", nil];
    
    //Set Picker View State
    pickerViewState = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    pickerViewState.delegate = self;
    pickerViewState.tag = 1;
    pickerViewState.dataSource = self;
    pickerViewState.showsSelectionIndicator = YES;
    txtFieldState.inputView = pickerViewState;
    
    //Set Picker View Currency
    pickerViewCurrency = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    pickerViewCurrency.delegate = self;
    pickerViewCurrency.tag = 2;
    pickerViewCurrency.dataSource = self;
    pickerViewCurrency.showsSelectionIndicator = YES;
    txtFieldCurrency.inputView = pickerViewCurrency;
    
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
}

//Disable Select, Copy, Select All on TextField
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
} 

-(void)pickerDoneClicked{
    [txtFieldState resignFirstResponder];
    [txtFieldCurrency resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated{
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self showCamera];
    } else if (buttonIndex == 1) {
       NSLog(@"Other Button 1 Clicked");
    } 
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImageView *imagee = [[UIImageView alloc] initWithImage:image];
    [scrollViewPicsProduct addSubview:imagee];
   // [mutArrayPicsProduct addObject:[UIImage imageWithData:[info objectForKey:@"UIImagePickerControllerOriginalImage"]]];
    [picker dismissModalViewControllerAnimated:YES];
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

- (void)showCamera{
	// Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
	imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
	imagePicker.delegate = self;
    
    // Allow editing of image ?
	imagePicker.allowsImageEditing = NO;
    
    // Show image picker
	[self presentModalViewController:imagePicker animated:YES];	
}

-(IBAction)saveProduct{
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *prodParams = [[NSMutableDictionary alloc] init];
    
    //User and password params
    NSString *idPerson = [[GlobalFunctions getUserDefaults] objectForKey:@"idPerson"];
    [prodParams setObject:idPerson               forKey:@"idPessoa"];
    [prodParams setObject:txtFieldValue.text     forKey:@"valorEsperado"];
    [prodParams setObject:txtFieldTitle.text     forKey:@"nome"];
    [prodParams setObject:@""                    forKey:@"descricao"];
    [prodParams setObject:@"1"                   forKey:@"idEstado"];
    [prodParams setObject:idPerson               forKey:@"idUser"];
    [prodParams setObject:@""                    forKey:@"categorias"];
    [prodParams setObject:@""                    forKey:@"newPhotos"];
    [prodParams setObject:txtFieldCurrency.text  forKey:@"currency"];
    
    //The server ask me for this format, so I set it here:
    [postData setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"token"] forKey:@"token"];
    [postData setObject:idPerson              forKey:@"idUser"];

    
    //Parsing rpcData to JSON! 
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:@"text/html"];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:prodParams error:&error];    
    
    //Add ProductJson in postData for key product
    [postData setObject:json forKey:@"product"];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    //If no error we send the post, voila!
    if (!error){
        [[[RKClient sharedClient] post:@"/product?XDEBUG_SESSION_START=ECLIPSE_DBGP&KEY=134253614003713" params:postData delegate:self] send];
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    
    if(pickerView.tag == 1)
        txtFieldState.text = [NSString stringWithFormat:@"   %@", (NSString *)[nsArrayState objectAtIndex:row]];
    else 
        txtFieldCurrency.text = [NSString stringWithFormat:@"   %@", (NSString *)[nsArrayCurrency objectAtIndex:row]];
    
    
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView.tag == 1)
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
    if(pickerView.tag ==1)
        return [nsArrayState objectAtIndex:row];
    else 
        return [nsArrayCurrency objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {    
    return 300;
}



- (void)viewDidUnload
{
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
