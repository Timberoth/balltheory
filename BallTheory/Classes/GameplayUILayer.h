//
//  GameplayUILayer.h
//  BallTheory
//
//  Created by Tim on 10/31/10.
//  Copyright 2010 Gamers of Action. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonLayer.h"

@interface GameplayUILayer : CommonLayer {
	// Button
	CCLabel* label;
	
	// Toggle Menu Item
	CCMenuItem* plusItem; 
	CCMenuItem* minusItem;
	
}

- (void)zoomIn:(id)sender; 

- (void)zoomOut:(id)sender;

- (void)plusMinusButtonTapped:(id)sender;

@end
