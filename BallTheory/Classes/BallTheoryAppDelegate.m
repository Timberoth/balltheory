//
//  BallTheoryAppDelegate.m
//  Ball Theory
//
//  Created by Tim on 9/8/2010.
//  Copyright Gamers of Action 2010. All rights reserved.
//

#import "BallTheoryAppDelegate.h"


extern cpBody* makeCircle(int radius);
extern void drawObject(void *ptr, void *unused);
extern void createPlayer();
extern void makeStaticBox(float x, float y, float width, float height);
extern NSMutableArray* createContainer( float x, float y );
extern void destroyContainer( NSMutableArray* container );

extern cpBody* createSpinner( float x, float y );
extern void destroySpinner();




cpSpace *space;
cpBody *staticBody;

bool mDestroyContainer = false;

NSMutableArray* adder;
cpBody* spinner;

@implementation GameLayer
-(id) init {
	[super init];
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
	space = cpSpaceNew();
	
	// set the hash to a rough estimate of how many shapes there could be
	cpSpaceResizeStaticHash(space, 60.0, 1000);
	cpSpaceResizeActiveHash(space, 60.0, 1000);
	
	// set gravity
	space->gravity = cpv(0, -200);
	
	// set Elasticiy
	space->elasticIterations = 10;
	
	staticBody = cpBodyNew(INFINITY, INFINITY);
	
	// Schedule the physics run loop
	[self schedule: @selector(step:)];
	
	// 320x480
	CGSize s = [[Director sharedDirector] winSize];
	
	// make a bounding box the size of the screen
	int margin = 4;
	int dmargin = margin*2;
	makeStaticBox(margin, margin, s.width - dmargin, s.height - dmargin);
	
	//adder = createContainer(90, 290);
	
	spinner = createSpinner(s.width/2.0, s.height/2.0);
	
}

- (void) draw{  
	// rendering loop
	glColor4f(1.0, 1.0, 1.0, 1.0);
	cpSpaceHashEach(space->activeShapes, &drawObject, NULL);
	//by switching colour here we can make static stuff darker
	glColor4f(1.0, 1.0, 1.0, 0.7);
	cpSpaceHashEach(space->staticShapes, &drawObject, NULL);  
}


- (void)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{  
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[Director sharedDirector] convertCoordinate: location];
	//move the nouse to the click
	cpMouseMove(mouse, cpv(location.x, location.y));
	if(mouse->grabbedBody == nil){
		//if there's no associated grabbed object
		// try get one
		cpMouseGrab(mouse, 0);
	}
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[Director sharedDirector] convertCoordinate: location];
	mouse = cpMouseNew(space);
	cpMouseMove(mouse, cpv(location.x, location.y));
	cpMouseGrab(mouse, 0);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self ccTouchesCancelled:touches withEvent:event];
	
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[Director sharedDirector] convertCoordinate: location];
	
	// Spawn new ball
	for( int i = 0; i < 10; i++ )
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
		
}


- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	cpMouseDestroy(mouse);
}


-(void) step: (ccTime) delta {
	int steps = 2;
	cpFloat dt = delta/(cpFloat)steps;
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	
	// Destroy the container if necessary
	if( mDestroyContainer && adder != NULL )
	{
		destroyContainer( adder );
		adder = NULL;
	}
	
	// Make the spinner spin at a constant velocity
	spinner->w = 5.0f;
} 

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration{	
	static float prevX=0, prevY=0;	
#define kFilterFactor 0.05
	
	float accelX = acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	cpVect v = cpv( accelX, accelY);
	space->gravity = cpvmult(v, 200);
}


@end

@implementation BallTheoryAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// NEW: Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	//[window setMultipleTouchEnabled:YES];
	
	//[[Director sharedDirector] setLandscape: YES];
	[[Director sharedDirector] setDisplayFPS:YES];
	
	[[Director sharedDirector] attachInWindow:window];
	
	Scene *scene = [Scene node];
	[scene add: [GameLayer node]];
	
	[window makeKeyAndVisible];
	
	[[Director sharedDirector] runWithScene: scene];
	
}
-(void)dealloc
{
	[super dealloc];
}
-(void) applicationWillResignActive:(UIApplication *)application
{
	[[Director sharedDirector] pause];
}
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[Director sharedDirector] resume];
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

@end
