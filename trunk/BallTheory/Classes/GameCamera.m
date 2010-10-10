//
//  GameCamera.m
//  BallTheory
//
//  Created by Tim on 10/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameCamera.h"


@implementation GameCamera

-(BOOL)initWithController:( CCScene* )c
{
	controller = c;
	currX = 0.0f;
	currY = 0.0f;
	zoomLevel = 1.0f;
	controller = c;
	
	if(c == NULL )
		return FALSE;
		
	return TRUE;
}


// move it relative to its current position
-(void)panCameraBy:(CGPoint)deltaPos
{
	currX += deltaPos.x;
	currY += deltaPos.y;
}


// to set it to a specific spot at any point in time.
-(void)moveCameraTo:(CGPoint)movePos
{
	currX = movePos.x;
	currY = movePos.y;
	
	// Update camera rendering?
}


-(CGPoint)position
{
	CGPoint point;
	point.x  = currX;
	point.y = currY;
	return point;
}



-(float)zoom
{
	return zoomLevel;
}


@end
