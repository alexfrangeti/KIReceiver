//
//  KISettingsDataSource.m
//  KIReceiver
//
//  Created by Alexandru Frangeti on 01.11.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import "KISettingsDataSource.h"

@interface KISettingsDataSource() {
    NSArray *dataModel;
}

@end

@implementation KISettingsDataSource

// Constants
NSString* const imageKey = @"image";
NSString* const textKey = @"text";

-(id)init {
    self = [super init];
    if (self) {
        // The model characteristics: NSArray of NSArrays ( for each section ) of NSDictionaries ( for each row ) that contain image and text as keys.
        NSArray *firstSectionModel = [NSArray arrayWithObjects:
                                      @{@"image":@"",@"text":@"Name, Phone Numbers, Email"},
                                      @{@"image":@"",@"text":@"Password & Security"},
                                      @{@"image":@"",@"text":@"Payment & Shipping"},
                                      nil];
        NSArray *secondSectionModel = [NSArray arrayWithObjects:
                                      @{@"image":@"icloud",@"text":@"iCloud"},
                                      @{@"image":@"appstore",@"text":@"iTunes & App Store"},
                                      @{@"image":@"family",@"text":@"Set Up Family Sharing..."},
                                      nil];
        dataModel = [NSArray arrayWithObjects:firstSectionModel, secondSectionModel, nil];
        
    }
    return self;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataModel count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionModel = [dataModel objectAtIndex:section];
    return [sectionModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *firstSectionCellIdentifier = @"FirstCellIdentifier";
    static NSString *secondSectionCellIdentifier = @"SecondCellIdentifier";
    UITableViewCell *cell;
    
    NSArray *sectionModel = [dataModel objectAtIndex:[indexPath section]];
    NSDictionary *rowModel = [sectionModel objectAtIndex:[indexPath row]];
    
    switch ([indexPath section]) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:firstSectionCellIdentifier];
            if (cell == nil) {
                // Standard cell in this case
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstSectionCellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            }
            
            // Set the disclosure indicator, just the last cell of the second section should not have it
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            break;
        }
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:secondSectionCellIdentifier];
            if (cell == nil) {
                // UITableViewCellStyleSubtitle in this case ( for the imageView )
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:secondSectionCellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            }
            
            NSString *cellImageName = [rowModel objectForKey:imageKey];
            [cell.imageView setImage:[UIImage imageNamed:cellImageName]];
            
            if (indexPath.row != sectionModel.count - 1) {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            } else {
                [cell.textLabel setTextColor:[UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:1.0]];
            }
            
            break;
        }
        default:
            break;
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [rowModel objectForKey:textKey]]];
    
    return cell;
}

@end
