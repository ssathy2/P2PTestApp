//
//  DDDVideoModel.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 11/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoViewModel.h"
#import "DDDPeerKitContainer.h"

@interface DDDVideoViewModel()
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
		self.captureManager = [DDDAVCaptureManager new];
		self.outputStreamingController = [DDDVideoOutputStreamingController controllerWithCaptureSession:self.captureManager.captureSession];
		[self callDelegateListenersWithSelector:@selector(viewModel:didInitializeCaptureManager:) withObject:self.captureManager];
	}
	return self;
}

// AVCapture
- (void)startVideo
{
	[self.outputStreamingController startStreamingToPeers:@[[[MCPeerID alloc] initWithDisplayName:@"BAD GUY"]]];
	[self.captureManager startVideo];
}

- (void)stopVideo
{
	[self.outputStreamingController stopStreamingToPeers:@[[[MCPeerID alloc] initWithDisplayName:@"BAD GUY"]]];
	[self.captureManager stopVideo];
}

- (void)displayCamera:(AVCaptureDevicePosition)position
{
	[self.captureManager updateCurrentCameraShown:position];
}
@end
