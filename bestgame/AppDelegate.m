//
//  AppDelegate.m
//
//  Copyright (c) 2013 Grantoo, LLC. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"
#import "CCBReader.h"
#import "GameKitHelper.h"
// Uncomment for Flurry
// #import "Flurry.h"
// Uncomment for Testflight
// #import "TestFlight.h"

#import "PropellerSDK.h"

// Uncomment if you want to use UserVoice
//NSString * const kUserVoiceSite = @"youruservoicesite.uservoice.com";
//NSString * const kUserVoiceKey = @"youruservoicekey";
//NSString * const kUserVoiceSecret = @"youruservoicesecret";

// Uncomment if you want to use Flurry
//NSString * const kFlurryApiKey = @"yourflurrykey";

// Uncomment if you want to use TestFlight
//NSString * const kTestFlightTeamToken = @"yourtestflighttoken";

@implementation MyNavigationController

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskLandscape;
	
	// iPad only
	return UIInterfaceOrientationMaskLandscape;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[director runWithScene: [IntroLayer scene]];
	}
}
@end

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;
// Uncomment for UserVoice
//@synthesize uvConfig;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CCLOG(@"application:didFinishLaunchingWithOptions:");
    
    // check if the app has been launched due to a local notification
    UILocalNotification* localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotification)
    {
        if (![PropellerSDK handleLocalNotification:localNotification newLaunch:YES])
        {
            // this is not a Grantoo notification, handle as necessary
        }
    }
    
    // Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

#ifdef DEBUG
	// Display FSP and SPF
	[director_ setDisplayStats:YES];
#endif
    
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];
    
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
    
    // For Best Game we are going to support iphone, iphone-hd and iPad ... for iPad-we are going to scale assets so we need to make sure that
    // CCBReader also understands this
#ifdef __CC_PLATFORM_IOS
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad or iPad-hd
        // Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
        if( ! [director_ enableRetinaDisplay:NO] )
            CCLOG(@"Retina Display Not supported");
    }
    else
    {
        // Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
        if( ! [director_ enableRetinaDisplay:YES] )
            CCLOG(@"Retina Display Not supported");
    }
#endif

// Uncomment if you want to use TestFlight
//    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
//    [TestFlight takeOff:kTestFlightTeamToken];

// Uncomment if you want to use Flurry
//    [Flurry setAppVersion:@"Debug"];
//    [Flurry startSession:kFlurryApiKey];
    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:YES];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// Create a Navigation Controller with the Director
	navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// for rotation and other messages
	[director_ setDelegate:navController_];
		
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];

    // Uncomment to enable GameCenter.
    //[[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];

// Uncomment if you want to user UserVoice
//    self.uvConfig = [UVConfig configWithSite:kUserVoiceSite
//                                         andKey:kUserVoiceKey
//                                      andSecret:kUserVoiceSecret];
    
    [PropellerSDK setRootViewController:navController_];
#ifdef DEBUG
    [PropellerSDK useSandbox];
    [PropellerSDK initialize:@"50ac1a38f6aae30200000001" gameSecret:@"c38b6697-b453-99c6-bc59-b50f0eca347f"];
#else
    [PropellerSDK initialize:@"50b665d167379a020000000b" gameSecret:@"a918a013-842e-ceb9-19ec-c0f981894d85"];
#endif
    [[PropellerSDK instance] setOrientation:kPropelSDKLandscape];
    
	// make main window visible
	[window_ makeKeyAndVisible];
    
	return YES;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [PropellerSDK restoreAllLocalNotifications];
    
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];
// Uncomment for UserVoice
//    [uvConfig release];
    
	[super dealloc];
}

- (void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    if (![PropellerSDK handleLocalNotification:notification newLaunch:NO])
    {
        // this is not a Grantoo notification, handle as necessary
    }
}

@end

