//
//  GlobalFunctions.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 17/05/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "GlobalFunctions.h"
#import "NSAttributedString+Attributes.h"

@implementation GlobalFunctions

@synthesize imageThumbsXorigin_Iphone;
@synthesize imageThumbsYorigin_Iphone;
@synthesize countColumnImageThumbs;

+(int)getTabPosition:(tabPosition)position{
    if (IS_IPHONE_5) if (position == tabPositionTop) return 521; else return 570;
    else             if (position == tabPositionTop) return 431; else return 480;
}

+(int)getHomeProductsNumber {
    if (IS_IPHONE_5) return 15; else return 12;
}

+(NSString *)getUrlServicePath {
    //return @"http://169.254.251.178";//text/html
    return @"http://gsapi.easylikethat.com";//text/plain
    //return @"http://api.garagesaleapp.me";//text/plain
}

+(NSString *)getUrlApplication {
    //return @"http://169.254.251.178";//text/html
    return @"http://easylikethat.com";//text/plain
    //return @"http://garagesaleapp.me";//text/plain
}

+(NSString *)getMIMEType {
    return @"text/html";
    //return @"text/plain";
}

+(NSUserDefaults *)getUserDefaults {
    return [NSUserDefaults standardUserDefaults];
}

+(UIColor *)getColorRedNavComponets {
    return [UIColor colorWithRed:219.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0]; 
}

- (UIView *)loadButtonsThumbsProduct:(NSArray *)arrayDetailProduct showEdit:(BOOL)showEdit showPrice:(BOOL)showPrice viewContr:(UIViewController *)viewContr {
    
    
    @try {

        Product     *product    = (Product *)[arrayDetailProduct objectAtIndex:0];

        /*
         Logic Block of count Logic At X,Y Position viewThumbs display on Iphone.
         imageThumbsXorigin_Iphone    Create by Instance Class
         imageThumbsYorigin_Iphone    Create by Instance Class
         countColumnImageThumbs       Create by Instance Class
        */
        if (countColumnImageThumbs == 3) {
            imageThumbsXorigin_Iphone = 10;
            imageThumbsYorigin_Iphone = imageThumbsYorigin_Iphone + 103;
            countColumnImageThumbs = 0;
        } else if (countColumnImageThumbs >= 1){
            imageThumbsXorigin_Iphone = imageThumbsXorigin_Iphone + 103;
        }
        if (countColumnImageThumbs == -1)
            countColumnImageThumbs++;
        countColumnImageThumbs++;
        /*
         End Block
         */

        UIView *viewThumbs = [[UIView alloc] initWithFrame:
                                CGRectMake(imageThumbsXorigin_Iphone, imageThumbsYorigin_Iphone, 94, 94)];
        
        //Button Product
        UIButton *buttonThumbsProduct  = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonThumbsProduct.frame      = CGRectMake(0, 0, 94, 94);
        [buttonThumbsProduct setTag:[[arrayDetailProduct objectAtIndex:1] intValue]];
        [buttonThumbsProduct addTarget:viewContr action:@selector(gotoProductDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        [buttonThumbsProduct setImage:[UIImage imageNamed:@"placeHolder"] forState:UIControlStateNormal];
        
        NSThread *thr = [[NSThread alloc] initWithTarget:self selector:@selector(loadThumbs:) object:[NSArray arrayWithObjects:arrayDetailProduct, buttonThumbsProduct, nil]];
        [thr start];
        
        buttonThumbsProduct.imageView.layer.cornerRadius = 3;
        [buttonThumbsProduct setAlpha:0];
        [viewThumbs addSubview:buttonThumbsProduct];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        //[UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationTransitionCurlUp];
        [buttonThumbsProduct setAlpha:1.0];
        [UIView commitAnimations];
            
        UIGraphicsEndImageContext();

        if (showPrice) {
            //Set View Price
            UIView *viewPrice = [[UIView alloc] init];
            viewPrice.layer.cornerRadius = 4;
            viewPrice.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
            [viewPrice setUserInteractionEnabled:NO];
            
            [viewThumbs addSubview:viewPrice];

            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(13, 12, 50, 20)];

            if ([product.idEstado intValue] == 1) {
                //Set Label Only
                UILabel *only = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 30, 20)];
                [only setText:NSLocalizedString(@"only", nil)];
                only.backgroundColor = [UIColor clearColor];
                [only setFont:[UIFont fontWithName:@"Droid Sans" size:10]];
            
                [viewPrice addSubview:only];
                only = nil;
                //Set Label Price

                NSString *currency = [GlobalFunctions getCurrencyByCode:product.currency];
                [price setText:[NSString stringWithFormat:@"%@%@", currency, product.valorEsperado]];
                //[price setAdjustsFontSizeToFitWidth:YES];
                price.textColor = [UIColor colorWithRed:91.0/255.0 green:148.0/255.0 blue:67.0/255.0 alpha:1.0];
                [price setFont:[UIFont fontWithName:@"Droid Sans" size:16]];
                currency = nil;
            } else {
                [price setFont:[UIFont fontWithName:@"Droid Sans" size:13 ]];
                [price setTextColor:[UIColor colorWithRed:(float)255/255.0 \
                                                                   green:(float)102/255.0 \
                                                                    blue:(float)102/255.0 alpha:1.0]];
            }
            
            switch ([product.idEstado intValue]) {
                case 2:
                    [price setText:NSLocalizedString(@"sold", nil)];
                    break;
                case 3:
                    [price setText:NSLocalizedString(@"not-available-label", nil)];
                    break;
                case 4:
                    [price setText:NSLocalizedString(@"invisible-label", nil)];
                    break;
            }
            [price sizeToFit];
            price.backgroundColor = [UIColor clearColor];
            [viewPrice addSubview:price];
            [viewPrice setFrame:CGRectMake(-5, 45, price.bounds.size.width+20, 35)];
            price = nil;
            buttonThumbsProduct = nil;
            viewPrice = nil;
            thr = nil;
        }
        if (showEdit) {
            //View Edit Pencil
            
            UIButton *buttonViewEditPencil = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonViewEditPencil setFrame:CGRectMake(5, 5, 24, 22)];
            
            [buttonViewEditPencil setTag:[[arrayDetailProduct objectAtIndex:1] intValue]];
            [buttonViewEditPencil addTarget:viewContr action:@selector(gotoProductAccountVC:) forControlEvents:UIControlEventTouchUpInside];
            [buttonViewEditPencil setImage:[UIImage imageNamed:@"btPencilEditProductThumbs.png"] forState:UIControlStateNormal];

            [viewThumbs addSubview:buttonViewEditPencil];
            buttonViewEditPencil = nil;
        }
        product = nil;
        arrayDetailProduct = nil;
        return viewThumbs;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
        return [[UIView alloc] init];
    }
}

