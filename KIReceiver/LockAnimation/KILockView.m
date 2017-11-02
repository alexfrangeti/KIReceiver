//
//  KILockView.m
//  KIReceiver
//
//  Created by Alexandru Frangeti on 01.11.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import "KILockView.h"

@implementation KILockView

- (void)drawRect:(CGRect)rect {
    
    //Outer arc of the lock
    CGRect outerArcRect = CGRectMake(20, 30, 157, 157);
    UIBezierPath* outerArcPath = [UIBezierPath bezierPath];
    [outerArcPath addArcWithCenter: CGPointMake(CGRectGetMidX(outerArcRect), CGRectGetMidY(outerArcRect)) radius: outerArcRect.size.width / 2 startAngle: 180 * M_PI/180 endAngle: 19 * M_PI/180 clockwise: YES];
    
    [UIColor.whiteColor setStroke];
    outerArcPath.lineWidth = 4;
    [outerArcPath stroke];
    
    // Inner arc of the lock
    CGRect innerArcRect = CGRectMake(49, 60, 97, 97);
    UIBezierPath* innerArcPath = [UIBezierPath bezierPath];
    [innerArcPath addArcWithCenter: CGPointMake(CGRectGetMidX(innerArcRect), CGRectGetMidY(innerArcRect)) radius: innerArcRect.size.width / 2 startAngle: 180 * M_PI/180 endAngle: 19 * M_PI/180 clockwise: YES];
    
    [UIColor.whiteColor setStroke];
    innerArcPath.lineWidth = 4;
    [innerArcPath stroke];
    
    // Segment uniting the two arcs
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(20, 104.5f, 29, 4)];
    [UIColor.whiteColor setFill];
    [rectanglePath fill];
}


@end
