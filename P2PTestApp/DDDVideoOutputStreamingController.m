 //
//  DDDVideoOutputStreamingController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoOutputStreamingController.h"

#define DDDBufferDelegateQueue "DDDBufferDelegateQueue"

@interface DDDVideoOutputStreamingController()<AVCaptureVideoDataOutputSampleBufferDelegate, DDDOutputVideoStreamDataSource>
@property (strong, nonatomic) NSMutableDictionary *peerToStreamMapping;
@property (strong, nonatomic) NSLock *peerToStreamLock;

@property (strong, nonatomic) NSMutableDictionary *streamToDataToWriteMapping;
@property (strong, nonatomic) NSLock *streamDataToWriteLock;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoDataOutput *captureOutput;
@property (strong, nonatomic) dispatch_queue_t queue;
@end

@implementation DDDVideoOutputStreamingController
- (id)init
{
	self = [super init];
	if(self)
	{
		self.peerToStreamMapping = [NSMutableDictionary dictionary];
		self.streamToDataToWriteMapping = [NSMutableDictionary dictionary];
		self.queue = dispatch_queue_create(DDDBufferDelegateQueue, NULL);
	}
	return self;
}

+ (instancetype)controllerWithCaptureSession:(AVCaptureSession *)session
{
	DDDVideoOutputStreamingController *controller = [DDDVideoOutputStreamingController new];
	controller.captureSession = session;
	[controller setupCaptureOutput];
	[controller setupCapture];
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
		[self.captureOutput setSampleBufferDelegate:self queue:self.queue];
	}
}

- (void)startStreamingToPeers:(NSArray *)peers
{
	for (MCPeerID *peer in peers)
	{
		[self startStreamToPeer:peer];
	}
}

- (void)stopStreamingToPeers:(NSArray *)peers
{
	for (MCPeerID *peer in peers)
	{
		[self stopStreamToPeer:peer];
	}
}

- (DDDOutputVideoStream *)startStreamToPeer:(MCPeerID *)peerID
{
	NSAssert(peerID, @"Can't start stream without a valid peerID");
	DDDOutputVideoStream *stream = [self.peerToStreamMapping objectForKey:peerID];
	if (!stream)
	{
		stream = [DDDOutputVideoStream new];
		[self.peerToStreamMapping setObject:stream forKey:peerID];
		stream.datasource = self;
		[stream startStream];
	}
	return stream;
}

- (void)stopStreamToPeer:(MCPeerID *)peerID
{
	NSAssert(peerID, @"Can't start stream without a AVCaptureVideoDataOutput AND/OR a peerID");
	DDDOutputVideoStream *stream = [self.peerToStreamMapping objectForKey:peerID];
	if (stream)
	{
		[stream stopStream];
		[self.peerToStreamMapping removeObjectForKey:peerID];
	}
}

//AVCaptureVideoDataOutputSampleBufferDelegate methods
- (void)captureOutput:(AVCaptureOutput *)captureOutput
  didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer
	   fromConnection:(AVCaptureConnection *)connection
{
	// TODO: Figure out how to process dropped frames...Ignore dropped frames for now
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
	   fromConnection:(AVCaptureConnection *)connection
{
	// Add the sample buffer to the data. Since we've got a serial queue, the frames can be added in order at which they're recieved
	//	[self.streamWriteQueue addOperationWithBlock:^{
	//		[self writeBufferToStream:sampleBuffer];
	//	}];
	NSLog(@"Capture Output Delegate Called!");
	[self.streamDataToWriteLock lock];
	for (DDDOutputVideoStream *stream in self.peerToStreamMapping.allValues)
	{
		NSMutableData *data = [self.streamToDataToWriteMapping objectForKey:stream.streamIdentifier];
		[data appendData:[NSData dataFromSampleBuffer:sampleBuffer]];
	}
	[self.streamDataToWriteLock unlock];
}

- (NSData *)dataToWriteToStreamID:(NSUUID *)streamID
{
	NSMutableData *dataToWrite = nil;
	[self.streamDataToWriteLock lock];
	dataToWrite = [[self.streamToDataToWriteMapping objectForKey:streamID] copy];
	NSMutableData *ref = [self.streamToDataToWriteMapping objectForKey:streamID];
	[ref setLength:0];
	if (ref)
		[self.streamToDataToWriteMapping setObject:ref forKey:streamID];
	[self.streamDataToWriteLock unlock];
	return dataToWrite;
}
@end
