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

@end
