//
//  DDDVideoModel.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 11/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"
#import "DDDSessionContainer.h"

@interface DDDVideoViewModel : DDDViewModel

@property (weak, nonatomic, readonly) NSArray *peerList;

- (void)setMode:(DDDSessionMode)mode;

- (void)connectToPeer:(MCPeerID*)peer;
- (void)disconnectFromPeer:(MCPeerID*)peer;

- (void)sendDataToAllConnectedPeers:(NSData*)data;
- (void)sendStreamToAllConnectedPeers:(NSOutputStream*)outputStream;

- (void)sendData:(NSData*)data toPeer:(MCPeerID*)peer;
- (void)sendStream:(NSOutputStream*)stream toPeer:(MCPeerID*)peer;
@end

@protocol  DDDVideoViewModelListener <DDDViewModelListener> @optional
- (void)viewModel:(DDDVideoViewModel *)videoModel didConnectToPeer:(MCPeerID *)peer;
- (void)viewModel:(DDDVideoViewModel *)videoModel didDisconnectFromPeer:(MCPeerID *)peer;
- (void)viewModel:(DDDVideoViewModel *)videoModel didUpdateFoundPeers:(NSArray *)foundArray;
- (void)viewModel:(DDDVideoViewModel *)videoModel didUpdateStream:(NSOutputStream *)stream;
- (void)viewModel:(DDDVideoViewModel *)videoModel didRecieveData:(NSData *)data;
@end
