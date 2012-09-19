//
//  GlobalFunctions.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 17/05/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "GlobalFunctions.h"
#import <CommonCrypto/CommonDigest.h> //CC_MD5
#import "NSAttributedString+Attributes.h"

@implementation GlobalFunctions

static NSString *urlServicePath;
static NSString *urlImagePath;

@synthesize imageThumbsXorigin_Iphone;
@synthesize imageThumbsYorigin_Iphone;
@synthesize countColumnImageThumbs;

+(NSString *)getUrlServicePath {
    //urlServicePath = @"http://gsapi.local";
    urlServicePath = @"http://gsapi.easylikethat.com"; 
    //urlServicePath = @"http://api.garagesaleapp.me";    
    return urlServicePath; 
}

+(NSString *)getUrlImagePath {
    //urlImagePath = @"http://garagesale.local/";
    urlImagePath = @"http://gsapp.easylikethat.com"; 
    //urlImagePath = @"http://www.garagesaleapp.me"; 
    return urlImagePath; 
}

+(NSUserDefaults *)getUserDefaults {
    return [NSUserDefaults standardUserDefaults];
}

+(UIColor *)getColorRedNavComponets {
    return [UIColor colorWithRed:219.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0]; 
}

- (UIView *)loadButtonsThumbsProduct:(NSArray *)arrayDetailProduct showEdit:(BOOL)showEdit showPrice:(BOOL)showPrice viewContr:(UIViewController *)viewContr {
    
    Product     *product    = (Product  *)[arrayDetailProduct objectAtIndex:0];
    NSString    *urlThumb   = [NSString stringWithFormat:@"%@/%@", 
                              [GlobalFunctions getUrlImagePath], [[product fotos] caminhoThumb]];
    NSData      *imageData  = [[NSData alloc] initWithContentsOfURL:
                               [NSURL URLWithString:urlThumb]];
    UIImage     *image      = ([product fotos] == NULL) ? [UIImage imageNamed:@"nopicture.png"] 
                                                        : [[UIImage alloc] initWithData:imageData];
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
    
    //ActivityIndicator
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] 
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame = spinner.frame;
    frame.origin.x = viewThumbs.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = viewThumbs.frame.size.height / 2 - frame.size.height / 2;
    spinner.frame = frame;
    [viewThumbs addSubview:spinner];
    [spinner startAnimating];

    //Button Product
    UIButton *buttonThumbsProduct  = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonThumbsProduct.frame      = CGRectMake(0, 0, 94, 94);
    [buttonThumbsProduct setTag:[[arrayDetailProduct objectAtIndex:1] intValue]];
    [buttonThumbsProduct addTarget:viewContr action:@selector(gotoProductDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    [buttonThumbsProduct setImage:image forState:UIControlStateNormal];
    [viewThumbs addSubview:buttonThumbsProduct];
    
    //if (image) [spinner stopAnimating];
    
    UIGraphicsEndImageContext();

    if (showPrice) {
        //Set View Price
        UIView *viewPrice = [[UIView alloc] init];
        
        viewPrice.layer.cornerRadius = 4;
        viewPrice.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        [viewThumbs addSubview:viewPrice];
        
        //Set Label Only
        UILabel *only = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 30, 20)];
        [only setText:@"ONLY"];
        only.backgroundColor = [UIColor clearColor];
        [only setFont:[UIFont fontWithName:@"Droid Sans" size:10]];
        [viewPrice addSubview:only];
        
        //Set Label Price
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(13, 12, 50, 20)];
        [price setText:[NSString stringWithFormat:@"R$%@", product.valorEsperado]];
        //[price setAdjustsFontSizeToFitWidth:YES];
        [price sizeToFit];
        price.backgroundColor = [UIColor clearColor];
        price.textColor = [UIColor colorWithRed:91.0/255.0 green:148.0/255.0 blue:67.0/255.0 alpha:1.0];
        [price setFont:[UIFont fontWithName:@"Droid Sans" size:16]];
        [viewPrice addSubview:price];
        [viewPrice setFrame:CGRectMake(-5, 45, price.bounds.size.width+15, 35)];   
    }
    
    if (showEdit) {
        //View Edit Pencil
        UIImageView *imageViewEditPencil = [[UIImageView alloc] initWithImage:
                                            [UIImage imageNamed:@"btPencilEditProductThumbs.png"]];
        [imageViewEditPencil setFrame:CGRectMake(5, 5, 24, 22)];
        [viewThumbs addSubview:imageViewEditPencil];
    }
    
    return viewThumbs;
}

