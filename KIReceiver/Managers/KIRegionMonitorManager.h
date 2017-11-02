//
//  KIRegionMonitorManager.h
//  KIReceiver
//
//  Created by Alexandru Frangeti on 01.11.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// KIRegionMonitorDelegate
// Protocol. Ensures that the methods listed below are implemented
// by the monitor delegate object.
@protocol KIRegionMonitorDelegate <NSObject>
@required

// Called when we have no access to background location access
- (void)managerHasBackgroundLocationAccessDisabled;

// Called when the range monitoring starts
- (void)managerDidStartMonitoring;

// Called when the range monitoring stops
- (void)managerDidStopMonitoring;

// Called when the manager enters a specific region
- (void)managerDidEnterRegion:(CLRegion *)region;

// Called when the manager exists a specific region
- (void)managerDidExitRegion:(CLRegion *)region;

// Called when the manager ranges a beacon in a specific region
- (void)managerDidRangeBeacon:(CLBeacon *)beacon inRegion:(CLRegion *)region;

@optional

// Called on monitoring errors that the manager signals
- (void)onMonitoringError:(NSError *)error;

// Called on ranging errors that the manager signals
- (void)onRangingError:(NSError *)error;

@end

@interface KIRegionMonitorManager : NSObject <CLLocationManagerDelegate>

// The manager's delegate object
@property (weak) id<KIRegionMonitorDelegate>scanDelegate;

// The constructor
- (instancetype)initWithDelegate:(id<KIRegionMonitorDelegate>)delegate;

// Method for starting monitoring on a specific region
- (void)startMonitoringRegion:(CLBeaconRegion *)region;

// Method for stopping monitoring
- (void)stopMonitoring;

@end
