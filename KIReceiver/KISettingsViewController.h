//
//  KISettingsViewController.h
//  KIReceiver
//
//  Created by Alexandru Frangeti on 31.10.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KISettingsViewController : UIViewController <UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *profileTableView;
@property (nonatomic, strong) IBOutlet UIView *profileContainerView;

@end

