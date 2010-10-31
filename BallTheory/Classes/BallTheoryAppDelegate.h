//
//  BallTheoryAppDelegate.h
//  BallTheory
//
//  Created by Timothy Lambert on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import <UIKit/UIKit.h>

// Cocos2d
#import "cocos2d.h"

// Ball Theory
#import "SceneManager.h"


// BallTheoryAppDelegate
@interface BallTheoryAppDelegate : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIApplicationDelegate> {
	
	// Pointer to the application window
	UIWindow *window;
	
	
	// SceneManager
	SceneManager* mSceneManager;
	
	//
}

@end


