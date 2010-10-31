//
//  Helpers.m
//  grabbed too
//
//  Created by benmaslen on 14/03/2009.
//  Copyright 2009 ortatherox.com. All rights reserved.
// 
//  Modified by Tim Lambert on 10/09/2010
//

#import "chipmunk.h"


cpBody* makeCircle( cpSpace* space, int radius){
	int num = 4;
	cpVect verts[] = {
		cpv(-radius, -radius),
		cpv(-radius, radius),
		cpv( radius, radius),
		cpv( radius, -radius),
	};
	
	float elasticity = 0.75f;
	float friction = 0.5f;


	// all physics stuff needs a body
	cpBody *body = cpBodyNew(1.0, cpMomentForPoly(1.0, num, verts, cpvzero));
	cpSpaceAddBody(space, body);
	// and a shape to represent its collision box
	cpShape* shape = cpCircleShapeNew(body, radius, cpvzero);
	shape->e = elasticity; 
	shape->u = friction;
	cpSpaceAddShape(space, shape);
	return body;
}

void makeStaticBox(cpSpace* space, cpBody* staticBody, float x, float y, float width, float height){
  cpShape * shape;
  shape = cpSegmentShapeNew(staticBody, cpv(x,y), cpv(x+width, y), 0.0f);
  shape->e = 1.0; shape->u = 1.0;
  cpSpaceAddStaticShape(space, shape);
  
  shape = cpSegmentShapeNew(staticBody, cpv(x+width, y), cpv(x+width, y+height ), 0.0f);
  shape->e = 1.0; shape->u = 1.0;
  cpSpaceAddStaticShape(space, shape);
  
  shape = cpSegmentShapeNew(staticBody, cpv(x+width, y+height), cpv(x, y+height ), 0.0f);
  shape->e = 1.0; shape->u = 1.0;
  cpSpaceAddStaticShape(space, shape);
  
  shape = cpSegmentShapeNew(staticBody, cpv(x, y+height ), cpv(x, y), 0.0f);
  shape->e = 1.0; shape->u = 1.0;
  cpSpaceAddStaticShape(space, shape);
}


// x and y is the top left vertex
NSMutableArray* createContainer( cpSpace* space, cpBody* staticBody, float x, float y ) 
{  
	// Create empty array for shapes
	NSMutableArray  *shapes = [[NSMutableArray alloc] init];
	
	float scale = 1.5;
	float w = 75.0f * scale;
	float h = 50.0f * scale;
	float w2 = 27.5f * scale;
	float h2 = 27.5f * scale;
	
	// Calculate proper offsets so that the container is centered around (x,y)
	x = x - w/2.0;
	y = y + (h+h2)/2.0;
	
	float elasticity = 0.75f;
	float friction = 0.5f;
	 
	
	cpShape * shape;
	shape = cpSegmentShapeNew(staticBody, cpv(x,y), cpv(x+w, y), 0.0f);
	shape->e = elasticity;
	shape->u = friction;
	cpSpaceAddStaticShape(space, shape);
	[shapes addObject:[NSValue valueWithPointer:shape]];
	
	shape = cpSegmentShapeNew(staticBody, cpv(x+w, y), cpv(x+w, y-h ), 0.0f);
	shape->e = elasticity;
	shape->u = friction;
	cpSpaceAddStaticShape(space, shape);
	[shapes addObject:[NSValue valueWithPointer:shape]];
	
	shape = cpSegmentShapeNew(staticBody, cpv(x+w, y-h), cpv(x+w-w2, y-h-h2 ), 0.0f);
	shape->e = elasticity;
	shape->u = friction;
	cpSpaceAddStaticShape(space, shape);
	[shapes addObject:[NSValue valueWithPointer:shape]];
	
	shape = cpSegmentShapeNew(staticBody, cpv(x+w2, y-h-h2 ), cpv(x, y-h), 0.0f);
	shape->e = elasticity;
	shape->u = friction;
	cpSpaceAddStaticShape(space, shape);
	[shapes addObject:[NSValue valueWithPointer:shape]];
	
	shape = cpSegmentShapeNew(staticBody, cpv(x, y-h), cpv(x, y), 0.0f);
	shape->e = elasticity;
	shape->u = friction;
	cpSpaceAddStaticShape(space, shape);
	[shapes addObject:[NSValue valueWithPointer:shape]];
	
	return shapes;
}


void destroyContainer( cpSpace* space, NSMutableArray* container )
{
	if( !container )
		return;
	
	for( int i = 0; i < [container count]; i++ )
	{
		cpShape* shape = (cpShape*)[[container objectAtIndex:i] pointerValue];
		cpSpaceRemoveStaticShape( space, shape );
		cpShapeFree( shape );
	}
	
	[container release];
	
	// The pointer must be nulled out outside of this function.
}


cpBody* createSpinner( cpSpace* space, cpBody* staticBody, float x, float y )
{
	int num = 4;
	int width = 85.0;
	int halfwidth = width/2.0;
	int height = 5.0;
	int halfheight = height/2.0;
	cpVect verts[] = {
		cpv(-halfwidth, -halfheight),
		cpv(-halfwidth, halfheight),
		cpv( halfwidth, halfheight),
		cpv( halfwidth, -halfheight),
	};
	
	// Create body
	cpBody *body = cpBodyNew(1.0, cpMomentForPoly(100.0, num, verts, cpvzero));
	cpSpaceAddBody(space, body);
	body->p = cpv( x, y );
	
	// Create Collision Shape
	cpShape* shape = cpPolyShapeNew( body, num, verts, cpvzero);
	shape->e = 0.1; shape->u = 0.8;
	cpSpaceAddShape( space, shape );
	
	// Create Joint with static body
	cpJoint *constraint = cpPivotJointNew(body, staticBody, cpv( x, y ) );
	cpSpaceAddJoint( space, constraint );
	
	return body;
}


void destroySpinner( cpBody* spinner )
{

	
	
}


cpShape* createContainerCap( cpSpace* space, cpBody* staticBody, float x, float y )
{
	float scale = 1.5;
	float w = 20.0f * scale;
	
	// Calculate proper offsets so that the container is centered around (x,y)
	x = x - w/2.0;
	
	float elasticity = 0.75f;
	float friction = 0.5f;
	
	cpShape * shape;
	shape = cpSegmentShapeNew(staticBody, cpv(x,y), cpv(x+w, y), 0.0f);
	shape->e = elasticity;
	shape->u = friction;
	cpSpaceAddStaticShape(space, shape);
	
	return shape;
}

void destroyContainerCap( cpSpace* space, cpShape *containerCap )
{
	cpSpaceRemoveStaticShape( space, containerCap );
	cpShapeFree( containerCap );
}

