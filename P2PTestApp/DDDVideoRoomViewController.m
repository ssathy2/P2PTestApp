//
//  DDDVideoRoomViewController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDVideoRoomViewController.h"

#define DDDBrowsingCellIdentifier @"DDDBrowsingCellIdentifier"

@interface DDDVideoRoomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@end

@implementation DDDVideoRoomTableViewCell
@end

@interface DDDVideoRoomViewController ()<DDDSessionBrowsingDelegate>
@property (weak, nonatomic) IBOutlet UITableView *roomTableView;
@end

@implementation DDDVideoRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.sessionContainer.browsingDelegate = self;
	[self.sessionContainer startBrowsingForPeers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.sessionContainer.foundPeers.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MCPeerID *peer = self.sessionContainer.foundPeers[indexPath.row];
	DDDVideoRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DDDBrowsingCellIdentifier];
	cell.cellLabel.text = peer.displayName;
	return cell;
}

#pragma mark - DDDSessionBrowsingDelegate
- (void)sessionContainer:(DDDSessionContainer*)session foundPeerListUpdated:(NSArray*)peerList
{
	[self.roomTableView reloadData];
}

@end
