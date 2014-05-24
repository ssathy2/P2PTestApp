//
//  DDDOutputVideoStream.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDDOutputVideoStream;

@protocol DDDOutputVideoStreamDataSource <NSObject>
- (NSData *)dataToWriteToStreamID:(NSUUID *)streamID;
@end

@interface DDDOutputVideoStream : NSObject<NSCopying>
@property (strong, nonatomic, readonly) NSUUID *streamIdentifier;
@property (strong, nonatomic, readonly) NSOutputStream *stream;
@property (weak, nonatomic)	id<DDDOutputVideoStreamDataSource> datasource;
- (void)startStream;
- (void)stopStream;
@end
