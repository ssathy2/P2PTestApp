//
//  DDDBufferConverter.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDBufferConverter.h"

@interface DDDBufferConverter()
@property (nonatomic, assign) CVPixelBufferPoolRef bufferPool;
@end

@implementation DDDBufferConverter
// The size ((in bytes)) of the buffer is indicated in the first sizeof(NSInteger) bits of the stream
// The client should read the first sizeof(NSInteger) bits of the data to figure out how many bytes to read from the stream to constitute a full buffer
- (NSData *)dataFromSampleBuffer:(CMSampleBufferRef)buffer
{
	size_t bytesPerRow;
	CVImageBufferRef imageBuffer;
	CGSize imageSize;
	if (!self.bufferPool)
	{
		imageBuffer = CMSampleBufferGetImageBuffer(buffer);
		imageSize = CVImageBufferGetDisplaySize(imageBuffer);
		[self setupBufferPoolWithWidth:imageSize.width withHeight:imageSize.height];
	}
	CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault,
									   self.bufferPool,
									   &imageBuffer);
	bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
	imageSize = CVImageBufferGetDisplaySize(imageBuffer);
	return [self dataFromImageBuffer:imageBuffer withBytesPerRow:bytesPerRow withHeight:imageSize.height];
}

- (NSData *)dataFromImageBuffer:(CVImageBufferRef)imageBuffer withBytesPerRow:(size_t)bytesPerRow withHeight:(NSInteger)height
{
	CVPixelBufferLockBaseAddress(imageBuffer, 0);
	void *rawBuffer = CVPixelBufferGetBaseAddress(imageBuffer);
	NSMutableData *data = [NSMutableData new];
	NSInteger dataLength = bytesPerRow*height;
	[data appendBytes:&dataLength length:sizeof(dataLength)];
	[data appendBytes:rawBuffer length:dataLength];
	CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
	return data;
}

- (void)setupBufferPoolWithWidth:(size_t)width withHeight:(size_t)height
{
	NSDictionary *bufferPoolAttrs = @{
									  (NSString *)kCVPixelBufferPoolMaximumBufferAgeKey : @0
									  };
	
	NSDictionary *pixelBufferAttrs = @{
									  (NSString *)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCMPixelFormat_32ARGB],
									  (NSString *)kCVPixelBufferWidthKey : [NSNumber numberWithInteger:width],
									  (NSString *)kCVPixelBufferHeightKey : [NSNumber numberWithInteger:height]
									  };

	CVPixelBufferPoolCreate(kCFAllocatorDefault,
							(__bridge CFDictionaryRef)(bufferPoolAttrs),
							(__bridge CFDictionaryRef)(pixelBufferAttrs),
							&_bufferPool);
}
@end
