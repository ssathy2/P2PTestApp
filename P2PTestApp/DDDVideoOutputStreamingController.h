//
//  DDDOutputStreamingController.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDVideoOutputStreamingController : NSObject

+ (instancetype)controllerWithCaptureSession:(AVCaptureSession *)session;

// This method initalizes an output stream and fills the stream with the frames from the output device and starts the stream
- (NSOutputStream *)startStreamWithDeviceID:(MCPeerID *)peerID;
- (void)stopStreamWithDeviceID:(MCPeerID *)peerID;
@end