+(UIBarButtonItem *)getIconNavigationBar:(SEL)selector viewContr:(UIViewController *)viewContr imageNamed:(NSString *)imageNamed{
    // Add Search Bar Button  
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];  
    UIImage *homeImage = [[UIImage imageNamed:imageNamed]  
                          stretchableImageWithLeftCapWidth:10 topCapHeight:10];  
    [button setBackgroundImage:homeImage forState:UIControlStateNormal];   
    button.frame = CGRectMake(0, 0, 38, 32);
    [button addTarget:viewContr action:selector
           forControlEvents:UIControlEventTouchUpInside];  
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]  
                                     initWithCustomView:button];      
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
    [label setShadowColor:[UIColor redColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    label.attributedText = attrStr;
    label.textAlignment = textAlignment;
    
    return label;
}

+(UILabel *)getLabelTitleNavBarGeneric:(UITextAlignment *)textAlignment width:(int)width{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    label.textAlignment = textAlignment;
    label.font = [UIFont fontWithName:@"Droid Sans" size:20];
    return label;
}

+(void)setSearchBarLayout:(UISearchBar *)searchBar{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:searchBar.bounds];
    backgroundView.image = [UIImage imageNamed:@"navBarBackground.png"];
    [searchBar insertSubview:backgroundView atIndex:1];
    searchBar.tintColor = [GlobalFunctions getColorRedNavComponets];
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
        
        Category *category = [tags objectAtIndex:i];
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
        tagsButton.layer.masksToBounds = YES;
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

+(void)onlyNumberKey:(UITextField *)textField{
	if ([textField.text length] > 0) {
		int length = [textField.text length];
		int Char01 = [textField.text characterAtIndex:length-1];
		//reference characters www.theasciicode.com.ar/ascii-printable-characters/dot-full-stop-ascii-code-46.html
		if ((Char01 < 44) || (Char01 > 57) || (Char01 == 47)) {
			if (length == 1) {
				textField.text = nil;
			}
			else {
				textField.text = [textField.text substringWithRange:NSMakeRange(0, length-1)];
			}
		}
	}
}

+(void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[GlobalFunctions getUserDefaults] objectForKey:@"activateTabBar"] forKey:@"oldTabBar"];  
    
    NSUInteger indexOfTab = [theTabBarController.viewControllers indexOfObject:viewController];
    [userDefaults setInteger:indexOfTab forKey:@"activateTabBar"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"Tab index For Activate Tab Bar = %@", (NSInteger)[[GlobalFunctions getUserDefaults] objectForKey:@"activateTabBar"]);
    //NSLog(@"Tab index For Olt Tab Bar = %@", (NSInteger)[[GlobalFunctions getUserDefaults] objectForKey:@"oldTabBar"]);
}

+(void)hideTabBar:(UITabBarController *) tabbarcontroller {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    [UIView commitAnimations];
}

+(void)showTabBar:(UITabBarController *) tabbarcontroller {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        //NSLog(@"%@", view);
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
    [UIView commitAnimations]; 
}

+ (NSURL*) getGravatarURL:(NSString*) emailAddress {
	NSString *curatedEmail = [[emailAddress stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceCharacterSet]]
							  lowercaseString];
    
	const char *cStr = [curatedEmail UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    
	NSString *md5email = [NSString stringWithFormat:
                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15]
                          ];
	NSString *gravatarEndPoint = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=512", md5email];
    
	return [NSURL URLWithString:gravatarEndPoint];
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
    NSMutableDictionary *dictLang = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"en_US", @"en_US", @"en_US", @"pt_BR", nil] forKeys:[NSArray arrayWithObjects:@"USD", @"EUR", @"GBP", @"BRL", nil]];
    
//    [dictLang setObject:@"en_US" forKey:@"USD"];
//    [dictLang setObject:@"en_US" forKey:@"EUR"];
//    [dictLang setObject:@"en_US" forKey:@"GBP"];
//    [dictLang setObject:@"pt_BR" forKey:@"BRL"];

//    NSLog(@"%@",[dictLang valueForKey:[NSString stringWithString:currencyCode]]);
    
    NSLocale *lcl = [[NSLocale alloc] initWithLocaleIdentifier:
                     [NSString stringWithString:[dictLang valueForKey:[NSString stringWithString:currencyCode]]]];
    
    return [lcl displayNameForKey:NSLocaleCurrencySymbol value:currencyCode];
}

/*+(void)setProductMapping:(RKObjectMapping *)productMapping{
    //Configure Product Object Mapping
    productMapping = [RKObjectMapping mappingForClass:[Product class]];    
    [productMapping mapKeyPath:@"sold"          toAttribute:@"sold"];
    [productMapping mapKeyPath:@"showPrice"     toAttribute:@"showPrice"];
    [productMapping mapKeyPath:@"currency"      toAttribute:@"currency"];
    [productMapping mapKeyPath:@"categorias"    toAttribute:@"categorias"];
    [productMapping mapKeyPath:@"valorEsperado" toAttribute:@"valorEsperado"];    
    [productMapping mapKeyPath:@"descricao"     toAttribute:@"descricao"];
    [productMapping mapKeyPath:@"nome"          toAttribute:@"nome"];
    [productMapping mapKeyPath:@"idEstado"      toAttribute:@"idEstado"];
    [productMapping mapKeyPath:@"idPessoa"      toAttribute:@"idPessoa"];
    [productMapping mapKeyPath:@"id"            toAttribute:@"id"];
}*/



@end
