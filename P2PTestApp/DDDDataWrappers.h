//
//  DDDDataWrappers.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDRemoteWrapper : NSObject
+ (instancetype)wrapperWithSourcePeer:(MCPeerID *)sourcePeer;
@property (strong, nonatomic, readonly) MCPeerID *sourcePeer;
@end

@interface DDDRemoteDataWrapper : DDDRemoteWrapper
+ (instancetype)wrapperWithData:(NSData *)data withSourcePeer:(MCPeerID *)peerID;
@property (strong, nonatomic, readonly) NSData *data;
@end

@interface DDDRemoteStreamWrapper : DDDRemoteWrapper
+ (instancetype)wrapperWithStream:(NSInputStream *)inputStream withSourcePeer:(MCPeerID *)sourcePeer;
@property (strong, nonatomic, readonly) NSInputStream *inputStream;
@end

