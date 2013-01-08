//
//  IntroLayer.m
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//


// Import the interfaces
#import "CCBReader.h"
#import "IntroLayer.h"
// Uncomment for Flurry
//#import "Flurry.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init])) {
	}
	
	return self;
}

-(void) onEnter
{
    [super onEnter];

    // Uncomment for Flurry
    //[Flurry logEvent:@"IntroLayerEntry"];
    
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:mainScene ]];
}
@end
