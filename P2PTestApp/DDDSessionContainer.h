//
//  DDDVideoStreamManager.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDSessionContainer : NSObject<MCSessionDelegate>

@property (readonly, nonatomic) MCPeerID *appPeerID;

- (instancetype)initWithDisplayID:(NSString*)displayID;

- (void)startBrowsingForPeers;
- (void)stopBrowsingForPeers;

- (void)startAdvertisingToPeers;
- (void)stopAdvertisingToPeers;
@end
