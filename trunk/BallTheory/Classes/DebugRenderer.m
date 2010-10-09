//
//  DebugRenderer.m
//  grabbed too
//
//  Created by benmaslen on 14/03/2009.
//  Copyright 2009 ortatherox.com. All rights reserved.
//

#import "chipmunk.h"
#import "CCDrawingPrimitives.h"
#import "cocos2d.h"
#import "OpenGL_Internal.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

void drawCircleShape(cpShape *shape) {
	cpBody *body = shape->body;
	cpCircleShape *circle = (cpCircleShape *)shape;
	cpVect c = cpvadd(body->p, cpvrotate(circle->c, body->rot));
	CGPoint point;
	point.x = c.x;
	point.y = c.y;
	ccDrawCircle( point, circle->r, body->a, 25, true);
  // !important this number changes the quality of circles
}

void drawSegmentShape(cpShape *shape) {
	cpBody *body = shape->body;
	cpSegmentShape *seg = (cpSegmentShape *)shape;
	cpVect a = cpvadd(body->p, cpvrotate(seg->a, body->rot));
	cpVect b = cpvadd(body->p, cpvrotate(seg->b, body->rot));
	CGPoint pointA;
	CGPoint pointB;
	pointA.x = a.x;
	pointA.y = a.y;
	pointB.x = b.x;
	pointB.y = b.y;
	ccDrawLine( pointA, pointB );
}

void drawPolyShape(cpShape *shape) {
	cpBody *body = shape->body;
	cpPolyShape *poly = (cpPolyShape *)shape;
	
	int num = poly->numVerts;
	cpVect *verts = poly->verts;
	
	CGPoint* points = malloc( sizeof(CGPoint)* num );
	if( !points )
		return;
	
	for(int i=0; i<num; i++){
		cpVect v = cpvadd(body->p, cpvrotate(verts[i], body->rot));
		points[i].x = v.x;
		points[i].y = v.y;
	}
	
	ccDrawPoly( points, num, true );
	free( points );
}

void drawObject(void *ptr, void *unused) {
	cpShape *shape = (cpShape *)ptr;  
  glColor4f(1.0, 1.0, 1.0, 0.7);
  
  //if its the player
  if(shape->group == 55){
    glColor4f(1.0, 1.0, 1.0, 1.0);
  }
  
	switch(shape->klass->type){
		case CP_CIRCLE_SHAPE:
			drawCircleShape(shape);
			break;
		case CP_SEGMENT_SHAPE:
			drawSegmentShape(shape);
			break;
		case CP_POLY_SHAPE:
			drawPolyShape(shape);
			break;
		default:
			printf("Bad enumeration in drawObject().\n");
	}
}