-(void)loadThumbs:(NSArray *)array{
    @autoreleasepool {
        NSString *strUrl = [GlobalFunctions getUrlImagesProduct:[array objectAtIndex:0]
                                                      imageType:imageTypeListing];
        
        NSURL *url = [NSURL URLWithString:strUrl];
        strUrl = nil;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
        url = nil;
        
        [[array objectAtIndex:1] setImage:nil forState:UIControlStateNormal];
        [[array objectAtIndex:1] setAlpha:0];
        
        UIImage *image = (imageData == NULL) ? [UIImage imageNamed:@"nopicture.png"] : [[UIImage alloc] initWithData:imageData];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        [[array objectAtIndex:1] setImage:image forState:UIControlStateNormal];
        [[array objectAtIndex:1] setAlpha:1.0];
        [UIView commitAnimations];

        array = nil;
        image = nil;
        imageData = nil;
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

+(UIBarButtonItem *)getIconNavigationBar:(SEL)selector
                               viewContr:(UIViewController *)viewContr
                              imageNamed:(NSString *)imageNamed
                                rect:(CGRect)rect{
    // Add Search Bar Button  
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *homeImage = [[UIImage imageNamed:imageNamed]  
                          stretchableImageWithLeftCapWidth:10 topCapHeight:10];  
    [button setBackgroundImage:homeImage forState:UIControlStateNormal];   
    [button setFrame:rect];
    [button addTarget:viewContr action:selector
           forControlEvents:UIControlEventTouchUpInside];  
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]  
                                     initWithCustomView:button];
    
    button = nil;
    homeImage = nil;
    return buttonItem;
}

