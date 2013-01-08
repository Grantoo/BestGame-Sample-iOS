//
//  MainMenuScene.m
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//

#import "CCBReader.h"
#import "MainMenuScene.h"
#import "AppDelegate.h"
#import "GameHistory.h"
#import "SimpleAudioEngine.h"
//#import "Flurry.h"

@interface MainMenuScene () {
    CCLabelTTF          *challengeLabel;
    CCMenuItemImage    *soundOnButton;
    CCMenuItemImage    *soundOffButton;
    CCMenuItemImage    *grantooButton;
    CCMenuItemImage    *grantooTournButton;
    int                challengeCount;
    NSDictionary       *tournamentInfo;
}
- (void)setSoundButtons;
- (BOOL)sendResult;
- (void)updateChallengeCount;
- (void)displayChallengeCount;
- (void)updateTournamentInfo;
- (void)displayTournamentInfo;
@end

@implementation MainMenuScene

- (id)init {
	if (self = [super init]) {
        CCLOG(@"MainMenuScene::alloc");
        challengeCount = 0;
        tournamentInfo = nil;
	}
	return self;
}

-(void)dealloc {
    CCLOG(@"MainMenuScene::dealloc");
   [super dealloc];
}

- (void)onExit {
    CCLOG(@"MainMenuScene::onExit");
    [[NSNotificationCenter defaultCenter] removeObserver:self];//important!!!
    [super onExit];
}


- (void)onEnter {
    CCLOG(@"MainMenuScene::onEnter");
    [super onEnter];
    
    [self sendResult];
    
    [self setSoundButtons];

    // Uncomment for Flurry
    //[Flurry logEvent:@"MainMenuSceneEntry"];
        
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menuBGM.mp3" loop:NO];

    [self displayChallengeCount];
    [self updateChallengeCount];
    [self schedule:@selector(updateChallengeCount) interval:15];
    
    [self displayTournamentInfo];
    [self updateTournamentInfo];
    [self schedule:@selector(updateTournamentInfo) interval:15];
}

- (void) goPlay:(id)sender
{
    CCLOG(@"goPlay calling stopNotification");
    // Load the game scene
    CCScene* gameScene = [CCBReader sceneWithNodeGraphFromFile:@"GameScene.ccbi"];
        
    // Go to the game scene
    [[CCDirector sharedDirector] replaceScene:gameScene];
}

- (void) goLaunch:(id)sender
{
    CCLOG(@"goLaunch calling stopNotification");
    // Uncomment for Flurry
    //[Flurry logEvent:@"SDKLaunch"];
    
    // TODO: launch multiplayer
}

- (void) goStats:(id)sender
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"StatsScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void) goRules:(id)sender
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"HowToPlayScene.ccbi"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void) goFeedback:(id)sender
{
// Uncomment for Flurry
//    [Flurry logEvent:@"UserVoiceSelected"];
// Uncomment for UserVoice
//    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//    [UserVoice presentUserVoiceInterfaceForParentViewController:[app navController] andConfig:[app uvConfig]];
}

#pragma mark -
#pragma mark Private methods

- (void)stopCocos
{
    CCLOG(@"MainMenuScene::stopCocos");
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] stopAnimation];
}

- (void)startCocos
{
    CCLOG(@"MainMenuScene::startCocos");
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [[CCDirector sharedDirector] startAnimation];
        [[CCDirector sharedDirector] resume];
    }
}

- (BOOL)sendResult
{
    // TODO: submit score
    return NO;
}

- (void)updateChallengeCount
{
    // TODO: request latest challenge count
}

- (void)displayChallengeCount
{
    if (challengeCount > 0) {
        [challengeLabel.parent setVisible:YES];
        [challengeLabel setString:[NSString stringWithFormat:@"%d", challengeCount]];
    } else {
        [challengeLabel.parent setVisible:NO];
    }
}

- (void)updateTournamentInfo
{
    // TODO: request latest tournament info
}

- (void)displayTournamentInfo
{
    BOOL isTournamentRunning = tournamentInfo != nil;
    [grantooButton setVisible:!isTournamentRunning];
    [grantooTournButton setVisible:isTournamentRunning];
}

#pragma mark -
#pragma mark sound button functions

- (void) setSoundButtons
{
    float musicLevel = [[SimpleAudioEngine sharedEngine] backgroundMusicVolume];
    float sfxLevel = [[SimpleAudioEngine sharedEngine] effectsVolume];
    
    BOOL currentlyOn = true;
    
    if (musicLevel == 0.0f && sfxLevel == 0.0f) {
        currentlyOn = false;
    }
    
    if (currentlyOn) {
        [soundOnButton setVisible:true];
        [soundOffButton setVisible:false];
    } else {
        [soundOnButton setVisible:false];
        [soundOffButton setVisible:true];
    }
    
}

- (void) goSoundOff:(id)sender
{
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0f];
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f];
    
    [self setSoundButtons];
}

- (void) goSoundOn:(id)sender
{
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0f];
    
    [self setSoundButtons];
}


@end
