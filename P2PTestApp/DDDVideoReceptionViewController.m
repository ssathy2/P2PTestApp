//
//  DDDVideoReceptionViewController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 11/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoReceptionViewController.h"
#import "DDDVideoReceptionViewModel.h"

@interface DDDVideoReceptionViewController ()<NSStreamDelegate>
@property (strong, nonatomic, readonly) NSInputStream *stream;
@property (strong, nonatomic) DDDVideoReceptionViewModel *passthroughViewModel;
@end

@implementation DDDVideoReceptionViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.viewModel = [DDDVideoReceptionViewModel new];
	self.passthroughViewModel = (DDDVideoReceptionViewModel *)self.viewModel;
}

- (NSInputStream *)stream
{
	return self.passthroughViewModel.inputStream;
}

#pragma mark - DDDViewReceptionViewModelListener
- (void)viewModel:(DDDVideoReceptionViewModel *)viewModel didUpdateInputStream:(NSInputStream *)inputStream
{
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	inputStream.delegate = self;
	[inputStream open];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	switch (eventCode) {
		case NSStreamEventHasBytesAvailable:
			[self handleStreamHasBytesAvailable];
			break;
		case NSStreamEventErrorOccurred:
			[self handleStreamError];
			break;
		case NSStreamEventEndEncountered:
			[self handleStreamEnd];
			break;
		case NSStreamEventNone:
			NSLog(@"Stream Event None");
			break;
		case NSStreamEventOpenCompleted:
			[self handleStreamEventOpenCompleted];
			break;
		default:
			break;
	}
}

- (void)handleStreamEventOpenCompleted
{
	NSLog(@"Stream open completed");
}

- (void)handleStreamHasBytesAvailable
{
	NSLog(@"Stream has bytes open");
	// A 10 mb buffer
	NSUInteger maxLen = 1024*10;
	uint8_t *buffer = (uint8_t*)malloc(maxLen);
	while(self.stream.hasBytesAvailable)
	{
		NSInteger bytesRead = [self.stream read:buffer maxLength:maxLen];
		NSLog(@"Read %li bytes", (long)bytesRead);
		memset(buffer,0,(size_t)maxLen);
	}
}

- (void)handleStreamEnd
{
	NSLog(@"Stream end");
	[self.stream close];
	[self.stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)handleStreamError
{
	NSLog(@"Stream error");
}

@end
