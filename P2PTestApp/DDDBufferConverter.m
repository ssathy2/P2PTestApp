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
	return [self dataFromImageBuffer:imageBuffer withBytesPerRow:bytesPerRow withHeight:imageSize.height];
}

- (NSData *)dataFromImageBuffer:(CVImageBufferRef)imageBuffer withBytesPerRow:(size_t)bytesPerRow withHeight:(NSInteger)height
{
	CVPixelBufferLockBaseAddress(imageBuffer, 0);
	void *rawBuffer = CVPixelBufferGetBaseAddress(imageBuffer);
	NSData *data = [NSData dataWithBytes:rawBuffer length:bytesPerRow*height];
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
