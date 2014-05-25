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

@protocol DDDOutputVideoStreamDataSource <NSObject>
- (NSData *)dataToWriteToStreamID:(NSUUID *)streamID;
@end

@interface DDDOutputVideoStream : NSObject<NSCopying>
// Convienence Property
@property (strong, nonatomic, readonly) NSOutputStream *stream;
@property (strong, nonatomic, readonly) NSUUID *streamIdentifier;
@property (weak, nonatomic)	id<DDDOutputVideoStreamDataSource> datasource;

+ (instancetype)outputVideoStreamWithOutputStreamWrapper:(DDDRemoteOutputStreamWrapper *)wrapper;
- (void)startStream;
- (void)stopStream;
@end
