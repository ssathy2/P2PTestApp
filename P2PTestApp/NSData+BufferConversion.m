//
//  NSData+BufferConversion.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "NSData+BufferConversion.h"
#import <objc/runtime.h>

#define DDDBufferPoolKey "DDDBufferPoolKey"

@implementation NSData (BufferConversion)
@dynamic bufferPool;

+ (NSData *)dataFromSampleBuffer:(CMSampleBufferRef)buffer
{
	CVPixelBufferPoolRef pool = [[NSData class] bufferPool];
	size_t bytesPerRow;
	CGSize imageSize;
	
	CVImageBufferRef imageBuffer;
	if (!pool)
	{
		imageBuffer = CMSampleBufferGetImageBuffer(buffer);
		imageSize = CVImageBufferGetDisplaySize(imageBuffer);
		[[NSData class] setBufferPool:[NSData bufferPoolWithWidth:imageSize.width withHeight:imageSize.height]];
	}
	else
	{
		CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault,
										   pool,
										   &imageBuffer);
		imageSize = CVImageBufferGetDisplaySize(imageBuffer);
	}
	
	bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
	return [NSData dateFromImageBuffer:imageBuffer withBytesPerRow:bytesPerRow withHeight:imageSize.height];
	
}

// TODO: COnvert nsdata fom CMSampleBuffer
- (CMSampleBufferRef)sampleBufferFromData
{
	return NULL;
}

+ (NSData *)dateFromImageBuffer:(CVImageBufferRef)imageBuffer withBytesPerRow:(size_t)bytesPerRow withHeight:(NSInteger)height
{
	CVPixelBufferLockBaseAddress(imageBuffer, 0);
	void *rawBuffer = CVPixelBufferGetBaseAddress(imageBuffer);
	NSData *data = [NSData dataWithBytes:rawBuffer length:bytesPerRow*height];
	CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
	return data;
}

- (void)setBufferPool:(CVPixelBufferPoolRef)bufferPool
{
	objc_setAssociatedObject(self,
							 DDDBufferPoolKey,
							 (__bridge id)(bufferPool),
							 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CVPixelBufferPoolRef)bufferPool
{
	return (__bridge CVPixelBufferPoolRef)(objc_getAssociatedObject(self,
							 DDDBufferPoolKey));
}

+ (CVPixelBufferPoolRef)bufferPoolWithWidth:(NSInteger)width withHeight:(NSInteger)height
{
	NSDictionary *bufferPoolAttrs = @{
									  (NSString *)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCMPixelFormat_32ARGB],
									  (NSString *)kCVPixelBufferWidthKey : [NSNumber numberWithInteger:width],
									  (NSString *)kCVPixelBufferHeightKey : [NSNumber numberWithInteger:height]
									  };
	CVPixelBufferPoolRef pool;
	CVPixelBufferPoolCreate(kCFAllocatorDefault,
							NULL,
							(__bridge CFDictionaryRef)(bufferPoolAttrs),
							&pool);
	return pool;
}
@end
