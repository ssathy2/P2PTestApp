//
//  DDDVideoStreamManager.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDSessionContainer.h"

#define DDDSessionContainerAdvertiserServiceType @"ddd-stream"

@interface DDDSessionContainer()<MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>
@property (strong, nonatomic) MCSession *currentSession;
@property (strong, nonatomic) MCPeerID *appPeerID;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (strong, nonatomic) MCNearbyServiceBrowser *serviceBrowser;
@property (strong, nonatomic) NSString *displayName;

// When we're browsing we update the found peers
@property (strong, nonatomic) NSMutableArray *foundPeers;

// When we're advertising and we find peer that accepts our request to connect, we update this array
@property (strong, nonatomic) NSMutableArray *connectedPeers;

// Keep track of all the peers we're currently streaming to in this array
@property (strong, nonatomic) NSMutableArray *streamingPeers;
@end

@implementation DDDSessionContainer

+ (instancetype)sessionContainerWithDisplayName:(NSString *)displayId
{
	return [[DDDSessionContainer alloc] initWithDisplayID:displayId];
}

- (instancetype)initWithDisplayID:(NSString *)displayID
{
	self = [super init];
	if (self)
	{
		self.displayName = displayID;
		self.appPeerID = [[MCPeerID alloc] initWithDisplayName:self.displayName];
		self.currentSession = [[MCSession alloc] initWithPeer:self.appPeerID];
		self.serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.appPeerID discoveryInfo:nil serviceType:DDDSessionContainerAdvertiserServiceType];
		self.serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.appPeerID serviceType:DDDSessionContainerAdvertiserServiceType];

		self.connectedPeers = [NSMutableArray array];
		self.foundPeers = [NSMutableArray array];
		self.streamingPeers = [NSMutableArray array];
		
		self.serviceAdvertiser.delegate = self;
		self.serviceBrowser.delegate = self;
		self.currentSession.delegate = self;
	}
	return self;
}

#pragma mark - Custom Setters
- (void)setSessionMode:(DDDSessionMode)sessionMode
{
	_sessionMode = sessionMode;
	switch (self.sessionMode)
	{
		case DDDSessionModeBroadcasting:
		{
			[self.serviceAdvertiser startAdvertisingPeer];
			[self.serviceBrowser stopBrowsingForPeers];
			break;
		}
		case DDDSessionModeBrowsing:
		{
			[self.serviceAdvertiser stopAdvertisingPeer];
			[self.serviceBrowser startBrowsingForPeers];
			break;
		}
		default:
			break;
	}
}

#pragma mark - MCSessionDelegate methods
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	NSLog(@"Peer %@ changed state to %i", peerID, state);
//    MCSessionStateNotConnected,     // not in the session
//    MCSessionStateConnecting,       // connecting to this peer
//    MCSessionStateConnected         // connected to the session
	switch(state)
	{
		case MCSessionStateNotConnected:
		{
			[self.connectedPeers safeRemoveObject:peerID];
			break;
		}
		case MCSessionStateConnected:
		{
			[self.connectedPeers safeAddObject:peerID];
			break;
		}
		case MCSessionStateConnecting:
		{
			break;
		}
		default:
			break;
	}
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
	NSLog(@"Received data of length: %lu from Peer: %@", (unsigned long)[data length], peerID);
	if ([self.dataDalegate respondsToSelector:@selector(sessionContainer:recievedData:fromPeer:)])
	{
		[self.dataDalegate sessionContainer:self recievedData:data fromPeer:peerID];
	}
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
	NSLog(@"Recieved a stream(bytes available: %i) from peer: %@", [stream hasBytesAvailable], peerID);
	if ([self.dataDalegate respondsToSelector:@selector(sessionContainer:recievedStream:fromPeer:)])
	{
		[self.dataDalegate sessionContainer:self recievedStream:stream fromPeer:peerID];
	}
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
	[self.connectedPeers addObject:peerID];
	// By default accept this session
	invitationHandler(YES, self.currentSession);
}

// Advertising did not start due to an error
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
	NSLog(@"Could not start advertising: %@", error);
}

#pragma mark - MCNearbyServiceBrowserDelegate
// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
	NSLog(@"Found new peer with peerid: %@ with discovery info: %@", peerID, info);
	[self.foundPeers safeAddObject:peerID];
	if ([self.browsingDelegate respondsToSelector:@selector(sessionContainer:foundPeerListUpdated:)])
	{
		[self.browsingDelegate sessionContainer:self foundPeerListUpdated:self.foundPeers];
	}
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
	NSLog(@"Lost peer with peerid: %@", peerID);
	[self.foundPeers safeRemoveObject:peerID];
	if ([self.browsingDelegate respondsToSelector:@selector(sessionContainer:foundPeerListUpdated:)])
	{
		[self.browsingDelegate sessionContainer:self foundPeerListUpdated:self.foundPeers];
	}
		
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
	NSLog(@"Could not start browsing for peers: %@", error);
}

- (void)connectToPeer:(MCPeerID *)peer callback:(void (^)(BOOL, NSError *))callback
{
	[self.currentSession nearbyConnectionDataForPeer:peer withCompletionHandler:^(NSData *connectionData, NSError *error) {
		if (connectionData && !error)
		{
			[self.currentSession connectPeer:peer withNearbyConnectionData:connectionData];
		}
	}];

}

- (void)disconnectFromPeer:(MCPeerID *)peer
{
	//@TODO: Figure out to disconnect from individual peers
}

- (void)sendData:(NSData *)data toPeer:(MCPeerID *)peer
{
	[self.currentSession sendData:data toPeers:@[peer] withMode:MCSessionSendDataReliable error:nil];
}

- (NSString*)streamIdentifierWithPeer:(MCPeerID*)peer
{
	return [NSString stringWithFormat:@"DDDStreamOutput_%@", peer.displayName];
}

- (void)sendStream:(NSOutputStream *)stream toPeer:(MCPeerID *)peer
{
	if (![self.streamingPeers containsObject:peer])
	{
		[self.currentSession startStreamWithName:[self streamIdentifierWithPeer:peer] toPeer:peer error:nil];
		[self.streamingPeers addObject:peer];
	}
}

- (void)sendStreamToAllConnectedPeers:(NSOutputStream *)outputStream
{
	for (MCPeerID *peer in self.connectedPeers)
	{
		[self sendStream:outputStream toPeer:peer];
	}
}

- (void)sendDataToAllConnectedPeers:(NSData*)data
{
	for (MCPeerID *peer in self.connectedPeers)
	{
		[self sendData:data toPeer:peer];
	}
}

@end
