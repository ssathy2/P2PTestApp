//
//  DDDVideoModel.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 11/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoViewModel.h"
#import "DDDPeerKitContainer.h"

@interface DDDVideoViewModel()<DDDViewModelListener>
@property (strong, nonatomic) DDDAVCaptureManager *captureManager;
@property (strong, nonatomic) DDDVideoOutputStreamingController *outputStreamingController;
@end

@implementation DDDVideoViewModel
- (id)init
{
	self = [super init];
	if (self)
	{
		self.captureManager = [DDDAVCaptureManager new];
		self.outputStreamingController = [DDDVideoOutputStreamingController controllerWithCaptureSession:self.captureManager.captureSession];
	}
	return self;
}

- (void)didRegisterFirstListener:(id<DDDViewModelListener>)listener
{
	[super didRegisterFirstListener:listener];
	[[DDDPeerKitContainer sharedInstance] registerListener:self];
}

- (void)didRegisterListener:(id<DDDViewModelListener>)listener
{
	[super didRegisterListener:listener];
	[self callDelegateListenersWithSelector:@selector(viewModel:didInitializeCaptureManager:) withObject:self.captureManager];
}

// AVCapture
- (void)startVideo
{
	//TESTING
	[self.outputStreamingController startStreamingToPeers];
	[self.captureManager startVideo];
}

- (void)stopVideo
{
	[self.captureManager stopVideo];
}

- (void)displayCamera:(AVCaptureDevicePosition)position
{
	[self.captureManager updateCurrentCameraShown:position];
}

- (NSArray *)connectedPeers
{
	return [DDDPeerKitContainer sharedInstance].connectedPeers;
}

#pragma mark - DDDPeerKitContainer
- (void)peerkitContainer:(DDDPeerKitContainer *)peerkitContainer didUpdateConnectedPeerList:(NSArray *)connectedPeerList
{
	[self callDelegateListenersWithSelector:@selector(viewModel:didUpdateConnectedPeers:) withObject:connectedPeerList];
}

@end
