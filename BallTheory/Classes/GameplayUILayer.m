//
//  GameplayUILayer.m
//  BallTheory
//
//  Created by Tim on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import "GameplayUILayer.h"
#import "GameplayScene.h"


@implementation GameplayUILayer

-(bool) initLayer:parentScene {
	[super init];
	[super initLayer:parentScene];
	
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
    CCMenuItem* starMenuItem = [CCMenuItemImage 
								itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png" 
								target:self selector:@selector(zoomOut:)];
    starMenuItem.position = ccp(60, 60);
	
	CCMenuItem* starMenuItem2 = [CCMenuItemImage 
								 itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png" 
								 target:self selector:@selector(zoomIn:)];
    starMenuItem2.position = ccp(90 , 60);
	
	
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem,starMenuItem2, nil];
    starMenu.position = CGPointZero;
	[self addChild:starMenu];
	
	
	plusItem = [[CCMenuItemImage itemFromNormalImage:@"ButtonPlus.png" 
									   selectedImage:@"ButtonPlusSel.png" target:nil selector:nil] retain];
	minusItem = [[CCMenuItemImage itemFromNormalImage:@"ButtonMinus.png" 
										selectedImage:@"ButtonMinusSel.png" target:nil selector:nil] retain];
	CCMenuItemToggle* toggleItem = [CCMenuItemToggle itemWithTarget:self 
														   selector:@selector(plusMinusButtonTapped:) items:plusItem, minusItem, nil];
	CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
	toggleMenu.position = ccp(60, 90);
	[self addChild:toggleMenu];
	
	return true;
}

- (void)zoomIn:(id)sender 
{
	// Cast to GameplayScene.
	GameplayScene* scene = (GameplayScene*)mParentScene;
	
	if( !scene )
		return;	
	
	float currentZoom = [scene.mCamera zoom];
	currentZoom += 0.1;
	scene.mCamera.zoom = currentZoom;
}

- (void)zoomOut:(id)sender 
{
	// Cast to GameplayScene.
	GameplayScene* scene = (GameplayScene*)mParentScene;
	
	if( !scene )
		return;
	
	float currentZoom = [scene.mCamera zoom];
	currentZoom -= 0.1;
	scene.mCamera.zoom = currentZoom;
}

- (void)plusMinusButtonTapped:(id)sender {  
	// Cast to GameplayScene.
	GameplayScene* scene = (GameplayScene*)mParentScene;
	
	if( !scene )
		return;
	
	if( scene.mCameraMovement )
	{
		scene.mCameraMovement = false;
	}
	else 
	{
		scene.mCameraMovement = true;
	}
	
	
	/*
	 CCMenuItemToggle* toggleItem = (CCMenuItemToggle*)sender;
	 if (toggleItem.selectedItem == plusItem) {
	 [label setString:@"Visible button: +"];    
	 } else if (toggleItem.selectedItem == minusItem) {
	 [label setString:@"Visible button: -"];
	 } 
	 */
}

-(void) dealloc {
	[super dealloc];
	
	[label release];
	label = nil;
	
	[plusItem release];
	plusItem = nil;
	[minusItem release];
	minusItem = nil;
}


@end
