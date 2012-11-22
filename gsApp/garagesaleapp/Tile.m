#import "Tile.h"
#import <QuartzCore/QuartzCore.h>


@interface Tile ()
- (void)setGlossGradientProperties;
- (CAAnimation *)wiggleRotationAnimation;
- (CAAnimation *)wiggleTranslationYAnimation;
@end


@implementation Tile

@synthesize tileIndex;


#pragma mark -
#pragma mark Initialization


- (id)init {
    self = [super init];
    if (self) {
        [self setGlossGradientProperties];
    }
    return self;
}


- (void)setGlossGradientProperties {
    static NSArray *colors = nil;
    if (colors == nil) {
        colors = [NSArray arrayWithObjects:
                  (id)[UIColor colorWithWhite:1.0f alpha:0.50f].CGColor,
                  (id)[UIColor colorWithWhite:1.0f alpha:0.12f].CGColor,
                  (id)[UIColor colorWithWhite:1.0f alpha:0.00f].CGColor,
                  (id)[UIColor colorWithWhite:1.0f alpha:0.00f].CGColor,
                  (id)[UIColor colorWithWhite:1.0f alpha:0.25f].CGColor,
                  nil];
    }
    
    static NSArray *locations = nil;
    if (locations == nil) {
        locations = [NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:0.0f],
                     [NSNumber numberWithFloat:0.5f],
                     [NSNumber numberWithFloat:0.5f],
                     [NSNumber numberWithFloat:0.85f],
                     [NSNumber numberWithFloat:1.0f],
                     nil];
    }
    
    self.colors = colors;
    self.locations = locations;
}


#pragma mark -
#pragma mark Drawing


- (void)draw {
    NSString *labelText = [NSString stringWithFormat:@"%d", (int)tileIndex];
    
    UIFont *font = [UIFont boldSystemFontOfSize:36.0f];
    [[UIColor whiteColor] set];
    //[labelText drawCenteredInRect:self.bounds withFont:font];
}


#pragma mark -
#pragma mark Draggable animation


- (void)appearDraggable {
    self.opacity = 0.6f;
    [self setValue:[NSNumber numberWithFloat:1.25f] forKeyPath:@"transform.scale"];
}


- (void)appearNormal {
    self.opacity = 1.0f;
    [self setValue:[NSNumber numberWithFloat:1.0f] forKeyPath:@"transform.scale"];
}


#pragma mark -
#pragma mark Wiggle animation


- (void)startWiggling {
    CAAnimation *rotationAnimation = [self wiggleRotationAnimation];
    [self addAnimation:rotationAnimation forKey:@"wiggleRotation"];
    
    CAAnimation *translationYAnimation = [self wiggleTranslationYAnimation];
    [self addAnimation:translationYAnimation forKey:@"wiggleTranslationY"];
}


- (void)stopWiggling {
    [self removeAnimationForKey:@"wiggleRotation"];
    [self removeAnimationForKey:@"wiggleTranslationY"];
}


- (CAAnimation *)wiggleRotationAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.05f],
                   [NSNumber numberWithFloat:0.05f],
                   nil];
    anim.duration = 0.09f + ((tileIndex % 10) * 0.01f);
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    return anim;
}


- (CAAnimation *)wiggleTranslationYAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1.0f],
                   [NSNumber numberWithFloat:1.0f],
                   nil];
    anim.duration = 0.07f + ((tileIndex % 10) * 0.01f);
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    anim.additive = YES;
    return anim;
}


@end