+(UILabel *)getLabelTitleGaragesaleNavBar:(UITextAlignment *)textAlignment width:(int)width{    
    /* 
    set Navigation Title with OHAttributeLabel
    */
    NSString *titleNavItem = @"Garagesaleapp";
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:titleNavItem];
    [attrStr setFont:[UIFont fontWithName:@"Corben" size:16]];
    [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0]];
    [attrStr setTextColor:[UIColor colorWithRed:244.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.f]
                    range:[titleNavItem rangeOfString:@"app"]];
    [attrStr setFont:[UIFont fontWithName:@"Corben" size:14] range:[titleNavItem rangeOfString:@"app"]];

    CGRect frame = CGRectMake(0, 0, width, 36);
    OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setShadowColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
    [label setShadowOffset:CGSizeMake(0, -1)];
    label.attributedText = attrStr;
    label.textAlignment = textAlignment;
    titleNavItem = nil;
    attrStr = nil;
    return label;
}

+(UILabel *)getLabelTitleNavBarGeneric:(UITextAlignment *)textAlignment text:(NSString *)text width:(int)width{

    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:text];
    [attrStr setFont:[UIFont fontWithName:@"DroidSans-Bold" size:18]];
    [attrStr setTextColor:[UIColor whiteColor]];
    
    CGRect frame = CGRectMake(0, 0, width, 22);
    OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setShadowColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
    [label setShadowOffset:CGSizeMake(0, -1)];
    [label setAttributedText:attrStr];
    [label setTextAlignment:textAlignment];
    attrStr = nil;
    return label;
}

+(void)setSearchBarLayout:(UISearchBar *)searchBar{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:searchBar.bounds];
    backgroundView.image = [UIImage imageNamed:@"navBarBackground.png"];
    [searchBar insertSubview:backgroundView atIndex:1];
    [searchBar setTintColor:[UIColor whiteColor]];
    backgroundView = nil;
}

+(void)drawTagsButton:(NSArray *)tags scrollView:(UIScrollView *)scrollView viewController:(UIViewController *)viewController{
    //define x,y position
    //sumY draw y position
    int sumY = 0;
    int sumX = 0;
    static int margeTop = 270;
    int y = margeTop;
    int x;
    for(int i=0;i<[tags count];i++){
        //initial position x
        x = 20;
        
        GSCategory *category = [tags objectAtIndex:i];
        //get size of button string
        CGSize stringSize = [[category.descricao lowercaseString] sizeWithFont:[UIFont systemFontOfSize:14]]; 
        
        //set new position x
        if (sumX != 0)
            x = sumX;
        
        //draw Buttom
        UIButton *tagsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tagsButton.frame = CGRectMake(x, y, /* 135 */  stringSize.width+20 , 35);
        [tagsButton setTintColor:[UIColor greenColor]];
        [tagsButton setTag:(NSInteger)category.identifier];
        [tagsButton setTitle:[category.descricao lowercaseString] forState:UIControlStateNormal];
        [tagsButton.layer setMasksToBounds:YES];
        tagsButton.layer.cornerRadius = 5.0f;
        tagsButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.466666666666667 blue:0 alpha:0.7];
        tagsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [tagsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tagsButton setTitleColor:[UIColor blackColor] forState:UIControlEventTouchDown];
        [tagsButton addTarget:viewController action:@selector(gotoProductTableVC:) forControlEvents:UIControlEventTouchUpInside];
        
        //check if self.tags is out of bounds
        if ([tags count] > i+1)
            category = [tags objectAtIndex:i+1];
        
        //get size of next button string
        CGSize NextStringSize = [[category.descricao lowercaseString] sizeWithFont:[UIFont systemFontOfSize:14]]; 
        
        //check and set all new values control
        if ((sumX+20)+NextStringSize.width>200) {
            sumY++;
            y = (sumY*40)+margeTop;
            sumX=0;
        } else if (sumX == 0)
            sumX = stringSize.width + sumX + 45;
        else
            sumX = stringSize.width + sumX + 25;
        
        [scrollView addSubview:tagsButton];
    }
}

