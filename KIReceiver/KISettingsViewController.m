//
//  KISettingsViewController.m
//  KIReceiver
//
//  Created by Alexandru Frangeti on 31.10.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import "KISettingsViewController.h"
#import "KISettingsDataSource.h"

@interface KISettingsViewController () {
    KISettingsDataSource *dataSource;
}

@end

@implementation KISettingsViewController

@synthesize profileContainerView;
@synthesize profileTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init the datasource
    dataSource = [KISettingsDataSource new];
    
    profileTableView.delegate = self;
    profileTableView.dataSource = dataSource;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews {
    // Round the corners of the profile image
    [profileContainerView.layer setCornerRadius:profileContainerView.frame.size.width / 2];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0;
    }
    return 0;
}


@end
