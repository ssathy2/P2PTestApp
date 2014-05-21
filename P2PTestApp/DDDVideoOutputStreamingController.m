//
//  DDDVideoOutputStreamingController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoOutputStreamingController.h"
#import "DDDOutputVideoStream.h"

@interface DDDVideoOutputStreamingController()<AVCaptureVideoDataOutputSampleBufferDelegate, NSStreamDelegate>
@property (strong, nonatomic) NSMutableDictionary *peerToStreamMapping;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoDataOutput *captureOutput;
@property (strong, nonatomic) NSRunLoop *streamingRunLoop;
@end

@implementation DDDVideoOutputStreamingController
- (id)init
{
	self = [super init];
	if(self)
	{
		self.peerToStreamMapping = [NSMutableDictionary dictionary];
	}
	return self;
}

+ (instancetype)controllerWithCaptureSession:(AVCaptureSession *)session
{
	DDDVideoOutputStreamingController *controller = [DDDVideoOutputStreamingController new];
	controller.captureSession = session;
	[controller setupCaptureOutput];
	[controller setupCapture];
	[controller setupRunLoop];	
	return controller;
}

- (void)setupCaptureOutput
{
	self.captureOutput = [AVCaptureVideoDataOutput new];
}

- (void)setupCapture
{
	if([self.captureSession canAddOutput:self.captureOutput])
	{
		[self.captureSession addOutput:self.captureOutput];
	}
}

- (void)setupRunLoop
{
	self.streamingRunLoop = [NSRunLoop currentRunLoop];
}


- (NSOutputStream *)startStreamWithDeviceID:(MCPeerID *)peerID
{
	NSAssert(peerID, @"Can't start stream without a valid peerID");
	
	DDDOutputVideoStream *stream = [self.peerToStreamMapping objectForKey:peerID];
	if (!stream)
	{
		stream = [DDDOutputVideoStream videoStreamWithCaptureOutput:self.captureOutput];
		stream.delegate = self;
		[stream scheduleInRunLoop:self.streamingRunLoop forMode:NSDefaultRunLoopMode];
		[stream open];
	}
	return stream;
}

- (void)stopStreamWithDeviceID:(MCPeerID *)peerID
{
	NSAssert(peerID, @"Can't start stream without a AVCaptureVideoDataOutput AND/OR a peerID");
	DDDOutputVideoStream *stream = [self.peerToStreamMapping objectForKey:peerID];
	if (stream)
	{
		[stream removeFromRunLoop:self.streamingRunLoop forMode:NSDefaultRunLoopMode];
		[stream close];
		[self.peerToStreamMapping removeObjectForKey:peerID];
	}
}

#pragma mark - NSStreamDelegate Methods
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	
}

@end
