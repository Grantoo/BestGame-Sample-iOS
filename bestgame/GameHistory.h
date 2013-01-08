//
//  GameHistory.h
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameHistory : NSObject {
    int     maxScore;
    int     maxTapsWin;
    int     maxTapsLoss;
    int     maxWinStreak;
    int     maxLossStreak;
    int     totalScore;
    int     totalGames;
    int     totalWins;
    int     totalTaps;
    int     currentWinStreak;
    int     currentLossStreak;
}

@property (nonatomic,assign,readonly) int maxScore;
@property (nonatomic,assign,readonly) int maxTapsWin;
@property (nonatomic,assign,readonly) int maxTapsLoss;
@property (nonatomic,assign,readonly) int maxWinStreak;
@property (nonatomic,assign,readonly) int maxLossStreak;
@property (nonatomic,assign,readonly) int totalScore;
@property (nonatomic,assign,readonly) int totalGames;
@property (nonatomic,assign,readonly) int totalWins;
@property (nonatomic,assign,readonly) int totalTaps;
@property (nonatomic,assign,readonly) int currentWinStreak;
@property (nonatomic,assign,readonly) int currentLossStreak;

-(float)averageScore;
-(float)winPercent;
-(float)averageTaps;

-(void)updateHistoryWithScore:(int)score taps:(int)taps;

// Returns an instance of this class as a Singleton
+ (GameHistory *)instance;

@end
