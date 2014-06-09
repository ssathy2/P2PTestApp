 //
//  DDDVideoOutputStreamingController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoOutputStreamingController.h"
#import "DDDPeerKitContainer.h"
#import "DDDBufferConverter.h"

#define DDDBufferDelegateQueue "DDDBufferDelegateQueue"

@interface DDDVideoOutputStreamingController()<AVCaptureVideoDataOutputSampleBufferDelegate, DDDPeerKitConnectionListener>
// AV Capture Related
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoDataOutput *captureOutput;
@property (strong, nonatomic) dispatch_queue_t captureDelegateQueue;

// Peer to Stream Mapping
@property (strong, nonatomic) NSHashTable *streams;
@property (strong, nonatomic) NSLock *streamsLock;

// Buffer Conversion
@property (strong, nonatomic) DDDBufferConverter *bufferConverter;
@end

@implementation DDDVideoOutputStreamingController
- (id)init
{
	self = [super init];
	if(self)
	{
		self.captureDelegateQueue = dispatch_queue_create(DDDBufferDelegateQueue, NULL);
		self.streams = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
		self.streamsLock = [NSLock new];
		self.bufferConverter = [DDDBufferConverter new];
		[[DDDPeerKitContainer sharedInstance] registerListener:self];
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
		[self.captureOutput setSampleBufferDelegate:self queue:self.captureDelegateQueue];
	}
}

- (void)startStreamingToPeers
{
	[[DDDPeerKitContainer sharedInstance] startStreamWithAllPeers];
}

- (void)stopStreamingToPeers
{
	[self.streamsLock lock];
	for(DDDOutputVideoStream *stream in self.streams)
	{
		[stream stopStream];
	}
	[self.streamsLock unlock];
}

#pragma mark - DDDPeerKitConnectionListener
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didOpenStream:(DDDRemoteOutputStreamWrapper *)stream
{
	[self.streamsLock lock];
	DDDOutputVideoStream *videoStream = [DDDOutputVideoStream outputVideoStreamWithOutputStreamWrapper:stream];
	[videoStream startStream];
	[self.streams addObject:videoStream];
	[self.streamsLock unlock];
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
	[self.streamsLock lock]; 
	for (DDDOutputVideoStream *stream in self.streams)
	{
		NSData *data = [self.bufferConverter dataFromSampleBuffer:sampleBuffer];
		[stream writeDataTostream:data];
		NSLog(@"Data Length: %li", data.length);
		
	}
	[self.streamsLock unlock];

}
@end
