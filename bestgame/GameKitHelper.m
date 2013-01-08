//
//  GameKitHelper.m
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//

#import "GameKitHelper.h"
#import "AppDelegate.h"

@interface GameKitHelper () {
    BOOL gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper

#pragma mark Singleton stuff

+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
		[[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

#pragma mark Player Authentication

- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.authenticated) {
            gameCenterFeaturesEnabled = YES;
        } else {
            gameCenterFeaturesEnabled = NO;
        }
    }];
}

-(void) submitScore:(int64_t)score category:(NSString*)category {
    if (gameCenterFeaturesEnabled) {
        GKScore* gkScore = [[GKScore alloc] initWithCategory:category];
        gkScore.value = score;
        
        [gkScore reportScoreWithCompletionHandler:^(NSError* error) {
            [self setLastError:error];
        }];
    }
}

-(void) showLeaderBoard {
    GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    leaderboardViewController.leaderboardDelegate = self;
    
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [[app navController] presentModalViewController:leaderboardViewController animated:YES];
    [leaderboardViewController release];
}

#pragma mark Property setters
-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
	if (_lastError) {
		NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo] description]);
	}
}

#pragma mark GameKit delegate

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
