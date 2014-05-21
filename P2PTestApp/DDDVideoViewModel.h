//
//  DDDVideoModel.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 11/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"
#import "DDDSessionContainer.h"
#import "DDDVideoOutputStreamingController.h"
#import "DDDAVCaptureManager.h"

@interface DDDVideoViewModel : DDDViewModel

@property (strong, nonatomic, readonly) NSArray *peerList;
@property (strong, nonatomic, readonly) DDDVideoOutputStreamingController *streamingController;
@property (strong, nonatomic, readonly) DDDAVCaptureManager *captureManager;

- (void)setMode:(DDDSessionMode)mode;

- (void)connectToPeer:(MCPeerID*)peer;
- (void)disconnectFromPeer:(MCPeerID*)peer;

- (void)sendDataToAllConnectedPeers:(NSData*)data;
- (void)sendStreamToAllConnectedPeers:(NSOutputStream*)outputStream;

- (void)sendData:(NSData*)data toPeer:(MCPeerID*)peer;
- (void)sendStream:(NSOutputStream*)stream toPeer:(MCPeerID*)peer;

// AV Capture Related
- (void)startVideo;
- (void)stopVideo;
- (void)displayCamera:(AVCaptureDevicePosition)position;
@end

@protocol  DDDVideoViewModelListener <DDDViewModelListener> @optional
- (void)viewModel:(DDDVideoViewModel *)videoModel didConnectToPeer:(MCPeerID *)peer;
- (void)viewModel:(DDDVideoViewModel *)videoModel didDisconnectFromPeer:(MCPeerID *)peer;
- (void)viewModel:(DDDVideoViewModel *)videoModel didUpdateFoundPeers:(NSArray *)foundArray;
- (void)viewModel:(DDDVideoViewModel *)videoModel didUpdateStream:(NSOutputStream *)stream;
- (void)viewModel:(DDDVideoViewModel *)videoModel didRecieveData:(NSData *)data;
- (void)viewModel:(DDDVideoViewModel *)videoModel didInitializeCaptureManager:(DDDAVCaptureManager *)captureManager;
@end
