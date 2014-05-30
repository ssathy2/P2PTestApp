//
//  DDDOutputVideoStream.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDDDataWrappers.h"

@class DDDOutputVideoStream;

@interface DDDOutputVideoStream : NSObject<NSCopying>
@property (strong, nonatomic, readonly) NSUUID *streamIdentifier;

// Convienence Properties
@property (strong, nonatomic, readonly) NSOutputStream *stream;
@property (assign, nonatomic, readonly) NSStreamStatus streamStatus;

+ (instancetype)outputVideoStreamWithOutputStreamWrapper:(DDDRemoteOutputStreamWrapper *)wrapper;
- (NSInteger)writeDataTostream:(NSData *)data;
- (void)startStream;
- (void)stopStream;
@end
