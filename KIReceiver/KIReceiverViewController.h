//
//  KIReceiverViewController.h
//  KIReceiver
//
//  Created by Alexandru Frangeti on 31.10.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIRegionMonitorManager.h"
#import "KINetworkManager.h"

@interface KIReceiverViewController : UIViewController <KIRegionMonitorDelegate, KINetworkDelegate>

@end

