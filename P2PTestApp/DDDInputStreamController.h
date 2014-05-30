//
//  DDDInputStreamController.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/29/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDDInputStreamControllerDelegate;

@interface DDDInputStreamController : NSObject
@property (strong, nonatomic, readonly) AVAssetWriterInput *inputAssetWriter;
@property (weak, nonatomic) id<DDDInputStreamControllerDelegate> delegate;
- (void)startStreamingWithStream:(NSInputStream *)stream;
@end

@protocol DDDInputStreamControllerDelegate <NSObject>
- (void)streamController:(DDDInputStreamController *)streamController startedWritingToAssetWriter:(AVAssetWriterInput *)inputAssetWriter;
- (void)streamController:(DDDInputStreamController *)streamController streamStatusUpdated:(NSStreamStatus)status;

@end
