//
//  DDDOutputVideoStream.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDOutputVideoStream.h"
#define DDDBufferDelegateQueue "com.ddd.videopreviewdelegatequeue"

@interface DDDOutputVideoStream()<AVCaptureVideoDataOutputSampleBufferDelegate, NSStreamDelegate>
@property (strong, nonatomic) dispatch_queue_t delegateQueue;
@property (strong, nonatomic) AVCaptureVideoDataOutput *outputDevice;
@property (assign, nonatomic) NSInteger overallBytesWritten;
@property (strong, nonatomic) NSOutputStream *stream;
@end

@implementation DDDOutputVideoStream

+ (instancetype)videoStreamWithCaptureOutput:(AVCaptureVideoDataOutput *)output
{
	DDDOutputVideoStream *stream = [DDDOutputVideoStream new];
	stream.outputDevice = output;
	return stream;
}

- (void)setOutputDevice:(AVCaptureVideoDataOutput *)outputDevice
{
	_outputDevice = outputDevice;
	[_outputDevice setSampleBufferDelegate:self queue:self.delegateQueue];
}

- (id)init
{
	self = [super init];
	if(self)
	{
		self.overallBytesWritten = 0;
		self.delegateQueue = dispatch_queue_create(DDDBufferDelegateQueue, DISPATCH_QUEUE_SERIAL);
		self.stream = [NSOutputStream outputStreamToMemory];
	}
	return self;
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
	[self writeBufferToStream:sampleBuffer];
	NSLog(@"Capture Output Delegate Called!");
}

// Helpers
- (void)writeBufferToStream:(CMSampleBufferRef)sampleBuffer
{
	if ([self.stream hasSpaceAvailable])
	{
		NSData *data = [NSData dataFromSampleBuffer:sampleBuffer];
		[self.stream write:data.bytes maxLength:data.length];
		self.overallBytesWritten += data.length;
	}
}

- (void)startStream
{
	if (self.stream.streamStatus == NSStreamStatusNotOpen)
	{
		[self.stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		self.stream.delegate = self;
		[self.stream open];
	}
}

- (void)stopStream
{
	if (self.stream.streamStatus == NSStreamStatusOpen)
	{
		[self.stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[self.stream close];
	}
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	NSLog(@"Stream Event");
}

@end
