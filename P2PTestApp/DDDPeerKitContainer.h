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
@property (nonatomic, assign) DDDSessionMode sessionMode;

- (void)updateDisplayName:(NSString *)displayName;
- (void)connectToPeer:(MCPeerID*)peer callback:(void (^)(BOOL connected, NSError *error))callback;
- (void)disconnectFromPeer:(MCPeerID*)peer;

- (void)sendDataToAllConnectedPeers:(NSData*)data;
- (void)sendStreamToAllConnectedPeers:(NSOutputStream*)outputStream;

- (void)sendData:(NSData*)data toPeer:(MCPeerID*)peer;
- (void)sendStream:(NSOutputStream*)stream toPeer:(MCPeerID*)peer;
@end

@protocol DDDPeerKitBrowsingListener <DDDViewModelListener> @optional
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didUpdateFoundPeerList:(NSArray *)peerList;
@end

@protocol DDDPeerKitDataReceptionListener <DDDViewModelListener> @optional
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didReceiveData:(DDDRemoteDataWrapper *)data;
- (void)peerKitContainer:(DDDPeerKitContainer *)peerkitConainer didRecieveStream:(DDDRemoteStreamWrapper *)stream;
@end

