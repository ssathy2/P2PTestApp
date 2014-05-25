//
//  DDDVideoReceptionViewModel.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"

@interface DDDVideoReceptionViewModel : DDDViewModel
@property (strong, nonatomic) NSInputStream *inputStream;
@end

@protocol DDDVideoReceptionViewModelListener <DDDViewModelListener> @optional
- (void)viewModel:(DDDVideoReceptionViewModel *)viewModel didUpdateInputStream:(NSInputStream *)inputStream;
@end
