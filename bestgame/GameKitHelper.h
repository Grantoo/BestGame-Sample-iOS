//
//  GameKitHelper.h
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//

//   Include the GameKit framework
#import <GameKit/GameKit.h>

@interface GameKitHelper : NSObject<GKLeaderboardViewControllerDelegate>

// This property holds the last known error
// that occured while using the Game Center API's
@property (nonatomic, readonly) NSError* lastError;

+ (id) sharedGameKitHelper;

// Player authentication, info
-(void) authenticateLocalPlayer;
// Scores
-(void) submitScore:(int64_t)score category:(NSString*)category;
// Leaderboard
-(void) showLeaderBoard;
@end
