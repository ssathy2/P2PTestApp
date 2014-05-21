//
//  DDDVideoBroadcastViewController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoBroadcastViewController.h"

@interface DDDVideoBroadcastViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (weak, nonatomic) IBOutlet UIView *videoPreviewView;
@property (weak, nonatomic) IBOutlet UIButton *startBroadcastingButton;
@property (weak, nonatomic) IBOutlet UIButton *stopBroadcastingButton;
@property (weak, nonatomic) IBOutlet UIView *buttonsContainer;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cameraSelectionSegmentControl;

// Camera related
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *captureInput;
@property (nonatomic, assign) AVCaptureDevicePosition currentCameraShown;

// Delegtate Queue
@property (strong, nonatomic) dispatch_queue_t delegateQueue;
@end

@implementation DDDVideoBroadcastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupCameraCaptureSession];
	[self setupPreviewLayer];
	self.currentCameraShown = AVCaptureDevicePositionFront;
	[self startVideoPreview];
}

- (void)setupCameraCaptureSession
{
    self.captureSession = [AVCaptureSession new];
    self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    self.currentCameraShown = AVCaptureDevicePositionBack;
}

- (void)setupPreviewLayer
{
	// Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [AVCaptureVideoDataOutput new];
    [self.captureSession addOutput:output];
	
    if (!self.delegateQueue)
		self.delegateQueue = dispatch_queue_create(DDDBufferDelegateQueue, NULL);
    [output setSampleBufferDelegate:self queue:self.delegateQueue];
	
    // Specify the pixel format
    output.videoSettings = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
	self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
	self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	self.previewLayer.frame = self.videoPreviewView.bounds;
	[self.videoPreviewView.layer addSublayer:self.previewLayer];
}

- (IBAction)stopBroadcastingTapped:(id)sender
{
	[self stopVideoPreview];
}

- (IBAction)startBroadcastingTapped:(id)sender
{
	[self startVideoPreview];
}

// Video Preview
- (void)startVideoPreview
{
	[self.captureSession startRunning];
}

- (void)stopVideoPreview
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

- (AVCaptureDevice *)captureDeviceWithCameraPosition:(AVCaptureDevicePosition)position
{
	for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
	{
		if (device.position == position)
			return device;
	}
	return nil;
}

- (void)setCurrentCameraShown:(AVCaptureDevicePosition)currentCameraShown
{
	_currentCameraShown = currentCameraShown;
	[self updateCamera];
}

- (IBAction)cameraSelectionSegmentControlValueChanged:(UISegmentedControl *)sender
{
	self.currentCameraShown = (AVCaptureDevicePosition)(sender.selectedSegmentIndex+1);
}

@end