+(NSString *)getUrlImagesProduct:(NSArray *)product imageType:(imageType)imageType{
    @try {
        Product     *prd        = (Product *)[product objectAtIndex:0];
        Photo       *photo      = (Photo *)[[prd fotos] objectAtIndex:0];
        Caminho     *caminho    = (Caminho *)[[photo caminho] objectAtIndex:0];
        prd = nil;
        photo = nil;
        switch (imageType) {
            case imageTypeIcon:
                return [caminho icon];
                break;
            case imageTypeListing:
                return [caminho listing];
                break;
            case imageTypeListingScaled:
                return [caminho listingscaled];
                break;
            case imageTypeMobile:
                return [caminho mobile];
                break;
            case imageTypeOriginal:
                return [caminho original];
                break;
            default:
                break;
        }
    }
    @catch (NSException *exception) {
    }
    return NULL;
}

+(NSString *)formatAddressGarage:(NSArray *)array {
    NSString *locationName = @"";
    for (int i=0; i < [array count]; i++) {
        if (![[array objectAtIndex:i] isEqualToString:@""]) {
            if (i == 0)
                locationName = [array objectAtIndex:i];
            else
                locationName = [NSString stringWithFormat:@"%@, %@", locationName, [array objectAtIndex:i]];    
        }
    }

    if ([locationName isEqualToString:@""])
        return NSLocalizedString(@"no-location-yet", @"");
    
    else if ([[array objectAtIndex:0] isEqualToString:@""])
        locationName = [locationName substringWithRange:NSMakeRange(2, [locationName length]-2)];
        
    return locationName;
}

+(BOOL)isValidEmail:(NSString*) emailString {
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else
        return YES;
}

+(BOOL)isValidUrl:(NSString*) emailString {
    NSString *regExPattern = @"http?://([-\\w\\.]+)+(:\\d+)?(/([\\w/_\\.]*(\\?\\S+)?)?)?";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else
        return YES;
}

+(BOOL)onlyNumberKey:(NSString *)string{
	if ([string length] > 0) {
		int length = [string length];
		//reference characters www.theasciicode.com.ar/ascii-printable-characters/dot-full-stop-ascii-code-46.html
        int Char01;
        for (int x=0; x < length; x++) {
            Char01 = [string characterAtIndex:x];
            if ((Char01 < 44) || (Char01 > 57) || (Char01 == 47)) {
                if (length == 1) {
                    string = nil;
                    return NO;
                }
                else {
                    string = [string substringWithRange:NSMakeRange(0, length-1)];
                    return NO;
                }
            }
        }
	}
    return YES;
}

+(void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"activateTabBar"] forKey:@"oldTabBar"];  
    
    NSUInteger indexOfTab = [theTabBarController.viewControllers indexOfObject:viewController];
    [userDefaults setInteger:indexOfTab forKey:@"activateTabBar"];
    
    [userDefaults synchronize];
    userDefaults = nil;
    
    //NSLog(@"Tab index For Activate Tab Bar = %@", (NSInteger)[[GlobalFunctions getUserDefaults] objectForKey:@"activateTabBar"]);
    //NSLog(@"Tab index For Olt Tab Bar = %@", (NSInteger)[[GlobalFunctions getUserDefaults] objectForKey:@"oldTabBar"]);
}

+(NSMutableAttributedString *)getNamePerfil:(NSString *)garagem profileName:(NSString *)profileName{
    NSString *fullName = [NSString stringWithFormat:@"%@ @%@", profileName, garagem];
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString: fullName];
    
    [attrStr setFont:[UIFont fontWithName:@"DroidSans-Bold" size:20]];
    [attrStr setTextColor:[UIColor colorWithRed:153.0/255.0
                                          green:153.0/255.0
                                           blue:153.0/255.0
                                          alpha:1.f]
                    range:[fullName rangeOfString:[NSString stringWithFormat:@"@%@", garagem]]];
    
    [attrStr setTextColor:[UIColor colorWithRed:51.0/255.0
                                          green:51.0/255.0
                                           blue:51.0/255.0
                                          alpha:1.f]
                    range:[fullName rangeOfString:profileName]];
    
    [attrStr setFont:[UIFont fontWithName:@"Droid Sans" size:12]
               range:[fullName rangeOfString:[NSString stringWithFormat:@"@%@", garagem]]];
    
    return attrStr;
}

