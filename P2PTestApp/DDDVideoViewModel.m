//
//  DDDVideoModel.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 11/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoViewModel.h"
#import "DDDSessionContainer.h"

@interface DDDVideoViewModel()<DDDSessionBrowsingDelegate, DDDSessionDataReceptionDelegate>
@property (strong, nonatomic) DDDSessionContainer *sessionContainer;
@property (strong, nonatomic) NSArray *peerList;
@property (strong, nonatomic) DDDAVCaptureManager *captureManager;
@property (strong, nonatomic) DDDVideoOutputStreamingController *outputStreamingController;
@end

@implementation DDDVideoViewModel
- (id)init
{
	self = [super init];
	if (self)
	{
		self.sessionContainer = [DDDSessionContainer sessionContainerWithDisplayName:@"Test id"];
		self.sessionContainer.browsingDelegate = self;
		self.sessionContainer.dataDalegate = self;
		self.captureManager = [DDDAVCaptureManager new];
		self.outputStreamingController = [DDDVideoOutputStreamingController controllerWithCaptureSession:self.captureManager.captureSession];
		[self callDelegateListenersWithSelector:@selector(viewModel:didInitializeCaptureManager:) withObject:self.captureManager];
	}
	return self;
}

#pragma mark - DDDSessionBrowsingDelegate
- (void)sessionContainer:(DDDSessionContainer*)session foundPeerListUpdated:(NSArray*)peerList
{
	self.peerList = peerList;
	[self callDelegateListenersWithSelector:@selector(viewModel:didUpdateFoundPeers:) withObject:peerList];
}

#pragma mark - DDDSessionDataReceptionDelegate
- (void)sessionContainer:(DDDSessionContainer*)session recievedData:(NSData*)data fromPeer:(MCPeerID*)peerID
{
	[self callDelegateListenersWithSelector:@selector(viewModel:didRecieveData:) withObject:data];
}

- (void)sessionContainer:(DDDSessionContainer*)session recievedStream:(NSInputStream*)inputStream fromPeer:(MCPeerID*)peerID
{
	[self callDelegateListenersWithSelector:@selector(viewModel:didUpdateStream:) withObject:inputStream];
}

- (void)connectToPeer:(MCPeerID*)peer
{
	[self.sessionContainer connectToPeer:peer callback:^(BOOL connected, NSError *error) {
		if (peer && !error)
		{
			[self callDelegateListenersWithSelector:@selector(viewModel:didConnectToPeer:) withObject:peer];
		}
	}];
}

- (void)disconnectFromPeer:(MCPeerID*)peer
{
	[self.sessionContainer disconnectFromPeer:peer];
	[self callDelegateListenersWithSelector:@selector(viewModel:didDisconnectFromPeer:) withObject:peer];
}

- (void)sendDataToAllConnectedPeers:(NSData*)data
{
	[self.sessionContainer sendDataToAllConnectedPeers:data];
}

- (void)sendStreamToAllConnectedPeers:(NSOutputStream*)outputStream
{
	[self.sessionContainer sendStreamToAllConnectedPeers:outputStream];
}

- (void)sendData:(NSData*)data toPeer:(MCPeerID*)peer
{
	[self.sessionContainer sendData:data toPeer:peer];
}

- (void)sendStream:(NSOutputStream*)stream toPeer:(MCPeerID*)peer
{
	[self.sessionContainer sendStream:stream toPeer:peer];
}

- (void)setMode:(DDDSessionMode)mode
{
	[self.sessionContainer setSessionMode:mode];
}

// AVCapture
- (void)startVideo
{
	[self.captureManager startVideo];
	NSOutputStream *stream = [self.outputStreamingController startStreamWithDeviceID:[[MCPeerID alloc] initWithDisplayName:@"TEST"]];
}

- (void)stopVideo
{
	[self.captureManager stopVideo];
}

- (void)displayCamera:(AVCaptureDevicePosition)position
{
	[self.captureManager updateCurrentCameraShown:position];
}
@end
