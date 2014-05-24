//
//  DDDDataWrappers.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDDataWrappers.h"

@interface DDDRemoteWrapper()
@property (strong, nonatomic) MCPeerID *sourcePeer;
@end

@implementation DDDRemoteWrapper
+ (instancetype)wrapperWithSourcePeer:(MCPeerID *)sourcePeer
{
	DDDRemoteWrapper *remoteWrapper = [DDDRemoteWrapper new];
	remoteWrapper.sourcePeer = sourcePeer;
	return remoteWrapper;
}
@end

@interface DDDRemoteDataWrapper()
@property (strong, nonatomic) NSData *data;
@end

@implementation DDDRemoteDataWrapper
+ (instancetype)wrapperWithData:(NSData *)data withSourcePeer:(MCPeerID *)peerID
{
	DDDRemoteDataWrapper *wrapper = [DDDRemoteDataWrapper wrapperWithSourcePeer:peerID];
	wrapper.data = data;
	return wrapper;
}
@end

@interface DDDRemoteStreamWrapper()
@property (strong, nonatomic) NSInputStream *inputStream;
@end

@implementation DDDRemoteStreamWrapper
+ (instancetype)wrapperWithStream:(NSInputStream *)inputStream withSourcePeer:(MCPeerID *)sourcePeer
{
	DDDRemoteStreamWrapper *wrapper = [DDDRemoteStreamWrapper wrapperWithSourcePeer:sourcePeer];
	wrapper.inputStream = inputStream;
	return wrapper;
}
@end