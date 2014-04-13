//
//  DDDViewController.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 31/03/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewController.h"
#import "DDDSessionContainer.h"
#import "DDDVideoRoomViewController.h"

@interface DDDViewController ()<UITabBarControllerDelegate>
@property (strong, nonatomic) DDDSessionContainer *sessionContainer;
@end

@implementation DDDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.delegate = self;
	NSString *randomString = [self randomStringOfLength:10];
	self.sessionContainer = [[DDDSessionContainer alloc] initWithDisplayID:randomString];
}

- (NSString*)randomStringOfLength:(NSInteger)length
{
	NSMutableString *str = [NSMutableString stringWithCapacity:length];
	for (int i = 0; i < length; i++)
	{
		// 65-122.. We want an ascii value between 65 and 122, these range of values represent the ascii character set
		char randChar = (char)('A' + (arc4random_uniform(26)));
		[str appendFormat:@"%c", randChar];
	}
	return str;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	if ([viewController isKindOfClass:[DDDVideoRoomViewController class]])
	{
		DDDVideoRoomViewController *vc = (DDDVideoRoomViewController*)viewController;
		vc.sessionContainer = self.sessionContainer;
	}
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
