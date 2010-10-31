//
//  BallTheoryAppDelegate.m
//  Ball Theory
//
//  Created by Timothy Lambert on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import "BallTheoryAppDelegate.h"
#import "GameCamera.h"

#import "chipmunk.h"

@implementation BallTheoryAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// NEW: Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	//[window setMultipleTouchEnabled:YES];
	
	//[[Director sharedDirector] setLandscape: YES];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	[[CCDirector sharedDirector] attachInWindow:window];
	
	// Create the SceneManager
	mSceneManager = [[SceneManager alloc] init];
	
	[window makeKeyAndVisible];
}


-(void) applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}


-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{

}

@end
