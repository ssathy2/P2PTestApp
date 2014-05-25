//
//  DDDViewController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewControllers.h"
#import "DDDMainStoryboardIdentifiers.h"
#import "DDDPeerKitContainer.h"

typedef NS_ENUM(NSInteger, DDDTabBarContainerIndex)
{
	DDDTabBarContainerIndexVideoBroadcast,
	DDDTabBarContainerIndexVideoRoom
};

@interface DDDContainerViewController ()<UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *tabbarContainerView;
@property (weak, nonatomic) UITabBarController *tabbarController;
@end

@implementation DDDContainerViewController
+ (NSString *)identifier
{
	return DDDContainerViewControllerIdentifier;
}

+ (NSString *)storyboardName
{
	return DDDMainStoryboardName;
}

- (NSDictionary *)segueIdentifierToContainerViewControllerMapping
{
	return @{
			 DDDContainerViewTabbarViewControllerEmbedIdentifier: @key(self.tabbarController)
			 };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.tabbarController.delegate = self;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	switch (tabBarController.selectedIndex)
	{
		case DDDTabBarContainerIndexVideoBroadcast:
		{
			[[DDDPeerKitContainer sharedInstance] setSessionMode:DDDSessionModeBroadcasting];
			break;
		}
		case DDDTabBarContainerIndexVideoRoom:
		{
			[[DDDPeerKitContainer sharedInstance] setSessionMode:DDDSessionModeBrowsing];
			break;
		}
		default:
			break;
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
