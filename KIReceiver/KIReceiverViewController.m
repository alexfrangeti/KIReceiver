//
//  KIReceiverViewController.m
//  KIReceiver
//
//  Created by Alexandru Frangeti on 31.10.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import "KIReceiverViewController.h"
#import "KILockAnimationView.h"
#import "KIRegionMonitorManager.h"
#import <CoreLocation/CoreLocation.h>

@interface KIReceiverViewController () {
    KILockAnimationView *lockAnimation;
    KIRegionMonitorManager *monitoringManager;
    KINetworkManager *networkManager;
    NSLengthFormatter *lengthFormatter;
    NSTimer *authTimer;
    NSUInteger lastDistanceToEmitter;
}

@end

@implementation KIReceiverViewController

NSString *const beaconRegionID = @"KIBroadcaster";
NSString *const beaconUUID = @"0636A317-770A-428E-BBB2-7FCC2D9819ED";
NSUInteger const beaconMinor = 1;
NSUInteger const beaconMajor  = 1;
float const unlockTimerFreq = 4;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    monitoringManager = [[KIRegionMonitorManager alloc] initWithDelegate:self];
    lengthFormatter = [NSLengthFormatter new];
    
    networkManager = [[KINetworkManager alloc] initWithDelegate:self];
    [networkManager setDebugEnabled:YES];
    
    lockAnimation = [KILockAnimationView new];
    [self.view addSubview:lockAnimation];
    [lockAnimation setTranslatesAutoresizingMaskIntoConstraints:NO];
    lockAnimation.backgroundColor = self.view.backgroundColor;
    
    // Autolayout constraints
    NSDictionary *views = @{
                            @"self.view" : self.view,
                            @"lockAnimation" : lockAnimation
                            };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lockAnimation(200)]" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lockAnimation attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lockAnimation]-200-|" options:0 metrics:nil views:views]];
    
    // Start monitoring
    NSUUID *broadcastUUID = [[NSUUID alloc] initWithUUIDString:beaconUUID];
    CLBeaconRegion *scanRegion = [[CLBeaconRegion alloc] initWithProximityUUID:broadcastUUID major:beaconMajor minor:beaconMinor identifier:beaconRegionID];
    [scanRegion setNotifyEntryStateOnDisplay:YES];
    [scanRegion setNotifyOnEntry:YES];
    [scanRegion setNotifyOnExit:YES];

    [monitoringManager startMonitoringRegion:scanRegion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark KIRegionMonitorDelegate methods

- (void)managerHasBackgroundLocationAccessDisabled {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Background Location access is disabled. This application needs it enabled in order to perform properly." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSURL *openSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (openSettings) {
            [[UIApplication sharedApplication] openURL:openSettings options:[NSDictionary new] completionHandler:nil];
        }
    }];
    [alert addAction:settingsAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)managerDidStopMonitoring {

}

- (void)managerDidStartMonitoring {

}

- (void)managerDidEnterRegion:(CLRegion *)region {

}

- (void)managerDidExitRegion:(CLRegion *)region {

}

- (void)managerDidRangeBeacon:(CLBeacon *)beacon inRegion:(CLRegion *)region {
    // We just need to store the distance to the beacon for this demo
    NSString *distance = [lengthFormatter stringFromMeters:beacon.accuracy];
    lastDistanceToEmitter = abs([distance intValue]);
    
    // Setup the timer that calls the API
    if ([self beaconIsInRequiredRange:lastDistanceToEmitter]) {
        if (!authTimer) {
            authTimer = [NSTimer scheduledTimerWithTimeInterval:unlockTimerFreq target:self selector:@selector(requestUnlock) userInfo:nil repeats:YES];
            [self requestUnlock];
        }
    }
}

- (void)requestUnlock {
    if ([self beaconIsInRequiredRange:lastDistanceToEmitter]) {
        [networkManager requestUnlockForNumber:@"5873"];
    }
}

#pragma mark KINetworkDelegate

- (void)managerDidUnlock {
    // run the animation on the main thread
    [self performSelectorOnMainThread:@selector(animateUnlock) withObject:nil waitUntilDone:NO];
}

- (void)animateUnlock {
    [lockAnimation animateUnlock];
    // for the sake of the animation cycle, lock back the lock after 2 seconds
    __unused NSTimer *lockTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
        [lockAnimation animateLock];
    }];
}

#pragma mark Utility methods

// Convenience method to express minimum distance to the beacon
- (BOOL)beaconIsInRequiredRange:(NSUInteger)distanceToBeacon {
    return (distanceToBeacon > 0 && distanceToBeacon < 50);
}

@end
