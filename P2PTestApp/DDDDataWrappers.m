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

- (id)initWithSourcePeer:(MCPeerID *)peerID;
@end

@implementation DDDRemoteWrapper
+ (instancetype)wrapperWithSourcePeer:(MCPeerID *)sourcePeer
{
	DDDRemoteWrapper *remoteWrapper = [[DDDRemoteWrapper alloc] initWithSourcePeer:sourcePeer];
	return remoteWrapper;
}

- (id)initWithSourcePeer:(MCPeerID *)peerID
{
	self = [super init];
	if (self)
	{
		self.sourcePeer = peerID;
	}
	return self;
}
@end

@interface DDDRemoteDataWrapper()
@property (strong, nonatomic) NSData *data;
@end

@implementation DDDRemoteDataWrapper
+ (instancetype)wrapperWithData:(NSData *)data withSourcePeer:(MCPeerID *)peerID
{
	DDDRemoteDataWrapper *wrapper = [[DDDRemoteDataWrapper alloc] initWithSourcePeer:peerID];
	wrapper.data = data;
	return wrapper;
}
@end

@interface DDDRemoteInputStreamWrapper()
@property (strong, nonatomic) NSInputStream *inputStream;
@end

@implementation DDDRemoteInputStreamWrapper
+ (instancetype)wrapperWithStream:(NSInputStream *)inputStream withSourcePeer:(MCPeerID *)sourcePeer
{
	DDDRemoteInputStreamWrapper *wrapper = [[DDDRemoteInputStreamWrapper alloc] initWithSourcePeer:sourcePeer];
	wrapper.inputStream = inputStream;
	return wrapper;
}
@end

@interface DDDRemoteOutputStreamWrapper()
@property (strong, nonatomic) NSOutputStream *outputStream;
@end

@implementation DDDRemoteOutputStreamWrapper
+ (instancetype)wrapperWithStream:(NSOutputStream *)outputStream withSourcePeer:(MCPeerID *)sourcePeer
{
	DDDRemoteOutputStreamWrapper *wrapper = [[DDDRemoteOutputStreamWrapper alloc] initWithSourcePeer:sourcePeer];
	wrapper.outputStream = outputStream;
	return wrapper;
}
@end