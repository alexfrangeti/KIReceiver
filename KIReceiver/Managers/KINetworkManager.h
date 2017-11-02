//
//  KINetworkManager.h
//  KIReceiver
//
//  Created by Alexandru Frangeti on 31.10.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import <Foundation/Foundation.h>

// KINetworkManagerDelegate
// Protocol. Ensures that the methods listed below are implemented
// by the network manager delegate object.
@protocol KINetworkDelegate <NSObject>
@required

// Called when we have no access to background location access
- (void)managerDidUnlock;

@end

@interface KINetworkManager : NSObject

// The manager's delegate object
@property (weak) id<KINetworkDelegate> networkDelegate;

// The constructor
- (instancetype)initWithDelegate:(id<KINetworkDelegate>)delegate;

// Unlock request method
- (void)requestUnlockForNumber:(NSString *)lockNumber;

// Debug mode method
- (void)setDebugEnabled:(BOOL)debugEnabled;

@end
