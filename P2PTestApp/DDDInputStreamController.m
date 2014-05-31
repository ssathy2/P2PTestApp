//
//  DDDInputStreamController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/29/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDInputStreamController.h"
#import "DDDStreamFileManager.h"

@interface DDDInputStreamController()<NSStreamDelegate>
@property (strong, nonatomic) AVAssetWriter *assetWriter;
@property (strong, nonatomic) AVURLAsset *urlAsset;
@property (strong, nonatomic) AVAssetWriterInput *assetWriterInput;
@property (strong, nonatomic) AVPlayerItem *streamPlayerItem;

@property (strong, nonatomic) NSInputStream *stream;
@property (strong, nonatomic) NSMutableData *inputBuffer;
@end

@implementation DDDInputStreamController
- (id)init
{
	self = [super init];
	if (self)
	{
		self.inputBuffer = [NSMutableData new];
		[self initAssetWritingFlow];
	}
	return self;
}

- (void)startStreamingWithStream:(NSInputStream *)stream
{
	self.stream = stream;
	[self setupAssetWriterInput];
	[self startStream];
}

- (void)setupAssetWriterInput
{
	self.assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:nil];
	if ([self.assetWriter canAddInput:self.assetWriterInput])
		[self.assetWriter addInput:self.assetWriterInput];
}

// Helpers
- (void)initAssetWritingFlow
{
	NSURL *streamFile = [[DDDStreamFileManager sharedInstance] startStreamToFile];
	NSError *error;
	self.assetWriter = [AVAssetWriter assetWriterWithURL:streamFile fileType:AVFileTypeMPEG4 error:&error];
	[self.assetWriter setShouldOptimizeForNetworkUse:YES];
	if (error)
		NSLog(@"ERROR in setting up asset writer: %@", error);
	self.urlAsset = [AVURLAsset URLAssetWithURL:streamFile options:nil];
	self.streamPlayerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
}

- (void)startStream
{
	[self.stream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
	self.stream.delegate = self;
	[self.stream open];
}

#pragma mark - NSStreamDelegate methods
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	switch (eventCode)
	{
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
	[self writeBufferToAssetWriter:&buffer];
	[self.inputBuffer appendBytes:&buffer length:bufferLength];
	memset(&buffer, 0, bufferLength);
}

- (void)writeBufferToAssetWriter:(void *)buffer
{
	CMSampleBufferRef sampleBuffer = (CMSampleBufferRef)buffer;
	// There's only one frame in this sample buffer
	if (self.inputBuffer.length == 0)
		// WE haven't read any bytes into the buffer so setup the av player here...
		[self setupAssetWriterWithSampleBuffer:sampleBuffer];
	
	if (self.assetWriterInput.isReadyForMoreMediaData)
		[self.assetWriterInput appendSampleBuffer:sampleBuffer];
}

- (void)setupAssetWriterWithSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
	[self.assetWriter startWriting];
	[self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
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
	
	[self disposeAssetWriter];
}

- (void)disposeAssetWriter
{
	__weak DDDInputStreamController *weakSelf = self;
	[weakSelf.assetWriter finishWritingWithCompletionHandler:^{
		weakSelf.assetWriterInput = nil;
		[[DDDStreamFileManager sharedInstance] stopStreamToFile];
	}];
}
@end
