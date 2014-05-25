//
//  DDDVideoRoomViewModel.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDDViewModel.h"

@interface DDDVideoRoomViewModel : DDDViewModel
@property (strong, nonatomic, readonly) NSArray *foundPeers;

- (void)connectToPeer:(MCPeerID *)peerID;
@end

@protocol DDDVideoRoomViewModelListener <DDDViewModelListener> @optional
- (void)viewModel:(DDDVideoRoomViewModel *)viewModel didFoundUpdatePeerList:(NSArray *)foundPeers;
- (void)viewModel:(DDDVideoRoomViewModel *)viewModel didConnectToPeer:(MCPeerID *)peerID;
- (void)viewModel:(DDDVideoRoomViewModel *)viewModel didStartConnectingToPeer:(MCPeerID *)peerID;
@end
