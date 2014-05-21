//
//  DDDOutputVideoStream.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDOutputVideoStream.h"
#define DDDBufferDelegateQueue "com.ddd.videopreviewdelegatequeue"

@interface DDDOutputVideoStream()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (strong, nonatomic) dispatch_queue_t delegateQueue;
@property (strong, nonatomic) NSMutableData *outputDataBuffer;
@property (strong, nonatomic) AVCaptureVideoDataOutput *outputDevice;
@property (assign, nonatomic) NSInteger overallBytesWritten;
@property (strong, nonatomic) NSLock *dataBufferLock;
@end

@implementation DDDOutputVideoStream
+ (instancetype)videoStreamWithCaptureOutput:(AVCaptureVideoDataOutput *)output
{
	DDDOutputVideoStream *stream = [DDDOutputVideoStream new];
	stream.outputDevice = output;
	return stream;
}

- (id)init
{
	self = [super init];
	if(self)
	{
		self.overallBytesWritten = 0;
		self.delegateQueue = dispatch_queue_create(DDDBufferDelegateQueue, DISPATCH_QUEUE_SERIAL);
	}
	return self;
}

// NSOutputStream methods
- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len
{
	// Take available bytes in the output data buffer and write it into the buffer
	if ([self.dataBufferLock tryLock])
	{
		[self.dataBufferLock lock];
		NSInteger bytesWritten = 0;
		
		if (len >= self.outputDataBuffer.length)
		{
			// The amount of data we can write is greater than the amount in the buffer
			bytesWritten = self.outputDataBuffer.length;
			memcpy(&buffer, self.outputDataBuffer.bytes, bytesWritten);
		}
		else
		{
			// The amount of data we can write is less than the amount in the buffer
			bytesWritten = len;
			memcpy(&buffer, self.outputDataBuffer.bytes, bytesWritten);
			NSRange zeroRange = {self.overallBytesWritten,bytesWritten};
			[self.outputDataBuffer replaceBytesInRange:zeroRange withBytes:NULL];
		}
			
		self.overallBytesWritten += bytesWritten;
		[self.dataBufferLock unlock];
		return bytesWritten;
	}
	else
		return 0;
}

- (BOOL)hasSpaceAvailable
{
	// Return YES for now...
	return YES;
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
	if ([self.dataBufferLock tryLock])
	{
		[self.dataBufferLock lock];
		[self.outputDataBuffer appendData:[NSData dataFromSampleBuffer:sampleBuffer]];
		[self.dataBufferLock unlock];
	}
}

@end
