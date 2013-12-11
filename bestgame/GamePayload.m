#import "GamePayload.h"

@interface GamePayload (Private)
- (id)init;
- (void)reset;
- (void)storeGamePayload;
- (void)loadGamePayload;
@end

@implementation GamePayload

@synthesize tournID, matchID, seed, round, gameType, score, completeFlag, activeFlag;

// This is a GrantooLib singleton class, see getInstance below
static GamePayload *instance = nil;

// Factory method to get singleton instance.
+ (GamePayload *) instance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
        return instance;
    }
}

- (void)clear {
    [self reset];
    [self storeGamePayload];
}

- (void)store {
    [self storeGamePayload];
}


#pragma mark -
#pragma mark Private methods

// Made private to prevent accidental usage.
- (id)init {
	if (self = [super init]) {
        [self reset];
        [self loadGamePayload];
	}
	return self;
}

-(void) reset {
    tournID = nil;
    matchID = nil;
    seed = 0;
    round = 0;
    gameType = 0;
    score = 0;
    completeFlag = false;
    activeFlag = false;
}

- (void)storeGamePayload {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:1 forKey:@"gamePayloadVersion"];
    [prefs setBool:completeFlag forKey:@"complete"];
    [prefs setBool:activeFlag forKey:@"active"];
    [prefs setInteger:score forKey:@"sPayload"];
    [prefs setInteger:seed forKey:@"sdPayload"];
    [prefs setInteger:round forKey:@"rPayload"];
    [prefs setInteger:gameType forKey:@"gPayload"];
    [prefs setObject:matchID forKey:@"mPayload"];
    [prefs setObject:tournID forKey:@"tPayload"];
    [prefs synchronize];
}

- (void)loadGamePayload {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int gameVersion = [prefs integerForKey:@"gamePayloadVersion"];
    if (gameVersion == 1) {
        completeFlag = [prefs boolForKey:@"complete"];
        activeFlag = [prefs boolForKey:@"active"];
        score = [prefs integerForKey:@"sPayload"];
        seed = [prefs integerForKey:@"sdPayload"];
        round = [prefs integerForKey:@"rPayload"];
        gameType = [prefs integerForKey:@"gPayload"];
        matchID = [prefs objectForKey:@"mPayload"];
        tournID = [prefs objectForKey:@"tPayload"];
    }
}

@end