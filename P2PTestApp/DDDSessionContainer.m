//
//  DDDVideoStreamManager.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDSessionContainer.h"

#define DDDSessionContainerAdvertiserServiceType @"ddd-videostreaming"

@interface DDDSessionContainer()<MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>
@property (strong, nonatomic) MCSession *currentSession;
@property (strong, nonatomic) MCPeerID *appPeerID;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (strong, nonatomic) MCNearbyServiceBrowser *serviceBrowser;
@property (strong, nonatomic) NSString *displayID;
@end

@implementation DDDSessionContainer

- (instancetype)initWithDisplayID:(NSString *)displayID
{
	self = [super init];
	if (self)
	{
		self.displayID = displayID;
		self.appPeerID = [[MCPeerID alloc] initWithDisplayName:self.displayID];
		self.serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.appPeerID discoveryInfo:nil serviceType:DDDSessionContainerAdvertiserServiceType];
		self.serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.appPeerID serviceType:DDDSessionContainerAdvertiserServiceType];
	}
	return self;
}

#pragma mark - Advertising Methods
- (void)startAdvertisingToPeers
{
	
}

- (void)stopAdvertisingToPeers
{
	
}

#pragma mark - Browsing Methods
- (void)startBrowsingForPeers
{

}

- (void)stopBrowsingForPeers
{
	
}

#pragma mark - MCSessionDelegate methods
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
	
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
	
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
	
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
	
}

#pragma mark - MCNearbyServiceAdvertiserDelegate
// Incoming invitation request.  Call the invitationHandler block with YES and a valid session to connect the inviting peer to the session.
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
	
}

// Advertising did not start due to an error
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
	
}

#pragma mark - MCNearbyServiceBrowserDelegate
// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
	
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
	
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
	
}
@end
