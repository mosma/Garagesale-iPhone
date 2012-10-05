//
//  galleryScrollViewController.m
//  garagesaleapp
//
//  Created by Tarek Jradi on 11/01/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import "galleryScrollViewController.h"
#import "ProductPhotos.h"
#import "Photo.h"
#import "GlobalFunctions.h"
#import "QuartzCore/QuartzCore.h"

@implementation galleryScrollViewController

@synthesize RKObjManeger;
@synthesize productPhotos;
@synthesize idPessoa;
@synthesize idProduto;
@synthesize imageView;
@synthesize zoomView;
@synthesize galleryScrollView;
@synthesize PagContGallery;
@synthesize activityIndicator;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    zoomView                    = [[UIView alloc] init];
    PagContGallery.hidden       = YES;
    RKObjManeger                     = [RKObjectManager objectManagerWithBaseURL:[GlobalFunctions getUrlServicePath]];
    [self setupProductMapping:[NSString stringWithFormat:@"/product/%@/?idProduct=%@", self.idPessoa, self.idProduto]];
}

- (void)setupProductMapping:(NSString *)localResource {
    //Initializing the Object Manager
    RKObjManeger = [RKObjectManager sharedManager];
    
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
    RKObjectMapping *productMapping = [RKObjectMapping mappingForClass:[ProductPhotos class]];    
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
    //Relationship
    [productMapping mapKeyPath:@"fotos" toRelationship:@"fotos" withMapping:photoMapping serialize:NO];
    //LoadUrlResourcePath
    [self.RKObjManeger loadObjectsAtResourcePath:localResource objectMapping:productMapping delegate:self];
    
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/plain"];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    self.productPhotos = (NSMutableArray *)objects;
    [self loadAttribsToComponents];
    [activityIndicator stopAnimating];
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

- (void)loadAttribsToComponents{
    int countPhotos = (int)[[[productPhotos objectAtIndex:0] fotos ] count];
    for (int i = 0; i < countPhotos; i++){
        
        imageView = [UIImageView alloc];
        
      //  NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [GlobalFunctions getUrlImagePath], [[[[productPhotos objectAtIndex:0]fotos]objectAtIndex:i]caminho]]];
        
       // NSLog(@"url object at index %i is %@",i,url);
        
       // UIImage *image          = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
       // imageView               =[[UIImageView alloc] initWithImage:image];
        CGRect rect             =imageView.frame;
        rect.size.width         = 320;
        rect.origin.x           = i*320;
        imageView.frame         =rect;
        imageView.contentMode   = UIViewContentModeScaleAspectFit;
        [galleryScrollView addSubview:imageView];
        /*
         galleryScrollView.minimumZoomScale = 0.25;
         galleryScrollView.maximumZoomScale = 4.0;
         [galleryScrollView setZoomScale:galleryScrollView.minimumZoomScale];
         */
    }
    galleryScrollView.contentSize           = CGSizeMake(self.view.frame.size.width * countPhotos, self.view.frame.size.height);
    galleryScrollView.pagingEnabled         = YES;
    galleryScrollView.delegate              = self;
    galleryScrollView.clipsToBounds         = YES;
    galleryScrollView.autoresizesSubviews   = YES;
    PagContGallery.numberOfPages        = countPhotos; 
    PagContGallery.hidden               = NO;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    imageView.frame = [self centeredFrameForScrollView:scrollView andUIView:imageView];
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    CGSize boundsSize    = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     PagContGallery.currentPage = galleryScrollView.contentOffset.x / self.view.frame.size.width;
}

-(IBAction)pageControlCliked{
    CGPoint offset = CGPointMake(PagContGallery.currentPage * self.view.frame.size.width, 0);
    [galleryScrollView setContentOffset:offset animated:YES];
}

- (void)viewDidUnload
{
    activityIndicator = nil;
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
