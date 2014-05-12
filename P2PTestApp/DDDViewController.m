//
//  DDDBaseViewController.m
//  autolayouttest
//
//  Created by Sidd Sathyam on 02/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewController.h"

@interface DDDViewController ()<DDDViewModelListener>

@end

@implementation DDDViewController
+ (instancetype)instance
{
	NSString *storyboardName = [self storyboardName];
	UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
	return [sb instantiateViewControllerWithIdentifier:[self identifier]];
}

+ (NSString *)identifier
{
	return NSStringFromClass([self class]);
}

+ (NSString *)storyboardName
{
	return @"Main";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self.viewModel registerListener:self];
}

- (NSDictionary *)segueIdentifierToContainerViewControllerMapping
{
	return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[super prepareForSegue:segue sender:sender];
	NSDictionary *identifierMapping = [self segueIdentifierToContainerViewControllerMapping];
	
	if (!identifierMapping)
		return;
	
    NSString *path = [identifierMapping objectForKey:segue.identifier];
    NSAssert(path, @"This segue identifier doesn't contain a mapping! Make sure segue identifier exists in the storyboard");
    [self setValue:segue.destinationViewController forKeyPath:path];
	if ([segue.destinationViewController isKindOfClass:[DDDViewController class]])
	{
		[segue.destinationViewController performSelector:@selector(setViewModel:) withObject:self.viewModel];
	}
}
@end
