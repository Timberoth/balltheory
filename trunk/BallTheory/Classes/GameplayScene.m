//
//  GameplayScene.m
//  BallTheory
//
//  Created by Timothy Lambert on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import "GameplayScene.h"


@implementation GameplayScene

@synthesize mCamera;
@synthesize mCameraMovement;
@synthesize mTouchStart;

-(bool) initScene
{
	mGameplayLayer = [GameplayGameLayer alloc];
	
	// Failed to allocate the required memory, bail out.
	if( !mGameplayLayer )
		return false;
	
	[mGameplayLayer initLayer:self];
	
	mUILayer = [GameplayUILayer alloc];
	
	// Failed to allocate the required memory, bail out.
	if( !mUILayer )
		return false;
	
	[mUILayer initLayer:self];

		
	// Initialize GameCamera
	mCameraMovement = false;

	mCamera = [GameCamera alloc];
	if( mCamera == NULL )
	{
		printf("Failed to create the Game Camera.");
		
		// Need to bail out gracefully here.
	}
	else 
	{
		[ mCamera initWithController:self ];
		
		// Look at the center of the screen
		CGPoint point = CGPointMake(160.0, 240.0);
		[ mCamera moveCameraTo:point ]; 
	}
	
	
	// MenuLayer must be added before GameLayer to render properly.
	[self addChild: mUILayer];
	[self addChild: mGameplayLayer];
	
	
	
	return true;
}

-(void) purgScene
{
	// Free up all layers
	if( mGameplayLayer )
	{
		[mGameplayLayer purgeLayer];
		[mGameplayLayer dealloc];
		mGameplayLayer = NULL;
	}
	
	if( mUILayer )
	{
		[mUILayer purgeLayer];
		[mUILayer dealloc];
		mUILayer = NULL;
	}
	
}

@end
