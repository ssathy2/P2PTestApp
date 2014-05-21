//
//  DDDAVCaptureManager.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 21/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDAVCaptureManager.h"

@interface DDDAVCaptureManager()
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *captureInput;
@property (nonatomic, assign) AVCaptureDevicePosition currentCameraShown;
@end

@implementation DDDAVCaptureManager

- (id)init
{
	self = [super init];
	if (self)
	{
		[self setupCameraCaptureSession];
		self.currentCameraShown = AVCaptureDevicePositionBack;
	}
	return self;
}

- (void)setupCameraCaptureSession
{
    self.captureSession = [AVCaptureSession new];
    self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    self.currentCameraShown = AVCaptureDevicePositionBack;
}

- (void)updateCurrentCameraShown:(AVCaptureDevicePosition)currentCameraShown
{
	if(_currentCameraShown != currentCameraShown)
	{
		_currentCameraShown = currentCameraShown;
		[self updateCamera];
	}
}

- (void)updateCamera
{
	[self resetCaptureInput];
	NSError *error = nil;
	self.captureDevice = [self captureDeviceWithCameraPosition:self.currentCameraShown];
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice
															  error:&error];
	if (!error)
		[self.captureSession addInput:self.captureInput];
}

// Video Start/Stop
- (void)startVideo
{
	[self.captureSession startRunning];
}

- (void)stopVideo
{
	[self.captureSession stopRunning];
}

- (void)resetCaptureInput
{
	if (self.captureInput)
	{
		[self.captureSession removeInput:self.captureInput];
		self.captureInput = nil;
	}
}

- (AVCaptureDevice *)captureDeviceWithCameraPosition:(AVCaptureDevicePosition)position
{
	for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
	{
		if (device.position == position)
			return device;
	}
	return nil;
}

@end
