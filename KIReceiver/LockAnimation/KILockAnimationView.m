//
//  KILockAnimationView.m
//  KIReceiver
//
//  Created by Alexandru Frangeti on 01.11.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import "KILockAnimationView.h"
#import "KILockView.h"
#import "KIFrameView.h"

@implementation KILockAnimationView {
    UIView *_squareView; // The inside frame of the lock
    UIView *_ballContainerView; // Container view, used to allow sliding beyond the bounds of the ballView
    UIView *_ballView; // The central ellipse that slides and unlocks
    KILockView *_lockView; // The upper side of the lock
    BOOL _animationState; // For locking-unlocking
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        UIColor *borderColor = [UIColor whiteColor];
        float borderWidth = 4.0f;
        
        _lockView = [KILockView new];
        _lockView.frame = CGRectMake(0, 0, 200, 160);
        _lockView.backgroundColor = [UIColor clearColor];
        [self addSubview:_lockView];
        
        _squareView = [KIFrameView new];
        _squareView.layer.cornerRadius = 20.0f;
        _squareView.layer.borderColor = borderColor.CGColor;
        _squareView.layer.borderWidth = borderWidth;
        _squareView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_squareView];
        
        _ballContainerView = [UIView new];
        _ballContainerView.layer.cornerRadius = 11;
        _ballContainerView.layer.borderColor = [UIColor clearColor].CGColor;
        _ballContainerView.layer.borderWidth = borderWidth;
        _ballContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [_squareView addSubview:_ballContainerView];
        
        _ballView = [[UIView alloc] initWithFrame:CGRectMake(-2, -4, 30, 30)];
        _ballView.layer.borderWidth = borderWidth;
        _ballView.layer.borderColor = borderColor.CGColor;
        _ballView.layer.cornerRadius = 15;
        _ballView.layer.masksToBounds = YES;
        [_ballContainerView addSubview:_ballView];
        
        // Set constraints on all subviews
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_squareView, _ballContainerView);
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_squareView(225)]" options:0 metrics:nil views:views]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_squareView(190)]" options:0 metrics:nil views:views]];
        [[NSLayoutConstraint constraintWithItem:_squareView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:_squareView attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottomMargin multiplier:1.0f constant:-20] setActive:YES];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_ballContainerView(48)]" options:0 metrics:nil views:views]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_ballContainerView(22)]" options:0 metrics:nil views:views]];
        [[NSLayoutConstraint constraintWithItem:_ballContainerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_squareView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0] setActive:YES];
        [[NSLayoutConstraint constraintWithItem:_ballContainerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_squareView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0] setActive:YES];
    }
    
    return self;
}

- (void)dealloc {

}

- (void)layoutSubviews {
    // Initial properties
    _lockView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds) - 155 - CGRectGetMidY(_lockView.bounds));
    _lockView.transform = CGAffineTransformMakeRotation(0 * M_PI/180.0);
    _ballView.frame = CGRectMake(-2, -4, 30, 30);
    _squareView.backgroundColor = self.backgroundColor;
    _ballView.backgroundColor = self.backgroundColor;
    _animationState = NO;
}

- (void)animateUnlock {
    // against firing animations on viewDidLoad getting borked.
    __unused NSTimer *animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(unlockAnimation) userInfo:nil repeats:NO];
}

- (void)animateLock {
    // against firing animations on viewDidLoad getting borked.
    __unused NSTimer *animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(lockAnimation) userInfo:nil repeats:NO];
}

-(void)unlockAnimation {
    _animationState = YES;
    
    // Animate the central ball frame
    [UIView animateWithDuration:0.4f animations:^{
        CGRect r = _ballView.frame;
        r.size.width += 4;
        _ballView.frame = r;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0
                              delay:.0
             usingSpringWithDamping:0.55
              initialSpringVelocity:.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect r = _ballView.frame;
                             r.size.width -= 4;
                             r.origin.x += 22;
                             _ballView.frame = r;
                             _ballView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                         }completion:nil];
    }];
    
    // Animate the outer lock
    [UIView animateWithDuration:1.0
                          delay:.65f
         usingSpringWithDamping:0.3
          initialSpringVelocity:4.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _lockView.center = CGPointMake(_lockView.center.x + 30, _lockView.center.y - 10);
                         _lockView.transform = CGAffineTransformMakeRotation(30 * M_PI/180.0);
                     }completion:nil];
}

- (void)lockAnimation {
    _animationState = NO;
    
    // Animate the central ball frame
    [UIView animateWithDuration:0.4f animations:^{
        CGRect r = _ballView.frame;
        r.size.width += 4;
        r.origin.x -= 4;
        _ballView.frame = r;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0
                              delay:.0
             usingSpringWithDamping:0.55
              initialSpringVelocity:.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect r = _ballView.frame;
                             r.size.width -= 4;
                             r.origin.x -= 18;
                             _ballView.frame = r;
                             _ballView.layer.backgroundColor = self.backgroundColor.CGColor;
                         }completion:nil];
    }];
    
    // Animate the outer lock
    [UIView animateWithDuration:0.4f delay:.65 options:0 animations:^{
        _lockView.center = CGPointMake(_lockView.center.x - 30, _lockView.center.y + 10);
        _lockView.transform = CGAffineTransformMakeRotation(0 * M_PI/180.0);
    } completion:nil];
}

@end
