//
//  GlobalFunctions.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 17/05/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "GlobalFunctions.h"

@implementation GlobalFunctions

static NSString *urlServicePath;

+(NSString *)getUrlServicePath {
    urlServicePath = @"http://gsapi.easylikethat.com";
    //urlServicePath = @"http://api.garagesaleapp.me";    
    return urlServicePath; 
}

+(UIColor *)getColorRedNavComponets {
    return [UIColor colorWithRed:219.0/255.0                                                                         green:87.0/255.0 blue:87.0/255.0 alpha:1.0]; 
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
		int I01 = [textField.text length];
		int Char01 = [textField.text characterAtIndex:I01-1];
		//check and accept input if last character is a number from 0 to 9, accept("." 46), reject("/" 47)
		if ((Char01 < 46) || (Char01 > 57) || (Char01 == 47)) {
			if (I01 == 1) {
				textField.text = nil;
			}
			else {
				textField.text = [textField.text substringWithRange:NSMakeRange(0, I01-1)];
			}
		}
	}
}

+ (void)roundedLayer:(CALayer *)viewLayer radius:(float)r shadow:(BOOL)s{
    [viewLayer setMasksToBounds:YES];
    viewLayer.cornerRadius = 5;
    [viewLayer setCornerRadius:r];        
   // [viewLayer setBorderColor:[RGB(180, 180, 180) CGColor]];
    [viewLayer setBorderWidth:1.0f];
    //if(s)
  //  {
        [viewLayer setShadowColor:[[UIColor blackColor] CGColor]];
        [viewLayer setShadowOffset:CGSizeMake(1, 1)];
       //[viewLayer setShadowOpacity:1];
       // [viewLayer setShadowRadius:1.0];
    //}
    return;
}

+(void)setTextFieldForm:(UITextField *)textField{
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = [[UIColor grayColor] CGColor];
    textField.layer.cornerRadius = 5.0f;
    textField.layer.backgroundColor = [[UIColor whiteColor] CGColor];

    textField.frame = CGRectMake(textField.frame.origin.x, 
                                           textField.frame.origin.y, 
                                           textField.frame.size.width, 38); 
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
