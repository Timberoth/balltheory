//
//  GameCamera.h
//  BallTheory
//
//  Created by Tim on 10/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface GameCamera : NSObject {
	
	// normalised.  i.e. 1.0 = 100%
	float zoomLevel;  
	
	// to store the last value of the camera.
	float currX;
	float currY;  
	
	// gameController
	CCScene *controller;  
	
}

-(BOOL)initWithController:(CCScene*)c;

// move it relative to its current position
-(void)panCameraBy:(CGPoint)deltaPos;  

// to set it to a specific spot at any point in time.
-(void)moveCameraTo:(CGPoint)movePos; 

-(CGPoint)position;

-(float)zoom;

@end
