//
//  DDDInputStreamController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/29/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDInputStreamController.h"

@interface DDDInputStreamController()<NSStreamDelegate>
@property (strong, nonatomic) NSMutableData *inputBuffer;
@property (strong, nonatomic) AVAssetWriterInput *inputAssetWriter;
@property (strong, nonatomic) AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor;
@property (strong, nonatomic) NSInputStream *stream;
@end

@implementation DDDInputStreamController
- (id)init
{
	self = [super init];
	if (self)
	{
		self.inputBuffer = [NSMutableData new];
	}
	return self;
}

- (void)startStreamingWithStream:(NSInputStream *)stream
{
	self.stream = stream;
	[self startStream];
}

- (void)startStream
{
	[self.stream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
	[self.stream open];
}

#pragma mark - NSStreamDelegate methods
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	switch (eventCode) {
		case NSStreamEventOpenCompleted:
			[self handleStreamOpen];
			break;
		case NSStreamEventHasSpaceAvailable:
			[self handleStreamHasBytesAvailable];
			break;
		case NSStreamEventErrorOccurred:
			[self handleStreamErrorOccurred];
			break;
		case NSStreamEventEndEncountered:
			[self handleStreamEnd];
			break;
		default:
			break;
	}
}

- (void)handleStreamOpen
{
	NSLog(@"Stream Opened");
}

- (void)handleStreamHasBytesAvailable
{
	NSInteger bufferLength = 0;
	NSInteger actualBytesRead = 0;
	actualBytesRead = [self.stream read:(uint8_t*)&bufferLength maxLength:sizeof(NSInteger)];
	
	// We read no data from teh stream, return immediately
	if (actualBytesRead == 0)
		return;
	
	// Statically allocate a buffer of size bufferLength
	uint8_t buffer[bufferLength];
	actualBytesRead = [self.stream read:(uint8_t *)&buffer maxLength:bufferLength];
	if (actualBytesRead == 0)
		return;
	[self.inputBuffer appendBytes:&buffer length:bufferLength];
	[self appendDataAsBuffer:&buffer];
	memset(&buffer, 0, bufferLength);
}

- (void)appendDataAsBuffer:(void *)buffer
{
	CVPixelBufferRef buffer = (CVPixelBufferRef)buffer;
	
}

- (void)handleStreamErrorOccurred
{
	NSLog(@"Stream Error Occurred");
}

- (void)handleStreamEnd
{
	NSLog(@"Stream Ended");
	[self.stream close];
	[self.stream removeFromRunLoop:[NSRunLoop currentRunLoop]
					  forMode:NSDefaultRunLoopMode];
	self.stream = nil;
}
@end
