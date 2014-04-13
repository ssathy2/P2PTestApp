//
//  NSMutableArray+Modification.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 13/04/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "NSMutableArray+Modification.h"

@implementation NSMutableArray (Modification)
- (void)safeAddObject:(id)anObject
{
	if (![self containsObject:anObject])
	{
		[self addObject:anObject];
	}
}

- (void)safeRemoveObject:(id)anObject
{
	if ([self containsObject:anObject])
	{
		[self removeObject:anObject];
	}
}
@end
