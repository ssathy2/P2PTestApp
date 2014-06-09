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

- (NSData *)networkDataFromData:(NSData *)data
{
	NSInteger dataLength = data.length;
	NSMutableData *returnData = [NSMutableData data];
	[returnData appendBytes:&dataLength length:sizeof(NSInteger)];
	[returnData appendBytes:data.bytes length:dataLength];
	return returnData;
}
- (NSData *)dataFromImageBuffer:(CVImageBufferRef)imageBuffer withBytesPerRow:(size_t)bytesPerRow withHeight:(NSInteger)height
{
	NSMutableData *data = [NSMutableData new];
	if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
	{
		UInt8 *rawBuffer = (UInt8 *)CVPixelBufferGetBaseAddress(imageBuffer);
		NSInteger dataLength = bytesPerRow*height;
		[data appendBytes:&dataLength length:sizeof(NSInteger)];
		[data appendBytes:rawBuffer length:dataLength];
		CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
	}
	return data;
}

- (void)setupBufferPoolWithWidth:(size_t)width withHeight:(size_t)height
{
	NSDictionary *pixelBufferAttrs = @{
									  (NSString *)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCMPixelFormat_32ARGB],
									  (NSString *)kCVPixelBufferWidthKey : [NSNumber numberWithInteger:width],
									  (NSString *)kCVPixelBufferHeightKey : [NSNumber numberWithInteger:height]
									  };

	CVPixelBufferPoolCreate(kCFAllocatorDefault,
							nil,
							(__bridge CFDictionaryRef)(pixelBufferAttrs),
							&(_bufferPool));
}
@end
