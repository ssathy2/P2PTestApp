//
//  DDDVideoModel.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 11/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"
#import "DDDVideoOutputStreamingController.h"
#import "DDDAVCaptureManager.h"

@interface DDDVideoViewModel : DDDViewModel

@property (strong, nonatomic, readonly) NSArray *peerList;
@property (strong, nonatomic, readonly) DDDVideoOutputStreamingController *outputStreamingController;
@property (strong, nonatomic, readonly) DDDAVCaptureManager *captureManager;

// AV Capture Related
- (void)startVideo;
- (void)stopVideo;
- (void)displayCamera:(AVCaptureDevicePosition)position;
@end

@protocol  DDDVideoViewModelListener <DDDViewModelListener> @optional
- (void)viewModel:(DDDVideoViewModel *)videoModel didInitializeCaptureManager:(DDDAVCaptureManager *)captureManager;
@end
