//
//  DDDOutputStreamingController.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDDOutputVideoStream.h"

@interface DDDVideoOutputStreamingController : NSObject

+ (instancetype)controllerWithCaptureSession:(AVCaptureSession *)session;

- (void)startStreamingToPeers:(NSArray *)peers;
- (void)stopStreamingToPeers:(NSArray *)peers;
@end
