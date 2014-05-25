//
//  DDDPeerKitContainer.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDPeerKitContainer.h"

#define DDDSessionContainerAdvertiserServiceType @"ddd-stream"

@interface DDDPeerKitContainer()<MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>
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

@implementation DDDPeerKitContainer
+ (instancetype) sharedInstance
{
	static DDDPeerKitContainer* sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[DDDPeerKitContainer alloc] init];
        // do any init for the shared instance here
	});
	return sharedInstance;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		self.connectedPeers = [NSMutableArray array];
		self.foundPeers = [NSMutableArray array];
		self.streamingPeers = [NSMutableArray array];
		self.sessionMode = DDDSessionModeBroadcasting;
	}
	return self;
}

//
- (void)updateDisplayName:(NSString *)displayName
{
	_displayName = displayName;
	[self invalidateSession];
}

- (void)invalidateSession
{
	self.appPeerID = [[MCPeerID alloc] initWithDisplayName:self.displayName];
	self.currentSession = [[MCSession alloc] initWithPeer:self.appPeerID];
	self.serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.appPeerID discoveryInfo:nil serviceType:DDDSessionContainerAdvertiserServiceType];
	self.serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.appPeerID serviceType:DDDSessionContainerAdvertiserServiceType];
	self.serviceAdvertiser.delegate = self;
	self.serviceBrowser.delegate = self;
	self.currentSession.delegate = self;
	[self updateSessionBroadcastingState];
}

- (void)updateSessionBroadcastingState
{
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

#pragma mark - Custom Setters
- (void)setSessionMode:(DDDSessionMode)sessionMode
{
	_sessionMode = sessionMode;
	[self updateSessionBroadcastingState];
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
	NSLog(@"Received data of length: %lu from Peer: %@", (unsigned long)[data length], peerID);
	[self callDelegateListenersWithSelector:@selector(peerkitContainer:didReceiveData:) withObject:[DDDRemoteDataWrapper wrapperWithData:data withSourcePeer:peerID]];
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
	NSLog(@"Recieved a stream(bytes available: %i) from peer: %@", [stream hasBytesAvailable], peerID);
	[self callDelegateListenersWithSelector:@selector(peerKitContainer:didRecieveStream:) withObject:[DDDRemoteInputStreamWrapper wrapperWithStream:stream withSourcePeer:peerID]];
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
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID
	   withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
	// Recieved an invitation from a client that wants to start a video streaming session with sender
	// accept handler
	// call connected peer listener
	invitationHandler(YES, self.currentSession);
}

// Advertising did not start due to an error
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
	NSLog(@"Advertising didn't start due to error: %@", error);
}

#pragma mark - MCSessionDelegate methods
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	//    0: MCSessionStateNotConnected,     // not in the session
	//    1: MCSessionStateConnecting,       // connecting to this peer
	//    2: MCSessionStateConnected         // connected to the session
	NSLog(@"Peer %@ changed state to %i", peerID, state);
	switch(state)
	{
		case MCSessionStateNotConnected:
		{
			[self.connectedPeers safeRemoveObject:peerID];
			[self callDelegateListenersWithSelector:@selector(peerkitContainer:didDisconnectFromPeer:) withObject:peerID];
			break;
		}
		case MCSessionStateConnected:
		{
			[self.connectedPeers safeAddObject:peerID];
			[self callDelegateListenersWithSelector:@selector(peerkitContainer:didConnectToPeer:) withObject:peerID];
			break;
		}
		case MCSessionStateConnecting:
		{
			[self callDelegateListenersWithSelector:@selector(peerkitContainer:didStartConnectingToPeer:) withObject:peerID];
			break;
		}
		default:
			break;
	}
	[self callDelegateListenersWithSelector:@selector(peerkitContainer:didUpdateConnectedPeerList:) withObject:self.connectedPeers];
}

#pragma mark - MCNearbyServiceBrowserDelegate
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
	NSLog(@"Found peer: %@", peerID);
	[self.foundPeers safeAddObject:peerID];
	[self callDelegateListenersWithSelector:@selector(peerkitContainer:didUpdateFoundPeerList:) withObject:self.foundPeers];
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
	NSLog(@"Lost peer: %@", peerID);
	[self.foundPeers safeRemoveObject:peerID];
	[self callDelegateListenersWithSelector:@selector(peerkitContainer:didUpdateFoundPeerList:) withObject:self.foundPeers];
}

- (void)connectToPeer:(MCPeerID *)peer
{
	if([self.foundPeers containsObject:peer])
	{
		[self.serviceBrowser invitePeer:peer toSession:self.currentSession withContext:nil timeout:-1];
	}
}

- (void)disconnect
{
	[self.serviceBrowser stopBrowsingForPeers];
	[self.serviceAdvertiser stopAdvertisingPeer];
}

// Browsing did not start due to an error
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
	NSLog(@"Browsing didn't start due to error: %@", error);
}

- (void)sendData:(NSData *)data toPeer:(MCPeerID *)peer
{
	[self.currentSession sendData:data toPeers:@[peer] withMode:MCSessionSendDataReliable error:nil];
}

- (NSString*)streamIdentifierWithPeer:(MCPeerID*)peer
{
	return [NSString stringWithFormat:@"DDDStreamOutput_%@", peer.displayName];
}

- (void)startStreamWithAllPeers
{
	for(MCPeerID *connectedPeer in self.connectedPeers)
	{
		NSError *error;
		NSOutputStream *stream = [self.currentSession startStreamWithName:[self streamIdentifierWithPeer:connectedPeer] toPeer:connectedPeer error:&error];
		[self callDelegateListenersWithSelector:@selector(peerkitContainer:didOpenStream:) withObject:[DDDRemoteOutputStreamWrapper wrapperWithStream:stream withSourcePeer:connectedPeer]];
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
