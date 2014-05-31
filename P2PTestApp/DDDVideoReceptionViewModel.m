//
//  DDDVideoReceptionViewModel.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoReceptionViewModel.h"
#import "DDDPeerKitContainer.h"

@interface DDDVideoReceptionViewModel()<DDDInputStreamControllerDelegate, DDDPeerKitDataReceptionListener>
@property (strong, nonatomic) NSInputStream *inputStream;
@property (strong, nonatomic) DDDInputStreamController *inputStreamController;
@end

@implementation DDDVideoReceptionViewModel

- (id)init
{
	self = [super init];
	if (self)
	{
		self.inputStreamController = [DDDInputStreamController new];
		self.inputStreamController.delegate = self;
		[[DDDPeerKitContainer sharedInstance] registerListener:self];
	}
	return self;
}

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
	[self.inputStreamController startStreamingWithStream:self.inputStream];	
	[self callDelegateListenersWithSelector:@selector(viewModel:didUpdateInputStream:) withObject:self.inputStream];
}

#pragma mark - DDDInputStreamControllerDelegate
- (void)streamController:(DDDInputStreamController *)streamController streamStatusUpdated:(NSStreamStatus)status
{
	
}

- (void)streamController:(DDDInputStreamController *)streamController startedWritingToAssetWriter:(AVAssetWriterInput *)inputAssetWriter
{
	
}
@end
