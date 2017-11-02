//
//  KIRegionMonitorManager.m
//  KIReceiver
//
//  Created by Alexandru Frangeti on 01.11.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import "KIRegionMonitorManager.h"

@interface KIRegionMonitorManager() {
    CLLocationManager *locationManager;
    CLBeaconRegion *beaconRegion;
    CLBeacon *rangedBeacon;
    BOOL hasRequestInProgress;
}

@end

@implementation KIRegionMonitorManager

@synthesize scanDelegate;

- (instancetype)initWithDelegate:(id<KIRegionMonitorDelegate>)delegate {
    self = [super init];
    if (self) {
        self.scanDelegate = delegate;
        
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
        [locationManager setAllowsBackgroundLocationUpdates:YES];
        
        rangedBeacon = [CLBeacon new];
        hasRequestInProgress = NO;
    }
    return self;
}

- (void)startMonitoringRegion:(CLBeaconRegion *)region {
    hasRequestInProgress = YES;
    beaconRegion = region;
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            // If no auth happened yet, request it
            [locationManager requestAlwaysAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            // Call the delegate method to inform the user that we need bg permissions
            if (scanDelegate) {
                [scanDelegate managerHasBackgroundLocationAccessDisabled];
            }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            // All good, proceed with monitoring
            [locationManager startMonitoringForRegion:region];
            hasRequestInProgress = NO;
        default:
            break;
    }
}

- (void)stopMonitoring {
    hasRequestInProgress = NO;
    
    if (beaconRegion) {
        [locationManager stopRangingBeaconsInRegion:beaconRegion];
        [locationManager stopMonitoringForRegion:beaconRegion];
    }
    
    [locationManager stopUpdatingLocation];
    
    beaconRegion = nil;
    
    if (scanDelegate) {
        [scanDelegate managerDidStopMonitoring];
    }
}

#pragma mark CLLocationManager delegate methods

// Called when the auth status for the application has changed.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        if (hasRequestInProgress) {
            [locationManager startMonitoringForRegion:beaconRegion];
            hasRequestInProgress = NO;
        }
        [locationManager startUpdatingLocation];
    }
}

// Called when a new region is being monitored
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(nonnull CLRegion *)region {
    if (scanDelegate) {
        [scanDelegate managerDidStartMonitoring];
    }
    [locationManager requestStateForRegion:region];
}

// Called when there's a state determined for the region (in it, outside of it or unknown)
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(nonnull CLRegion *)region {
    if (state == CLRegionStateInside) {
        [locationManager startRangingBeaconsInRegion:beaconRegion];
    } else {
        [locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
}

// Called when the manager entered a region
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(nonnull CLRegion *)region {
    if (scanDelegate) {
        [scanDelegate managerDidEnterRegion:region];
    }
}

// Called when the manager exited a region
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(nonnull CLRegion *)region {
    if (scanDelegate) {
        [scanDelegate managerDidExitRegion:region];
    }
}

// Called when one ore more beacons become available in the specified region. Also called when the range changes.
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    if (beacons.count > 0) {
        // We work with the closest beacon
        CLBeacon *rangedBeacon = [beacons objectAtIndex:0];
        if (scanDelegate) {
            [scanDelegate managerDidRangeBeacon:rangedBeacon inRegion:region];
        }
    }
}

// Called when region monitoring fails
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(nullable CLRegion *)region withError:(nonnull NSError *)error {
    if (scanDelegate) {
        [scanDelegate onMonitoringError:error];
    }
}

// Called when ranging beacons fails for a region.
- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(nonnull CLBeaconRegion *)region withError:(nonnull NSError *)error {
    if (scanDelegate) {
        [scanDelegate onRangingError:error];
    }
}

// Called for example when the user denies location services usage.
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error {
    if (error.code == kCLErrorDenied) {
        [self stopMonitoring];
    }
}

@end
