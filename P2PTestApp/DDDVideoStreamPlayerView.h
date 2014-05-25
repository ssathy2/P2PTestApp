//
//  DDDVideoStreamPlayerView.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDVideoStreamPlayerView : UIView
- (void)updateWithInputStream:(NSInputStream *)stream;
@end
