//
//  BallTheoryAppDelegate.h
//  BallTheory
//
//  Created by Tim on 9/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "cpMouse.h"


@interface GameLayer : Layer {
	cpMouse* mouse;
}

- (void) initChipmunk;

// as cancelled and up do the same thing
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface BallTheoryAppDelegate : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIApplicationDelegate> {
	UIWindow *window;
}

@end


