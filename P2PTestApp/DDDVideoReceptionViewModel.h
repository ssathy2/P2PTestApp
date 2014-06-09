//
//  DDDVideoReceptionViewModel.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"
#import "DDDInputStreamController.h"

@interface DDDVideoReceptionViewModel : DDDViewModel
@property (strong, nonatomic, readonly) NSInputStream *inputStream;
@property (strong, nonatomic, readonly) DDDInputStreamController *inputStreamingController;
@end

@protocol DDDVideoReceptionViewModelListener <DDDViewModelListener> @optional
- (void)viewModel:(DDDVideoReceptionViewModel *)viewModel didUpdatePlayerItem:(AVPlayerItem *)item;
@end
