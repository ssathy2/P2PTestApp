//
//  DDDBufferConverter.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDBufferConverter : NSObject
- (NSData *)dataFromSampleBuffer:(CMSampleBufferRef)buffer;
// Appends the size of the data to the beginning of the data buffer
- (NSData *)networkDataFromData:(NSData *)data;
@end
