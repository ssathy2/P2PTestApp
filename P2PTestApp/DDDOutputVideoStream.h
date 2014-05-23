//
//  DDDOutputVideoStream.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 20/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDOutputVideoStream : NSObject
@property (strong, nonatomic, readonly) NSOutputStream *stream;

+ (instancetype)videoStreamWithCaptureOutput:(AVCaptureVideoDataOutput *)output;
- (void)startStream;
- (void)stopStream;
@end
