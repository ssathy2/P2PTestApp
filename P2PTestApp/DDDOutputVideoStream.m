//
//  DDDOutputVideoStream.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDOutputVideoStream.h"

@interface DDDOutputVideoStream()<NSStreamDelegate>
@property (assign, nonatomic) NSInteger overallBytesWritten;
@property (strong, nonatomic) NSUUID *streamIdentifier;
@property (strong, nonatomic) DDDRemoteOutputStreamWrapper *streamWrapper;

@property (strong, nonatomic) NSOperationQueue *streamOperationQueue;

@property (strong, nonatomic) NSMutableData *streamDataBuffer;
@end


@implementation DDDOutputVideoStream

- (id)init
{
	self = [super init];
	if(self)
	{
		self.overallBytesWritten = 0;
		self.streamIdentifier = [NSUUID UUID];
		self.streamDataBuffer = [NSMutableData new];
		self.streamOperationQueue = [NSOperationQueue new];
//		self.streamOperationQueue.maxConcurrentOperationCount = 1;
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    DDDOutputVideoStream *copy = [super copy];
	copy.overallBytesWritten = self.overallBytesWritten;
	copy.streamIdentifier = self.streamIdentifier;
	copy.streamWrapper = self.streamWrapper;
	copy.streamDataBuffer = self.streamDataBuffer;
    return copy;
}

+ (instancetype)outputVideoStreamWithOutputStreamWrapper:(DDDRemoteOutputStreamWrapper *)wrapper
{
	DDDOutputVideoStream *stream = [DDDOutputVideoStream new];
	stream.streamWrapper = wrapper;
	return stream;
}

- (NSOutputStream *)stream
{
	return self.streamWrapper.outputStream;
}

- (NSStreamStatus)streamStatus
{
	return self.stream.streamStatus;
}

- (void)startStream
{
	if (self.stream.streamStatus == NSStreamStatusNotOpen)
	{
		[self.stream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
		self.stream.delegate = self;
		[self.stream open];
	}
}

- (void)stopStream
{
	if (self.stream.streamStatus == NSStreamStatusOpen)
	{
		[self.stream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
		[self.stream close];
	}
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	switch (eventCode) {
		case NSStreamEventNone:
			break;
		case NSStreamEventOpenCompleted:
			[self handleStreamOpenComplete];
			break;
		case NSStreamEventHasSpaceAvailable:
			[self handleStreamHasSpace];
			break;
		case NSStreamEventErrorOccurred:
			[self handleStreamError];
			break;
		case NSStreamEventEndEncountered:
			[self handleStreamEnd];
			break;
			
		default:
			break;
	}
}

- (void)handleStreamOpenComplete
{
	NSLog(@"Stream Open Complete: %@", self.stream);
}

- (void)handleStreamHasSpace
{
	NSLog(@"Stream Has Space: %@", self.stream);
	__weak DDDOutputVideoStream *weakSelf = self;
	[self.streamOperationQueue addOperationWithBlock:^{
		[weakSelf flushBufferToStream];
	}];
}

- (void)handleStreamError
{
	NSLog(@"Stream Error: %@", self.stream);
}

- (void)handleStreamEnd
{
	NSLog(@"Stream END: %@", self.stream);
}

- (void)writeDataTostream:(NSData *)data
{
	__weak DDDOutputVideoStream *weakSelf = self;
	[self.streamOperationQueue addOperationWithBlock:^{
		[weakSelf.streamDataBuffer appendData:data];
		[weakSelf flushBufferToStream];
	}];
}

// Non thread-safe call to flush out the existing buffer to the output stream
- (NSInteger)flushBufferToStream
{
	if(self.streamDataBuffer.length == 0)
		return 0;
	NSInteger bytesWritten = 0;
	if (self.stream.hasSpaceAvailable)
	{
		self.overallBytesWritten += bytesWritten;
		[self.stream write:self.streamDataBuffer.bytes maxLength:self.streamDataBuffer.length];
		[self.streamDataBuffer setLength:0];
		NSLog(@"Wrote %li bytes to stream", bytesWritten);
	}
	return bytesWritten;
}

@end
