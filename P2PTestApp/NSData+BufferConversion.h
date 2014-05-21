//
//  NSData+BufferConversion.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (BufferConversion)
@property (nonatomic, assign) CVPixelBufferPoolRef bufferPool;

- (CMSampleBufferRef)sampleBufferFromData;
+ (NSData *)dataFromSampleBuffer:(CMSampleBufferRef)buffer;
@end
