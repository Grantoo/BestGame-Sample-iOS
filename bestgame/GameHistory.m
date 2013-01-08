//
//  GameHistory.m
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//

#import "GameHistory.h"

// private implementation
@interface GameHistory (Private)
-(void)reset;
- (void)storeGameHistory;
- (void)loadGameHistory;
@end

@implementation GameHistory

@synthesize maxScore;
@synthesize maxTapsWin;
@synthesize maxTapsLoss;
@synthesize maxWinStreak;
@synthesize maxLossStreak;
@synthesize totalScore;
@synthesize totalGames;
@synthesize totalWins;
@synthesize totalTaps;
@synthesize currentWinStreak;
@synthesize currentLossStreak;

#pragma mark -
#pragma mark Public methods

// This is a GrantooLib singleton class, see getInstance below
static GameHistory *instance = nil;
// Factory method to get singleton instance.
+ (GameHistory *) instance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
        return instance;
    }
}

-(float)averageScore {
    if (totalGames > 0) {
        return (float)totalScore / (float) totalGames;
    }
    return 0.0f;
}

-(float)averageTaps {
    if (totalGames > 0) {
        return (float)totalTaps / (float) totalGames;
    }
    return 0.0f;
}

-(float)winPercent {
    if (totalGames > 0) {
        return (float)totalWins * 100.0f / (float) totalGames;
    }
    return 0.0f;
}

-(void)updateHistoryWithScore:(int)score taps:(int)taps {
    totalGames++;
    totalScore += score;
    totalTaps += taps;
    maxScore = score > maxScore ? score : maxScore;
    
    if (score != 0) {
        totalWins++;
        maxTapsWin =  taps > maxTapsWin ? taps : maxTapsWin;
        currentWinStreak++;
        currentLossStreak = 0;
        maxWinStreak = currentWinStreak > maxWinStreak ? currentWinStreak : maxWinStreak;
    } else {
        maxTapsLoss =  taps > maxTapsLoss ? taps : maxTapsLoss;
        currentLossStreak++;
        currentWinStreak = 0;
        maxLossStreak = currentLossStreak > maxLossStreak ? currentLossStreak : currentLossStreak;
    }
    
    [self storeGameHistory];
}

#pragma mark -
#pragma mark Private methods

// Made private to prevent accidental usage.
- (id)init {
	if (self = [super init]) {
        [self reset];
        [self loadGameHistory];
        
	}
	return self;
}

-(void)reset {
    maxScore = 0;
    maxTapsWin = 0;
    maxTapsLoss = 0;
    maxWinStreak = 0;
    maxLossStreak = 0;
    totalScore = 0;
    totalGames = 0;
    totalWins = 0;
    totalTaps = 0;
    currentWinStreak = 0;
    currentLossStreak = 0;    
}

- (void)storeGameHistory {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:1 forKey:@"gameHistoryVersion"];
    [prefs setInteger:maxScore forKey:@"maxScore"];
    [prefs setInteger:maxTapsWin forKey:@"maxTapsWin"];
    [prefs setInteger:maxTapsLoss forKey:@"maxTapsLoss"];
    [prefs setInteger:maxWinStreak forKey:@"maxWinStreak"];
    [prefs setInteger:maxLossStreak forKey:@"maxLossStreak"];
    [prefs setInteger:totalScore forKey:@"totalScore"];
    [prefs setInteger:totalGames forKey:@"totalGames"];
    [prefs setInteger:totalWins forKey:@"totalWins"];
    [prefs setInteger:totalTaps forKey:@"totalTaps"];
    [prefs setInteger:currentWinStreak forKey:@"currentWinStreak"];
    [prefs setInteger:currentLossStreak forKey:@"currentLossStreak"];
    [prefs synchronize];
}

- (void)loadGameHistory {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int gameVersion = [prefs integerForKey:@"gameHistoryVersion"];
    if (gameVersion == 1) {
        maxScore = [prefs integerForKey:@"maxScore"];
        maxTapsWin = [prefs integerForKey:@"maxTapsWin"];
        maxTapsLoss = [prefs integerForKey:@"maxTapsLoss"];
        maxWinStreak = [prefs integerForKey:@"maxWinStreak"];
        maxLossStreak = [prefs integerForKey:@"maxLossStreak"];
        totalScore = [prefs integerForKey:@"totalScore"];
        totalGames = [prefs integerForKey:@"totalGames"];
        totalWins = [prefs integerForKey:@"totalWins"];
        totalTaps = [prefs integerForKey:@"totalTaps"];
        currentWinStreak = [prefs integerForKey:@"currentWinStreak"];
        currentLossStreak = [prefs integerForKey:@"currentLossStreak"];
    }
}
@end
