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
@end

@implementation DDDOutputVideoStream

- (id)init
{
	self = [super init];
	if(self)
	{
		self.overallBytesWritten = 0;
		self.streamIdentifier = [NSUUID UUID];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    DDDOutputVideoStream *copy = [super copy];
	copy.overallBytesWritten = self.overallBytesWritten;
	copy.streamIdentifier = self.streamIdentifier;
	copy.streamWrapper = self.streamWrapper;
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
	if(self.datasource)
	{
		NSData *data = [self.datasource dataToWriteToStreamID:self.streamIdentifier];
		if(data)
		{	
			[self.stream write:data.bytes maxLength:data.length];
		}
	}
}

- (void)handleStreamError
{
	NSLog(@"Stream Error: %@", self.stream);
}

- (void)handleStreamEnd
{
	NSLog(@"Stream END: %@", self.stream);
}

@end
