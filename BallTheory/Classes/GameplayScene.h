//
//  GameplayScene.h
//  BallTheory
//
//  Created by Timothy Lambert on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import "CommonScene.h"
#import "GameplayGameLayer.h"
#import "GameplayUILayer.h"

// Ball Theory
#import "GameCamera.h"



@interface GameplayScene : CommonScene {

	// The Gameplay scene is where all the of the "game" action occurs.
	// It is composed of the Gameplay layer where the machines and balls live and the
	// UI layer where all the menu selection and scoring happens.
	GameplayGameLayer* mGameplayLayer;
	
	GameplayUILayer* mUILayer;
	
	// Game Camera
	GameCamera* mCamera;
	
	// Camera Movement Toggle
	bool mCameraMovement;
	
	CGPoint mTouchStart;
	
}

@property (readwrite, assign)GameCamera* mCamera;

@property (readwrite, assign)bool mCameraMovement;

@property (readwrite, assign)CGPoint mTouchStart;


- (bool) initScene;

- (void) purgScene;

@end
