//
//  DDDViewModel.m
//  autolayouttest
//
//  Created by Sidd Sathyam on 01/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"
#import <objc/objc-runtime.h>

@interface DDDViewModel()
@property (strong, nonatomic) NSHashTable *listeners;
@end
@implementation DDDViewModel
- (id)init
{
	self = [super init];
	if (self)
	{
		self.listeners = [NSHashTable weakObjectsHashTable];
	}
	return self;
}

- (void)registerListener:(id<DDDViewModelListener>)listener
{
	if (![self.listeners containsObject:listener])
	{
		[self.listeners addObject:listener];
	}
}

- (void)deregisterListener:(id<DDDViewModelListener>)listener
{
	if (![self.listeners containsObject:listener])
	{
		[self.listeners removeObject:listener];
	}
}

- (void)callDelegateListenersWithSelector:(SEL)selector
{
	[self callDelegateListenersWithSelector:selector withObject:nil];
}

- (void)callDelegateListenersWithSelector:(SEL)selector withObject:(id)object1
{
	dispatch_async(dispatch_get_main_queue(), ^{
		for (id<DDDViewModelListener> listener in self.listeners)
		{
			if ([listener respondsToSelector:selector])
			{
				[listener performSelector:selector withObject:self withObject:object1];
			}
		}
	});
}
@end
