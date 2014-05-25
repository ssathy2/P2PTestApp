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

@interface DDDVideoOutputStreamingController()<AVCaptureVideoDataOutputSampleBufferDelegate, DDDOutputVideoStreamDataSource, DDDPeerKitConnectionListener>
// AV Capture Related
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoDataOutput *captureOutput;
@property (strong, nonatomic) dispatch_queue_t queue;

// Peer to Stream Mapping
@property (strong, nonatomic) NSHashTable *streams;
@property (strong, nonatomic) NSLock *streamsLock;

// Stream to Data Mapping
@property (strong, nonatomic) NSMutableDictionary *streamToDataMapping;
@property (strong, nonatomic) NSLock *streamToDataLock;

// Buffer Conversion
@property (strong, nonatomic) DDDBufferConverter *bufferConverter;
@end

@implementation DDDVideoOutputStreamingController
- (id)init
{
	self = [super init];
	if(self)
	{
		self.queue = dispatch_queue_create(DDDBufferDelegateQueue, NULL);
		self.streams = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
		self.streamToDataMapping = [NSMutableDictionary dictionary];
		self.streamsLock = [NSLock new];
		self.streamToDataLock = [NSLock new];
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
		[self.captureOutput setSampleBufferDelegate:self queue:self.queue];
	}
}

- (void)startStreamingToPeers
{
	[[DDDPeerKitContainer sharedInstance] startStreamWithAllPeers];
}

- (void)stopStreamingToPeers
{
	
}

#pragma mark - DDDPeerKitConnectionListener
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didOpenStream:(DDDRemoteOutputStreamWrapper *)stream
{
	[self.streamsLock lock];
	DDDOutputVideoStream *videoStream = [DDDOutputVideoStream outputVideoStreamWithOutputStreamWrapper:stream];
	videoStream.datasource = self;
	[self.streams addObject:videoStream];
	[videoStream startStream];
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
	//	[self.streamWriteQueue addOperationWithBlock:^{
	//		[self writeBufferToStream:sampleBuffer];
	//	}];
	[self.streamsLock lock];
	for (DDDOutputVideoStream *stream in self.streams)
	{
		[self.streamToDataLock lock];
		NSMutableData *data = [self.streamToDataMapping objectForKey:stream.streamIdentifier];
		if (!data)
			data = [NSMutableData new];
		[data appendData:[self.bufferConverter dataFromSampleBuffer:sampleBuffer]];
		[self.streamToDataMapping setObject:data forKey:stream.streamIdentifier];
		[self.streamToDataLock unlock];
	}
	[self.streamsLock unlock];
}

- (NSData *)dataToWriteToStreamID:(NSUUID *)streamID
{
	NSMutableData *dataToWrite = nil;
	[self.streamToDataLock lock];
	dataToWrite = [[self.streamToDataMapping objectForKey:streamID] copy];
	NSMutableData *ref = [self.streamToDataMapping objectForKey:streamID];
	[ref setLength:0];
	if (ref)
		[self.streamToDataMapping setObject:ref forKey:streamID];
	
	[self.streamToDataLock unlock];
	return dataToWrite;
}
@end
