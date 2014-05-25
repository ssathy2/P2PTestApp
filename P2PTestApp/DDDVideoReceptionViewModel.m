//
//  DDDVideoReceptionViewModel.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoReceptionViewModel.h"
#import "DDDPeerKitContainer.h"

@implementation DDDVideoReceptionViewModel
- (void)didRegisterListener:(id<DDDViewModelListener>)listener
{
	[super didRegisterListener:listener];
}

- (void)didRegisterFirstListener:(id<DDDViewModelListener>)listener
{
	[super didRegisterFirstListener:listener];
	[[DDDPeerKitContainer sharedInstance] registerListener:self];
}

#pragma mark = DDDPeerKitDataReceptionListener
- (void)peerKitContainer:(DDDPeerKitContainer *)peerkitConainer didRecieveStream:(DDDRemoteInputStreamWrapper *)stream
{
	self.inputStream = stream.inputStream;
	[self callDelegateListenersWithSelector:@selector(viewModel:didUpdateInputStream:) withObject:self.inputStream];
}

@end
