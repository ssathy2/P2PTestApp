//
//  DDDAVCaptureManager.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 21/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDAVCaptureManager : NSObject
// Camera related
@property (strong, nonatomic, readonly) AVCaptureSession *captureSession;
@property (strong, nonatomic, readonly) AVCaptureDevice *captureDevice;
@property (strong, nonatomic, readonly) AVCaptureDeviceInput *captureInput;
@property (nonatomic, assign, readonly) AVCaptureDevicePosition currentCameraShown;

- (void)updateCurrentCameraShown:(AVCaptureDevicePosition)position;
- (void)startVideo;
- (void)stopVideo;
@end
