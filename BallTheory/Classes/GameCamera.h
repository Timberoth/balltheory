//
//  GameCamera.h
//  BallTheory
//
//  Created by Timothy Lambert on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface GameCamera : NSObject {
	
	// normalised.  i.e. 1.0 = 100%
	float zoom;  
	
	// to store the last value of the camera.
	float currX;
	float currY;  
	
	// gameController
	CCScene *controller;  
	
}
@property float zoom;

-(BOOL)initWithController:(CCScene*)c;

// move it relative to its current position
-(void)panCameraBy:(CGPoint)deltaPos;  

// to set it to a specific spot at any point in time.
-(void)moveCameraTo:(CGPoint)movePos; 

-(CGPoint)position;

@end
