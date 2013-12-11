#import <Foundation/Foundation.h>

@interface GamePayload : NSObject {
    NSString *tournID;
    NSString *matchID;
    int seed;
    int round;
    int gameType;
    long score;
    BOOL completeFlag;
    BOOL activeFlag;
}

@property (nonatomic,strong) NSString *tournID;
@property (nonatomic,strong) NSString *matchID;
@property (nonatomic,assign) int seed;
@property (nonatomic,assign) int round;
@property (nonatomic,assign) int gameType;
@property (nonatomic,assign) long score;
@property (nonatomic,assign) BOOL completeFlag;
@property (nonatomic,assign) BOOL activeFlag;

// Returns an instance of this class as a Singleton
+ (GamePayload *)instance;

- (void)clear;
- (void)store;

@end