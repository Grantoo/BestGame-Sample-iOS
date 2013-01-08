//
//  AppDelegate.h
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
// Uncomment for UserVoice
//#import "UserVoice.h"

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow                    *window_;
	MyNavigationController      *navController_;
	CCDirectorIOS               *director_; // weak ref

    // Uncomment for UserVoice
    //UVConfig                    *uvConfig;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

// Uncomment for UserVoice
//@property (nonatomic, retain) UVConfig *uvConfig;

@end
