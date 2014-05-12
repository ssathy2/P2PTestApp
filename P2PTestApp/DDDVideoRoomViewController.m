//
//  DDDVideoRoomViewController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoRoomViewController.h"
#import "DDDVideoViewModel.h"

#define DDDBrowsingCellIdentifier @"DDDBrowsingCellIdentifier"

@interface DDDVideoRoomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@end

@implementation DDDVideoRoomTableViewCell
@end

@interface DDDVideoRoomViewController ()
@property (weak, nonatomic) IBOutlet UITableView *roomTableView;
@property (strong, nonatomic) DDDVideoViewModel *viewModel;
@end

@implementation DDDVideoRoomViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.viewModel.peerList.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MCPeerID *peer = self.viewModel.peerList[indexPath.row];
	DDDVideoRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DDDBrowsingCellIdentifier];
	cell.cellLabel.text = peer.displayName;
	return cell;
}

#pragma mark - DDDVideoViewModelListener
- (void)viewModel:(DDDVideoViewModel *)videoModel didUpdateFoundPeers:(NSArray *)foundArray
{
	[self.roomTableView reloadData];
}

@end