+(void)hideTabBar:(UITabBarController *) tabbarcontroller animated:(BOOL)animated {
    if (animated){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
    }
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
            [view setFrame:CGRectMake(view.frame.origin.x,
                                      [GlobalFunctions getTabPosition:tabPositionBottom],
                                      view.frame.size.width,
                                      view.frame.size.height)];
        else 
            [view setFrame:CGRectMake(view.frame.origin.x,
                                      view.frame.origin.y,
                                      view.frame.size.width,
                                      [GlobalFunctions getTabPosition:tabPositionBottom])];
    }
    if (animated) [UIView commitAnimations];
}

+(void)showTabBar:(UITabBarController *) tabbarcontroller {
    if ([[GlobalFunctions getUserDefaults] objectForKey:@"token"] != nil){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        for(UIView *view in tabbarcontroller.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                [view setFrame:CGRectMake(view.frame.origin.x,
                                          [GlobalFunctions getTabPosition:tabPositionTop],
                                          view.frame.size.width,
                                          view.frame.size.height)];
            } 
            else 
            {
                [view setFrame:CGRectMake(view.frame.origin.x,
                                          view.frame.origin.y,
                                          view.frame.size.width,
                                          [GlobalFunctions getTabPosition:tabPositionTop])];
            }
        }
        [UIView commitAnimations];
    }
}

+(UIImage*)scaleToSize:(CGSize)size imageOrigin:(UIImage *)imageOrigin {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), imageOrigin.CGImage);
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(NSString *)getCurrencyByCode:(NSString*)currencyCode{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Currencies" ofType:@"plist"];
    //the key of dictionary : Root > Currency > Name/Rate/Symbol
    NSDictionary* dictCurrency =  [NSDictionary dictionaryWithContentsOfFile:path];

    NSDictionary *dictByCurrencyCode;
    for (id key in dictCurrency)
    {
        if ([currencyCode isEqualToString:key])
            dictByCurrencyCode = [dictCurrency objectForKey:key];
    }
    
    NSArray *array = [dictByCurrencyCode allValues];
    path = nil;
    //index 1 is a Symbol currency
    dictByCurrencyCode = nil;
    dictCurrency = nil;
    
    NSString *currency = [array objectAtIndex:1];
    array = nil;
    
    return currency;
}

+(void)setNavigationBarBackground:(UINavigationController *)navController{
    [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] 
    forBarMetrics:UIBarMetricsDefault];
    //[navController.navigationController.navigationBar setTintColor:[self getColorRedNavComponets]];
    [navController.navigationItem setHidesBackButton:YES];
    UILabel *lab = [self getLabelTitleGaragesaleNavBar:UITextAlignmentLeft width:300];
    [navController.navigationItem setTitleView:lab];
    lab = nil;
}

+(void)setActionSheetAddProduct:(UITabBarController *)tabBarController clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    // (0)@"Camera", (1)@"Library", (2)@"Product without pics"
    [userDefaults setInteger:buttonIndex forKey:@"controlComponentsAtFirstDisplay"];

    //buttonIndex == 3 is Cancel Button on ActionSheet
    if (buttonIndex == 3){
        [userDefaults setBool:NO forKey:@"isProductDisplayed"];
    }else{
        [tabBarController setSelectedIndex:1];
       // productAccountViewController *prdtAcc = [[productAccountViewController alloc] init];
       // [tabBarController addChildViewController:prdtAcc];
    }
    
    [userDefaults synchronize];
    userDefaults = nil;
    buttonIndex = nil;
}

+ (UIImage *)generatePhotoThumbnail:(UIImage *)image {
    // Create a thumbnail version of the image for the event object.
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat ratio = 70.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    return thumbnail;
}

@end
