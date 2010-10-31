//
//  SceneManager.m
//  BallTheory
//
//  Created by Tim on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import "SceneManager.h"
#import "MainMenuScene.h"
#import "LevelSelectScene.h"
#import "GameplayScene.h"
#import "CreditsScene.h"

@implementation SceneManager


unsigned int SCENE_MAINMENU = 0;
unsigned int SCENE_LEVELSELECT = 1;
unsigned int SCENE_GAMEPLAY = 2;
unsigned int SCENE_CREDITS = 3;


// Initialization
- (void) init
{	
	// Create every scene
	MainMenuScene* mainMenu = [[MainMenuScene alloc] init];
	[mainMenu initScene];
	
	LevelSelectScene* levelSelect = [[LevelSelectScene alloc] init];
	[levelSelect initScene];
	
	GameplayScene* gamePlay = [[GameplayScene alloc] init];
	[gamePlay initScene];
	
	CreditsScene* credits = [[CreditsScene alloc] init];
	[credits initScene];
	
	// Add the scenes to the array.
	mScenes = [NSArray arrayWithObjects:mainMenu, levelSelect, gamePlay, credits, nil];
	
	// Get the starting scene running
	
	// HACK - For now start with the gameplay scene.
	//[ [CCDirector sharedDirector] runWithScene: [ mScenes objectAtIndex:SCENE_GAMEPLAY ] ];

	return true;
}


// Purge
- (void) purge
{
	
}


// Switch to scene
- (void) switchToScene
{
	
}


@end
