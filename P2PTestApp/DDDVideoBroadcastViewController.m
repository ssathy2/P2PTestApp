//
//  DDDVideoBroadcastViewController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoBroadcastViewController.h"
#import "DDDVideoViewModel.h"

@interface DDDVideoBroadcastViewController()
@property (weak, nonatomic) IBOutlet UIView *videoPreviewView;
@property (weak, nonatomic) IBOutlet UIButton *startBroadcastingButton;
@property (weak, nonatomic) IBOutlet UIButton *stopBroadcastingButton;
@property (weak, nonatomic) IBOutlet UIView *buttonsContainer;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cameraSelectionSegmentControl;

// Preview Layer
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

// Passthrough view model
@property (strong, nonatomic) DDDVideoViewModel *passthroughViewModel;
@end

@implementation DDDVideoBroadcastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.viewModel = [DDDVideoViewModel new];
	self.passthroughViewModel = (DDDVideoViewModel *)self.viewModel;
}

- (void)setupPreviewLayerWithCaptureManager:(DDDAVCaptureManager *)captureManager
{
	// Create a VideoDataOutput and add it to the session
	self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureManager.captureSession];
	self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	self.previewLayer.frame = self.videoPreviewView.bounds;
	[self.videoPreviewView.layer addSublayer:self.previewLayer];
}

- (IBAction)stopBroadcastingTapped:(id)sender
{
	[self.passthroughViewModel stopVideo];
}

- (IBAction)startBroadcastingTapped:(id)sender
{
	[self.passthroughViewModel startVideo];
}

- (IBAction)cameraSelectionSegmentControlValueChanged:(UISegmentedControl *)sender
{
	[self.passthroughViewModel displayCamera:(AVCaptureDevicePosition)(sender.selectedSegmentIndex+1)];
}

- (void)viewModel:(DDDVideoViewModel *)viewModel didInitializeCaptureManager:(DDDAVCaptureManager *)captureManager
{
	[self setupPreviewLayerWithCaptureManager:captureManager];
}

@end
