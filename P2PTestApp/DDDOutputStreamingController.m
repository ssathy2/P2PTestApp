//
//  DDDOutputStreamingController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDOutputStreamingController.h"
#import "DDDOutputVideoStream.h"

@interface DDDOutputStreamingController()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (strong, nonatomic) NSMutableDictionary *peerToStreamMapping;
@end

@implementation DDDOutputStreamingController
- (id)init
{
	self = [self init];
	if(self)
	{
		self.peerToStreamMapping = [NSMutableDictionary dictionary];
	}
	return self;
}

- (NSOutputStream *)startStreamWithCaptureInput:(AVCaptureDeviceInput *)input withDeviceID:(MCPeerID *)peerID
{
	
}

@end
