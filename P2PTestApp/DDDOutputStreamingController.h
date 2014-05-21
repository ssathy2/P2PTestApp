//
//  DDDOutputStreamingController.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDOutputStreamingController : NSObject

// This method initalizes an output stream and fills the stream with the frames from the output device
- (NSOutputStream *)startStreamWithCaptureInput:(AVCaptureDeviceFormat *)output withDeviceID:(MCPeerID *)peerID;
@end
