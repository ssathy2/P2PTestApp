//
//  DDDVideoStreamManager.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDDSessionContainer;

@protocol DDDSessionBrowsingDelegate <NSObject>
- (void)sessionContainer:(DDDSessionContainer*)session foundPeerListUpdated:(NSArray*)peerList;
@end

@protocol DDDSessionDataReceptionDelegate <NSObject>
- (void)sessionContainer:(DDDSessionContainer*)session recievedData:(NSData*)data fromPeer:(MCPeerID*)peerID;
- (void)sessionContainer:(DDDSessionContainer*)session recievedStream:(NSInputStream*)inputStream fromPeer:(MCPeerID*)peerID;
@end

@interface DDDSessionContainer : NSObject<MCSessionDelegate>

@property (readonly, nonatomic) MCPeerID *appPeerID;
@property (readonly, nonatomic) NSMutableArray *foundPeers;
@property (nonatomic, weak) id<DDDSessionBrowsingDelegate> browsingDelegate;
@property (nonatomic, weak) id<DDDSessionDataReceptionDelegate> dataDalegate;

- (instancetype)initWithDisplayID:(NSString*)displayID;

- (void)startBrowsingForPeers;
- (void)stopBrowsingForPeers;

- (void)startAdvertisingToPeers;
- (void)stopAdvertisingToPeers;

- (void)connectToPeer:(MCPeerID*)peer callback:(void (^)(BOOL connected, NSError *error))callback;
- (void)disconnectFromPeer:(MCPeerID*)peer;

- (void)sendDataToAllConnectedPeers:(NSData*)data;
- (void)sendStreamToAllConnectedPeers:(NSOutputStream*)outputStream;

- (void)sendData:(NSData*)data toPeer:(MCPeerID*)peer;
- (void)sendStream:(NSOutputStream*)stream toPeer:(MCPeerID*)peer;
@end
