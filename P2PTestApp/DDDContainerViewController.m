//
//  DDDViewController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewControllers.h"
#import "DDDSessionContainer.h"
#import "DDDMainStoryboardIdentifiers.h"
#import "DDDVideoViewModel.h"

typedef NS_ENUM(NSInteger, DDDTabBarContainerIndex)
{
	DDDTabBarContainerIndexVideoBroadcast,
	DDDTabBarContainerIndexVideoRoom
};

@interface DDDContainerViewController ()<UITabBarControllerDelegate, DDDVideoViewModelListener>
@property (weak, nonatomic) IBOutlet UIView *tabbarContainerView;
@property (weak, nonatomic) UITabBarController *tabbarController;
@property (strong, nonatomic) DDDVideoViewModel *viewModel;
@end

@implementation DDDContainerViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		self.viewModel = [[DDDVideoViewModel alloc] init];
	}
	return self;
}

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
	self.tabBarController.delegate = self;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	DDDViewController *vc = (DDDViewController *)viewController;
	switch (tabBarController.selectedIndex)
	{
		case DDDTabBarContainerIndexVideoBroadcast:
		{
			[self.viewModel setMode:DDDSessionModeBroadcasting];
			break;
		}
		case DDDTabBarContainerIndexVideoRoom:
		{
			[self.viewModel setMode:DDDSessionModeBrowsing];
			break;
		}
		default:
			break;
	}
	vc.viewModel = self.viewModel;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
