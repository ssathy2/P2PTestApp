//
//  DDDVideoReceptionViewController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 11/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoReceptionViewController.h"
#import "DDDVideoReceptionViewModel.h"
#import "P2PTestApp-Swift.h"

@interface DDDVideoReceptionViewController ()
@property (weak, nonatomic) IBOutlet UIView *videoPreviewView;
@property (weak, nonatomic) IBOutlet UIView *videoPreviewContainer;
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

#pragma mark - DDDVideoReceptionViewModelListener
- (void)viewModel:(DDDVideoReceptionViewModel *)viewModel didUpdatePlayerItem:(AVPlayerItem *)item
{
	DDDPlayerView *playerView = [[DDDPlayerView alloc] initWithPlayerItem:item frame:self.videoPreviewView.bounds];
	[self.videoPreviewView addSubview:playerView];
}
@end
