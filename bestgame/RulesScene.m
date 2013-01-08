//
//  RulesScene.m
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//

#import "RulesScene.h"
#import "CCBReader.h"
// Uncomment for Flurry
//#import "Flurry.h"

@implementation RulesScene

- (void)onEnter {
    // Uncomment for Flurry
    //[Flurry logEvent:@"RulesSceneEntry"];
    CCLOG(@"RulesScene::onEnter");
    [super onEnter];
}

- (void) goBack:(id)sender
{
    // Load the game scene
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"];
    // Go to the game scene
    [[CCDirector sharedDirector] replaceScene:mainScene];
}
@end
