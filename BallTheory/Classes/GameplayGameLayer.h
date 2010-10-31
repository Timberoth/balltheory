//
//  GameplayGameLayer.h
//  BallTheory
//
//  Created by Tim on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonLayer.h"

// Cocos2d
#import "cocos2d.h"
#import "CCLayer.h"

// Chipmunk
#import "chipmunk.h"

@interface GameplayGameLayer : CommonLayer {
	cpSpace* mGlobalSpace;
	cpBody* mGlobalStaticBody;
	
	bool mDestroyContainer;
	
	NSMutableArray* adder;
	cpBody* spinner;
	
	cpShape* containerCap;
	
	int capCounter;
	
}

// Initialize physics system
- (void) initChipmunk;

// Convert to game coordinates.
-(CGPoint) convertTouchToGameCoords:(UITouch*)touch;

@end
