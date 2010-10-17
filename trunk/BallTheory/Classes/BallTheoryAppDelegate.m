//
//  BallTheoryAppDelegate.m
//  Ball Theory
//
//  Created by Tim on 9/8/2010.
//  Copyright Gamers of Action 2010. All rights reserved.
//

#import "BallTheoryAppDelegate.h"
#import "GameCamera.h"

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


cpSpace *space;
cpBody *staticBody;

bool mDestroyContainer = false;

NSMutableArray* adder = NULL;
cpBody* spinner = NULL;

cpShape* containerCap = NULL;

int capCounter = 0;

// Game Camera
GameCamera* mCamera;

CGPoint touchStart;

// Button
CCLabel* label;

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
	cpSpaceHashEach(space->activeShapes, &drawObject, NULL);
	//by switching colour here we can make static stuff darker
	glColor4f(1.0, 1.0, 1.0, 0.7);
	cpSpaceHashEach(space->staticShapes, &drawObject, NULL);  
}

/*
- (void)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{  
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	
	
	location = [[CCDirector sharedDirector] convertToGL: location];
	//move the nouse to the click
	cpMouseMove(mouse, cpv(location.x, location.y));
	if(mouse->grabbedBody == nil){
		//if there's no associated grabbed object
		// try get one
		cpMouseGrab(mouse, 0);
	}

}
 */

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// move camera and eye XY += change in movement
	UITouch *touch = [touches anyObject];
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];  // now in cocos2D coords
	
	CGPoint delta = CGPointMake((location.x - touchStart.x), (location.y-touchStart.y));
	
	delta.x *= -1.0f;
	delta.y *= -1.0f;
	
	// ADJUST CAMERA
	[mCamera panCameraBy:delta];  // moves it but doesn't draw it yet.
	
	touchStart = location;  // touchStart is initially set in the ccTouchesBegan method.
	
}



- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch =  [touches anyObject];
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	// Track where the touch started.
	touchStart = location;
	
	mouse = cpMouseNew(space);
	//cpMouseMove(mouse, cpv(location.x, location.y));
	//cpMouseGrab(mouse, 0);
}



- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self ccTouchesCancelled:touches withEvent:event];
	
	UITouch *touch =  [touches anyObject];
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	location = [self convertTouchToGameCoords:touch ];
	
	
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
	
	cpBody* circle = makeCircle( 5 );
	circle->p = cpv( location.x, location.y );	
	
	
	// TEST CAMERA ZOOM
	/*
	// The two finger multi touch does not work very well.
	float currentZoom = [mCamera zoom];
	NSSet *allTouches = [event allTouches];
	int count = [allTouches count];
	
	// 1 figner zoom In
	if ( count == 1 )
	{
		currentZoom += 0.1;
	}
	
	// 2+ fingers zoom out
	else
	{
		currentZoom -= 0.1;
	}
	
	mCamera.zoom = currentZoom;
	 */
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
	space->gravity = cpvmult(v, 200);
}


-(void)visit{
	//OpenGL Code here that adjusts the camera
	
	CGSize screenDims = [[CCDirector sharedDirector] displaySize];
	CGPoint camPos = [mCamera position];
	//camPos = [[CCDirector sharedDirector] convertToGL:camPos];
	float camZoom = [mCamera zoom];
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
	
	// calculate world location
	location.x = [mCamera position].x + (location.x - screenSize.width/2.0) * (1.0/[mCamera zoom]);
	location.y = [mCamera position].y + (location.y - screenSize.height/2.0) * (1.0/[mCamera zoom]);
	
	return location;
}

@end


@implementation MenuLayer
-(id) init {
	[super init];
	
	//seed the random generator
	srand([[NSDate date] timeIntervalSince1970]);
	
	// Make it look slightly prettier
	glEnable(GL_LINE_SMOOTH);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE);
	
	
	// Create label and button
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
    // Create a label for display purposes
    label = [[CCLabel labelWithString:@"Last button: None" 
						   dimensions:CGSizeMake(320, 50) alignment:UITextAlignmentCenter 
							 fontName:@"Arial" fontSize:32.0] retain];
    label.position = ccp(winSize.width/2, 
						 winSize.height-(label.contentSize.height));
    [self addChild:label];
	
    // Standard method to create a button
    CCMenuItem *starMenuItem = [CCMenuItemImage 
								itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png" 
								target:self selector:@selector(starButtonTapped:)];
    starMenuItem.position = ccp(60, 60);
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
    starMenu.position = CGPointZero;
    [self addChild:starMenu];
	
	return self;
}

- (void)starButtonTapped:(id)sender {
    [label setString:@"Last button: *"];
}

-(void) dealloc {
	[super dealloc];
	
	[label release];
	label = nil;
}

@end



@implementation BallTheoryAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// NEW: Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	//[window setMultipleTouchEnabled:YES];
	
	//[[Director sharedDirector] setLandscape: YES];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	[[CCDirector sharedDirector] attachInWindow:window];
	
	CCScene *scene = [CCScene node];
	
	// MenuLayer must be added before GameLayer to render properly.
	[scene addChild: [MenuLayer node]];
	[scene addChild: [GameLayer node]];
	
	// Initialize GameCamera
	mCamera = [GameCamera alloc];
	if( mCamera == NULL )
	{
		printf("Failed to create the Game Camera.");
		
		// Need to bail out gracefully here.
	}
	else 
	{
		[ mCamera initWithController:scene ];
		
		// Look at the center of the screen
		CGPoint point = CGPointMake(160.0, 240.0);
		[ mCamera moveCameraTo:point ]; 
	}

	[window makeKeyAndVisible];
	
	[[CCDirector sharedDirector] runWithScene: scene];
	
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
