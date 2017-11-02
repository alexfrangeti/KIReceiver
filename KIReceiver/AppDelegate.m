//
//  AppDelegate.m
//  KIReceiver
//
//  Created by Alexandru Frangeti on 31.10.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    UIView *splashScreen;
    BOOL hadOrganicStartup; // used so we don't show the splash screen on startup
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Override the appearance proxy for the navbar
    NSDictionary *settings = @{
                               NSFontAttributeName                 :  [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:22.0],
                               NSForegroundColorAttributeName      :  [UIColor whiteColor],
                               };
    
    [[UINavigationBar appearance] setTitleTextAttributes:settings];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:92.0/255.0 green:119.0/255.0 blue:149.0/255.0 alpha:1.0]];
    
    hadOrganicStartup = YES;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    hadOrganicStartup = NO;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (!hadOrganicStartup) {
        [self showSplashView];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark utility methods

// Shows a splash screen on the root view controller
-(void)showSplashView
{
    splashScreen = [UIView new];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // Set its frame to the screen rect
    [splashScreen setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    [splashScreen setBackgroundColor:[UIColor colorWithRed:145.0/255.0 green:195.0/255.0 blue:236.0/255.0 alpha:1.0]];
    
    [self.window addSubview: splashScreen];
    [self.window bringSubviewToFront: splashScreen];
    [self.window makeKeyAndVisible];

    // Remove it via timer, after 5 seconds
    __unused NSTimer *removeTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(removeSplashView) userInfo:nil repeats:NO];
}

-(void)removeSplashView {
    [splashScreen removeFromSuperview];
}


@end
