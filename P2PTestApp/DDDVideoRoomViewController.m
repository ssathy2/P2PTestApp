//
//  DDDVideoRoomViewController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoRoomViewController.h"
#import "DDDVideoRoomViewModel.h"
#import "DDDMainStoryboardIdentifiers.h"

#define DDDBrowsingCellIdentifier @"DDDBrowsingCellIdentifier"

@interface DDDVideoRoomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@end

@implementation DDDVideoRoomTableViewCell
@end

@interface DDDVideoRoomViewController ()
@property (weak, nonatomic) IBOutlet UITableView *roomTableView;

@property (strong, nonatomic) DDDVideoRoomViewModel *passthroughViewModel;
@end

@implementation DDDVideoRoomViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.viewModel = [DDDVideoRoomViewModel new];
	self.passthroughViewModel = (DDDVideoRoomViewModel *)self.viewModel;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MCPeerID *selectedPeerID = self.passthroughViewModel.foundPeers[indexPath.row];
	[self.passthroughViewModel connectToPeer:selectedPeerID];
	[self.view showLoadingOverlay];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return [UIView new];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.passthroughViewModel.foundPeers.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MCPeerID *peer = self.passthroughViewModel.foundPeers[indexPath.row];
	DDDVideoRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DDDBrowsingCellIdentifier];
	cell.cellLabel.text = peer.displayName;
	return cell;
}

#pragma mark - DDDVideoRoomViewModelListener
- (void)viewModel:(DDDVideoRoomViewModel *)viewModel didFoundUpdatePeerList:(NSArray *)foundPeers
{
	[self.roomTableView reloadData];
}

- (void)viewModel:(DDDVideoRoomViewModel *)viewModel didConnectToPeer:(MCPeerID *)peerID
{
	[self.view hideLoadingOverlay];
	[self performSegueWithIdentifier:DDDVideoReceptionPushSegueIdentifier sender:nil];
}

@end
