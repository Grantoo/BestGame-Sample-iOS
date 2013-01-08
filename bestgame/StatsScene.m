//
//  StatsScene.m
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//

#import "StatsScene.h"
#import "CCBReader.h"
#import "GameHistory.h"
#import "GameKitHelper.h"
// Uncomment for Flurry
//#import "Flurry.h"

@interface StatsScene () {
    CCLabelTTF      *statLabel1;
    CCLabelTTF      *statLabel2;
    CCLabelTTF      *statLabel3;
    CCLabelTTF      *statLabel4;
    CCLabelTTF      *scoreLabel1;
    CCLabelTTF      *scoreLabel2;
    CCLabelTTF      *scoreLabel3;
    CCLabelTTF      *scoreLabel4;
}
@end

@implementation StatsScene

- (void)onEnter {
    // Uncomment for Flurry
    //[Flurry logEvent:@"StatsSceneEntry"];
    CCLOG(@"StatsScene::onEnter");
    [super onEnter];
    
    GameHistory *gHistory = [GameHistory instance];
    
    // Create a label to show challenge count.
    [statLabel1 setString:@"Highest Score"];
    [statLabel2 setString:@"Average Score"];
    [statLabel3 setString:@"Scoring %"];
    [statLabel4 setString:@"Scoring Streak"];

    [scoreLabel1 setString:[NSString stringWithFormat:@"%d",[gHistory maxScore]]];
    [scoreLabel2 setString:[NSString stringWithFormat:@"%.1f",[gHistory averageScore]]];
    [scoreLabel3 setString:[NSString stringWithFormat:@"%.1f",[gHistory winPercent]]];
    [scoreLabel4 setString:[NSString stringWithFormat:@"%d",[gHistory currentWinStreak]]];
}


- (void) goBack:(id)sender
{
    // Load the game scene
    CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"];
    // Go to the game scene
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void) goGameCenter:(id)sender
{
    // Uncomment for Flurry
    //[Flurry logEvent:@"GameCenterSelected"];
    // Uncomment to enable GameCenter.
    //[[GameKitHelper sharedGameKitHelper] showLeaderBoard];
}

@end
