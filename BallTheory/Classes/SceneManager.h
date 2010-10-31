//
//  SceneManager.h
//  BallTheory
//
//  Created by Tim on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import "CommonScene.h"

extern unsigned int SCENE_MAINMENU;
extern unsigned int SCENE_LEVELSELECT;
extern unsigned int SCENE_GAMEPLAY;
extern unsigned int SCENE_CREDITS;


@interface SceneManager : NSObject {
	
	// Keep list of all scenes
	NSArray* mScenes;
}
	
	// Initialization
	- (BOOL) init;
	
	// Purge
	- (void) purge;

	// Switch to scene
	- (void) switchToScene;


@end
