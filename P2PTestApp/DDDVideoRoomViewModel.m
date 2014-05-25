//
//  DDDVideoRoomViewModel.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoRoomViewModel.h"
#import "DDDPeerKitContainer.h"

@implementation DDDVideoRoomViewModel
- (void)didRegisterListener:(id<DDDViewModelListener>)listener
{
	[super didRegisterListener:listener];
}

- (void)didRegisterFirstListener:(id<DDDViewModelListener>)listener
{
	[super didRegisterFirstListener:listener];
	[[DDDPeerKitContainer sharedInstance] registerListener:self];
}

- (void)connectToPeer:(MCPeerID *)peerID
{
	[[DDDPeerKitContainer sharedInstance] connectToPeer:peerID];
}

- (NSArray *)foundPeers
{
	return [DDDPeerKitContainer sharedInstance].foundPeers;
}

#pragma mark - DDDPeerKitBrowsingListener
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didUpdateFoundPeerList:(NSArray *)peerList
{
	[self callDelegateListenersWithSelector:@selector(viewModel:didFoundUpdatePeerList:) withObject:peerList];
}

#pragma mark - DDDPeerKitConnectionListener
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didConnectToPeer:(MCPeerID *)peer
{
	[self callDelegateListenersWithSelector:@selector(viewModel:didConnectToPeer:) withObject:peer];
}

- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didStartConnectingToPeer:(MCPeerID *)peer
{
	[self callDelegateListenersWithSelector:@selector(viewModel:didStartConnectingToPeer:) withObject:peer];
}

@end
