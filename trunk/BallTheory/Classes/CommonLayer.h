//
//  CommonLayer.h
//  BallTheory
//
//  Created by Tim on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLayer.h"

// Ball Theory
#import "CommonScene.h"


@interface CommonLayer : CCLayer {

	CommonScene* mParentScene;
}

-(BOOL) initLayer:CommonScene;

-(void) purgeLayer;

@end
