//
//  GameplayGameLayer.m
//  BallTheory
//
//  Created by Tim on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import "GameplayGameLayer.h"
#import "GameplayScene.h"

extern void drawObject(void *ptr, void *unused);

extern cpBody* makeCircle(int radius);
extern void drawObject(void *ptr, void *unused);
extern void createPlayer();
extern void makeStaticBox(float x, float y, float width, float height);
extern NSMutableArray* createContainer( float x, float y );
extern void destroyContainer( NSMutableArray* container );

extern cpBody* createSpinner( float x, float y );
extern void destroySpinner();

extern cpShape* createContainerCap(float x, float y);
extern void destroyContainerCap( cpShape *containerCap );


@implementation GameplayGameLayer

-(id) initLayer:parentScene {
	[super init];
	[super initLayer:parentScene];
	
	[self initChipmunk];
	isTouchEnabled = YES;
	isAccelerometerEnabled = YES;
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
	
	//seed the random generator
	srand([[NSDate date] timeIntervalSince1970]);
	
	// Make it look slightly prettier
	glEnable(GL_LINE_SMOOTH);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE);
	
	return self;
}

-(void) dealloc {
	[super dealloc];
}

- (void) initChipmunk{
	// start chipumnk
	cpInitChipmunk();
	
	// create the space for the bodies
	mGlobalSpace = cpSpaceNew();
	
	// set the hash to a rough estimate of how many shapes there could be
	cpSpaceResizeStaticHash( mGlobalSpace, 60.0, 1000);
	cpSpaceResizeActiveHash( mGlobalSpace, 60.0, 1000);
	
	// set gravity
	mGlobalSpace->gravity = cpv(0, -200);
	
	// set Elasticiy
	mGlobalSpace->elasticIterations = 10;
	
	mGlobalStaticBody = cpBodyNew(INFINITY, INFINITY);
	
	// Schedule the physics run loop
	[self schedule: @selector(step:)];
	
	// 320x480
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	// make a bounding box the size of the screen
	int margin = 4;
	int dmargin = margin*2;
	makeStaticBox(margin, margin, s.width - dmargin, s.height - dmargin);
	
	adder = createContainer(s.width/2.0, s.height/2.0);
	
	spinner = createSpinner(s.width/2.0, s.height/2.0+5.0);
	
	containerCap = createContainerCap(s.width/2.0, (s.height/2.0) - 57.5);
	
}

- (void) draw{  
	// rendering loop
	glColor4f(1.0, 1.0, 1.0, 1.0);
	cpSpaceHashEach(mGlobalSpace->activeShapes, &drawObject, NULL);
	//by switching colour here we can make static stuff darker
	glColor4f(1.0, 1.0, 1.0, 0.7);
	cpSpaceHashEach( mGlobalSpace->staticShapes, &drawObject, NULL);  
}



- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// move camera and eye XY += change in movement
	UITouch *touch = [touches anyObject];
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];  // now in cocos2D coords
	
	// Cast to GameplayScene.
	GameplayScene* scene = (GameplayScene*)mParentScene;
	
	if( !scene )
		return;
	
	CGPoint touchStart = scene.mTouchStart;
	CGPoint delta = CGPointMake((location.x - touchStart.x), (location.y-touchStart.y));
	
	delta.x *= -1.0f;
	delta.y *= -1.0f;
	
	// ADJUST CAMERA
	if( scene.mCameraMovement )
	{
		[scene.mCamera panCameraBy:delta];  // moves it but doesn't draw it yet.
	}
	
	touchStart = location;  // touchStart is initially set in the ccTouchesBegan method.
	
	int count = [touches count];
	if( count > 1 )
	{
		
		float currentZoom = [scene.mCamera zoom];
		currentZoom += 0.1;
		scene.mCamera.zoom = currentZoom;	
	}
	
	
}



- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch =  [touches anyObject];
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	// Cast to GameplayScene.
	GameplayScene* scene = (GameplayScene*)mParentScene;
	if( !scene )
		return;
	
	// Track where the touch started.
	scene.mTouchStart = location;
	
	//mouse = cpMouseNew(space);
	//cpMouseMove(mouse, cpv(location.x, location.y));
	//cpMouseGrab(mouse, 0);
	
	// Begin Camera Movment on double tap
	if( touch.tapCount > 1 )
	{
		location = [self convertTouchToGameCoords:touch ];
		cpBody* circle = makeCircle( 5 );
		circle->p = cpv( location.x, location.y );
	}
	else {
		scene.mCameraMovement = true;
	}
	
}



- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self ccTouchesCancelled:touches withEvent:event];
	
	UITouch *touch =  [touches anyObject];
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	location = [self convertTouchToGameCoords:touch ];
	
	// Cast to GameplayScene.
	GameplayScene* scene = (GameplayScene*)mParentScene;
	if( !scene )
		return;
	
	if( !scene.mCameraMovement )
	{
		// Spawn new ball
		/*
		 for( int i = 0; i < 5; i++ )
		 {
		 cpBody* circle = makeCircle( 5 );
		 circle->p = cpv( location.x, location.y );
		 
		 // Give it a random push
		 int signX = rand()%2;
		 int signY = rand()%2;
		 if( signX == 0 )
		 {
		 signX = -1;
		 }
		 if( signY == 0 )
		 {
		 signY = -1;
		 }
		 cpBodyApplyImpulse( circle, cpv( signX*rand()%150, signY*rand()%150 ), cpvzero);
		 }
		 */
	}
	
	scene.mCameraMovement = false;
}



-(void) step: (ccTime) delta {
	
	int steps = 2;
	cpFloat dt = delta/(cpFloat)steps;
	for(int i=0; i<steps; i++)
	{
		cpSpaceStep( mGlobalSpace, dt);
	}
	
	// Destroy the container if necessary
	if( mDestroyContainer && adder != NULL )
	{
		destroyContainer( adder );
		adder = NULL;
	}
	
	// Make the spinner spin at a constant velocity
	spinner->w = -5.0f;
	
	capCounter++;
	if( capCounter > 180 )
	{
		capCounter = 0;
		if( containerCap == NULL )
		{
			CGSize s = [[CCDirector sharedDirector] winSize];
			containerCap = createContainerCap(s.width/2.0, (s.height/2.0) - 57.5);
		}
		else 
		{
			destroyContainerCap( containerCap );
			containerCap = NULL;
		}
	}
} 

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration{	
	static float prevX=0, prevY=0;	
#define kFilterFactor 0.05
	
	float accelX = acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	cpVect v = cpv( accelX, accelY);
	mGlobalSpace->gravity = cpvmult(v, 200);
}


-(void)visit{
	// Cast to GameplayScene.
	GameplayScene* scene = (GameplayScene*)mParentScene;
	if( !scene )
		return;
	
	//OpenGL Code here that adjusts the camera
	CGSize screenDims = [[CCDirector sharedDirector] displaySize];
	CGPoint camPos = [scene.mCamera position];
	//camPos = [[CCDirector sharedDirector] convertToGL:camPos];
	float camZoom = [scene.mCamera zoom];
	[[CCDirector sharedDirector] setProjection:kCCDirectorProjectionCustom];
	//now set your projection
	glMatrixMode(GL_PROJECTION);
	//save current projection state
	glPushMatrix();
	glLoadIdentity();
	
	glOrthof(camPos.x - screenDims.width/(2*camZoom),
			 camPos.x + screenDims.width/(2*camZoom),
			 camPos.y - screenDims.height/(2*camZoom),
			 camPos.y + screenDims.height/(2*camZoom),
			 -1000,
			 1000);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity(); 
	
	[super visit];
	
	//put it back
	glMatrixMode(GL_PROJECTION);
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}


-(CGPoint) convertTouchToGameCoords:(UITouch*)touch
{	
	CGSize screenSize = [[CCDirector sharedDirector] displaySize];
	CGPoint location = [touch locationInView: [touch view]];
	
	location = [[CCDirector sharedDirector] convertToGL: location];  // now in cocos2D coords
	
	// Cast to GameplayScene.
	GameplayScene* scene = (GameplayScene*)mParentScene;
	if( !scene )
		return location;
	
	// calculate world location
	location.x = [scene.mCamera position].x + (location.x - screenSize.width/2.0) * (1.0/[scene.mCamera zoom]);
	location.y = [scene.mCamera position].y + (location.y - screenSize.height/2.0) * (1.0/[scene.mCamera zoom]);
	
	return location;
}



@end
