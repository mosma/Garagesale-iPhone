//
//  Tile.h
//  garagesaleapp
//
//  Created by Tarek Jradi on 20/11/12.
//  Copyright (c) 2012 MOSMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CAGradientLayer.h>


@interface Tile : CAGradientLayer {
    int tileIndex;
}

@property (nonatomic) int tileIndex;

- (void)draw;

- (void)appearDraggable;

- (void)appearNormal;

- (void)startWiggling;

- (void)stopWiggling;

@end
