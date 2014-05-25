//
//  DDDStreamingContainer.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDDViewModel.h"
#import "DDDDataWrappers.h"

typedef NS_ENUM(NSInteger, DDDSessionMode)
{
	DDDSessionModeBroadcasting,
	DDDSessionModeBrowsing
};
@interface DDDPeerKitContainer : DDDViewModel
@property (readonly, nonatomic) MCPeerID *appPeerID;
@property (readonly, nonatomic) NSMutableArray *foundPeers;
@property (readonly, nonatomic) NSMutableArray *connectedPeers;
@property (nonatomic, assign) DDDSessionMode sessionMode;

+ (instancetype)sharedInstance;
- (void)updateDisplayName:(NSString *)displayName;
- (void)connectToPeer:(MCPeerID*)peer;
- (void)disconnect;

- (void)sendDataToAllConnectedPeers:(NSData*)data;
- (void)startStreamWithAllPeers;

- (void)sendData:(NSData*)data toPeer:(MCPeerID*)peer;
@end

@protocol DDDPeerKitBrowsingListener <DDDViewModelListener> @optional
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didUpdateFoundPeerList:(NSArray *)peerList;
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didUpdateConnectedPeerList:(NSArray *)connectedPeerList;
@end

@protocol DDDPeerKitConnectionListener <DDDViewModelListener> @optional
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didConnectToPeer:(MCPeerID *)peer;
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didDisconnectFromPeer:(MCPeerID *)peer;
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didStartConnectingToPeer:(MCPeerID *)peer;
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didOpenStream:(DDDRemoteOutputStreamWrapper *)stream;
@end

@protocol DDDPeerKitDataReceptionListener <DDDViewModelListener> @optional
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didReceiveData:(DDDRemoteDataWrapper *)data;
- (void)peerKitContainer:(DDDPeerKitContainer *)peerkitConainer didRecieveStream:(DDDRemoteInputStreamWrapper *)stream;
@end

