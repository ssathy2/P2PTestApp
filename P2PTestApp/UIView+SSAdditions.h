//
//  UIView+SSAdditions.h
//  SWAiOS
//
//  Created by Sidd Sathyam on 12/20/13.
//  Copyright (c) 2013 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SSAdditions)

- (void)showLoadingOverlay;
- (void)hideLoadingOverlay;

- (void)darkenView;
- (void)undarkView;

- (void)setDarkViewAlpha:(CGFloat)alpha;
@end
