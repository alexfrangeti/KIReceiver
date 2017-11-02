//
//  KIFrameView.m
//  KIReceiver
//
//  Created by Alexandru Frangeti on 01.11.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import "KIFrameView.h"

@implementation KIFrameView

- (void)drawRect:(CGRect)rect {
    CGFloat xPos = CGRectGetMidX(self.bounds) - 48 / 2.0f;
    CGFloat yPos = CGRectGetMidY(self.bounds) - 22 / 2.0f;
    
    // The inner part of the lock, on which the lock ellipse will slide
    UIBezierPath* lockCenterPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(xPos, yPos, 48, 22) cornerRadius: 11];
    [UIColor.whiteColor setStroke];
    lockCenterPath.lineWidth = 4;
    [lockCenterPath stroke];
}

@end
