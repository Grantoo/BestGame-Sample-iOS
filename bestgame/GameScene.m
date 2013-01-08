//
//  GameScene.m
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//

#import "CCBReader.h"
#import "CCBAnimationManager.h"
#import "GameScene.h"
#import "GameHistory.h"
#import "SimpleAudioEngine.h"
#import "GameKitHelper.h"
// Uncomment for Flurry
//#import "Flurry.h"

// Define your own GameKit Category Here.
#define kGameKitCategory @"com.yourcompany.yourgame.highscore"

#define PARAMS_OPTIONS_KEY @"options"
#define PARAMS_SEED_KEY @"seed"
#define PARAMS_ROUND_KEY @"round"
#define OPTIONS_GAMETYPE_KEY @"gametype"
#define OPTIONS_GAMETYPE_RANDOM_VALUE 0
#define OPTIONS_GAMETYPE_SAMESY_VALUE 1

// hidden implementation
@interface GameScene ()
{
    CCMenuItemImage     *backButton;
    CCMenuItemImage     *goButton;
    CCMenuItemImage     *stopButton;

    CCMenuItemImage     *soundOnButton;
    CCMenuItemImage     *soundOffButton;
    
    float               scorePitch;
    int                 presses;
    
    BOOL                goBackPressed;

    CCLabelTTF          *scoreLabel;
    int                 score;    
}
-(void)finalize;
-(void)floaterFinished:(id)sender;
-(void)createFloater:(NSString*)text color:(ccColor3B)color location:(CGPoint)location destination:(CGPoint)destination;

@end

@implementation GameScene

- (id) init
{
	if (self = [super init]) {
        goBackPressed = false;
        
        srandom(time(0));
        
        score = 0;
        presses = 0;
        
        scorePitch = 0.5;
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"scoreSFX.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"clickSFX.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"failSFX.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"lockSFX.wav"];
    }
	return self;
}

- (void)onEnter {
// Uncomment for Flurry
//    [Flurry logEvent:@"GameSceneEntry"];
    CCLOG(@"GameScene::onEnter");
    [super onEnter];
    [self setSoundButtons];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ingameBGM.mp3"];
}

- (void)onExit {
    CCLOG(@"GameScene::onExit");
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [super onExit];
}

- (void) goBack:(id)sender
{
    if (!goBackPressed) {
        // Load the game scene
        CCScene* mainScene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene.ccbi"];
        // Go to the game scene
        [[CCDirector sharedDirector] replaceScene:mainScene];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(goBack:) object:NULL];
    }
}

- (void) goScore:(id)sender
{
    int whammy = random() % 100;
    if (whammy > 6 || score == 0 || presses < 3) {
        // we are safe
        int newup = (random() % 950) + 50;
        score += newup;
        presses ++;
        
        scorePitch += 0.1;
        if (scorePitch > 2.0) {
            scorePitch = 2.0;
        }
            
        [self createFloater:[NSString stringWithFormat:@"+%d",newup] color:ccc3(0,142,41) location:[goButton position] destination:[scoreLabel position]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"scoreSFX.wav" pitch:scorePitch pan:1.0 gain:0.9];
        
    } else {
        
        // we are done
        score = 0;
        [self finalize];
        
        // create the floater
        [self createFloater:@"FAIL" color:ccRED location:[goButton position] destination:[scoreLabel position]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"failSFX.wav"];

        [backButton setVisible:true];
        [stopButton setIsEnabled:false];
        [goButton setIsEnabled:false];
        CCBAnimationManager* animationManager = self.userObject;
        [animationManager runAnimationsForSequenceNamed:@"GameOver"];
    }
}

- (void) goStop:(id)sender
{
    [self finalize];
 
    [self createFloater:@"LOCK" color:ccc3(0,142,41) location:[stopButton position] destination:[scoreLabel position]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"lockSFX.wav"];

    
    [scoreLabel setString:[NSString stringWithFormat:@"%d",score]];
    [backButton setVisible:true];
    [stopButton setIsEnabled:false];
    [goButton setIsEnabled:false];
    CCBAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"GameOver"];
}

-(void)floaterFinished:(id)sender {
    CCLabelTTF *floater = (CCLabelTTF *)sender;
    
    [scoreLabel setString:[NSString stringWithFormat:@"%d",score]];
    if (score == 0) {
        [scoreLabel setColor:ccRED];
    }
    
    [self removeChild:floater cleanup:YES];
}

- (void) createFloater:(NSString*)text color:(ccColor3B)color location:(CGPoint)location destination:(CGPoint)destination
{
    int fontSize = 28;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        fontSize = 56;
    }
    
    CCLabelTTF *floater = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:fontSize];
    [floater setColor:color];
    [floater setPosition:location];
    [floater setScale:0.5];
    [self addChild:floater];
    
    id moveaction = [CCMoveTo actionWithDuration:1 position:destination];
    id easeaction = [CCEaseOut actionWithAction:moveaction rate:2];
    id fadeaction = [CCFadeOut actionWithDuration:1];
    id scaleaction = [CCScaleTo actionWithDuration:1 scale:1];
    id spawnaction = [CCSpawn actions:easeaction, fadeaction, scaleaction, nil];
    id mycallfunc = [CCCallFuncN actionWithTarget:self selector:@selector(floaterFinished:)];
    id sequence = [CCSequence actions:spawnaction, mycallfunc, nil];
    [floater runAction:sequence];
}

#pragma mark -
#pragma mark Private methods

-(void) finalize
{
    // kick us back automatically after three seconds
    [self performSelector:@selector(goBack:) withObject:nil afterDelay:3];
    
    // add to History
    [[GameHistory instance] updateHistoryWithScore:score taps:presses];
    // Uncomment to enable GameCenter.
    //[[GameKitHelper sharedGameKitHelper] submitScore:score category:kGameKitCategory];
    
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
