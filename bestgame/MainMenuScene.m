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

#import "GamePayload.h"

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
- (void)receiveLocalNotification:(NSNotification*)notification;
@end

@implementation MainMenuScene

- (id)init {
	if (self = [super init]) {
        CCLOG(@"MainMenuScene::alloc");
        challengeCount = 0;
        tournamentInfo = nil;
        
        // register an observer with the notification
        // center for challenge count updates
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocalNotification:) name:@"PropellerSDKChallengeCountChanged" object:nil];
        
        // register an observer with the notification
        // center for tournament information
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocalNotification:) name:@"PropellerSDKTournamentInfo" object:nil];
	}
	return self;
}

-(void)dealloc {
    CCLOG(@"MainMenuScene::dealloc");
    
    // unregister the observer from the notification
    // center for challenge count and tournament
    // information updates
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    
    [[PropellerSDK instance] launch:self];
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
    BOOL sentResult = NO;
    
    GamePayload* payLoad = [GamePayload instance];
    
    // validate the payload state
    if (payLoad && payLoad.activeFlag && payLoad.completeFlag)
    {
        // construct match results dictionary
        NSDictionary *matchResult = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     payLoad.tournID, PSDK_MATCH_POST_TOURNAMENT_KEY,
                                     payLoad.matchID, PSDK_MATCH_POST_MATCH_KEY,
                                     [NSNumber numberWithLong:payLoad.score], PSDK_MATCH_POST_SCORE_KEY,
                                     nil];
        
        // relaunch PropellerSDK with match results
        PropellerSDK* propellerSDK = [PropellerSDK instance];
        [propellerSDK launchWithMatchResult:matchResult delegate:self];
        
        [matchResult release];
        
        // reset the payload state and data
        // in memory and persistent storage
        [payLoad clear];
        
        sentResult = YES;
    }
    
    return sentResult;
}

- (void)updateChallengeCount
{
    [[PropellerSDK instance] syncChallengeCounts];
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
    [[PropellerSDK instance] syncTournamentInfo];
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

#pragma mark -
#pragma mark PropellerSDKDelegate methods

- (void)sdkCompletedWithExit
{
    // sdk completed gracefully with no further action
    
    [self updateChallengeCount];
    [self updateTournamentInfo];
}

- (void)sdkCompletedWithMatch:(NSDictionary*)match
{
    // sdk completed with a match
    
    // extract the match data
    NSString* tournID = [match objectForKey:PSDK_MATCH_RESULT_TOURNAMENT_KEY];
    NSString* matchID = [match objectForKey:PSDK_MATCH_RESULT_MATCH_KEY];
    NSDictionary* params = [match objectForKey:PSDK_MATCH_RESULT_PARAMS_KEY];
    
    int seed = [[params objectForKey:@"seed"] intValue];
    int round = [[params objectForKey:@"round"] intValue];
    int gameType = 0;
    
    NSDictionary* options = [params objectForKey:@"options"];
    
    if (options) {
        NSString* gameTypeString = [options objectForKey:@"gametype"];
        
        if (gameTypeString) {
            gameType = [gameTypeString intValue];
        }
    }
    
    GamePayload* payLoad = [GamePayload instance];
    
    // validate the payload state
    if (payLoad)
    {
        // update the game payload
        payLoad.tournID = tournID;
        payLoad.matchID = matchID;
        payLoad.seed = seed;
        payLoad.round = round;
        payLoad.gameType = gameType;
        payLoad.activeFlag = true;
        payLoad.completeFlag = false;
        
        // play the game for the given match data
        [self goPlay:nil];
    }
}

- (void)sdkFailed:(NSDictionary*)result
{
    // sdk failed with an unrecoverable error
    // (alert box will have been displayed)
    
    [self updateChallengeCount];
    [self updateTournamentInfo];
}

- (BOOL)sdkSocialLogin:(BOOL)allowCache
{
    NSString* result = nil;
    BOOL succeeded = false;
    
    // handle social login
    
    if (succeeded)
    {
        NSString* provider = @"";
        NSString* email = @"";
        NSString* userId = @"";
        NSString* nickname = @"";
        NSString* token = @"";
        
        // retrieve social login data
        
        NSDictionary* json = [NSDictionary dictionaryWithObjectsAndKeys:
                              provider, @"provider",
                              email, @"email",
                              userId, @"id",
                              nickname, @"nickname",
                              token, @"token",
                              nil];
        
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
        
        if (jsonData)
        {
            result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    
    [[PropellerSDK instance] sdkSocialLoginCompleted:result];
    
    return YES;
}

- (BOOL)sdkSocialInvite:(NSString*)subject longMessage:(NSString*)longMessage shortMessage:(NSString*)shortMessage linkUrl:(NSString*)linkUrl
{
    // handle social invite
    
    [[PropellerSDK instance] sdkSocialInviteCompleted];
    
    return YES;
}

- (BOOL)sdkSocialShare:(NSString*)subject longMessage:(NSString*)longMessage shortMessage:(NSString*)shortMessage linkUrl:(NSString*)linkUrl
{
    // handle social share
    
    [[PropellerSDK instance] sdkSocialInviteCompleted];
    
    return YES;
}

- (void)receiveLocalNotification:(NSNotification*)notification
{
    NSDictionary* data = notification.userInfo;
    NSString* type = [notification name];
    
    if ([type isEqualToString:@"PropellerSDKChallengeCountChanged"])
    {
        challengeCount = [[data objectForKey:@"count"] integerValue];
        
        // update the UI with the new challenge count
        [self displayChallengeCount];
        
        // update the application icon badge number
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:challengeCount];
    }
    else if ([type isEqualToString:@"PropellerSDKTournamentInfo"])
    {
        tournamentInfo = data;
        
        // update the UI with the new tournament information
        [self displayTournamentInfo];
    }
}

@end
