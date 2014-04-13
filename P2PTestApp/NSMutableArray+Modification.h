//
//  NSMutableArray+Modification.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 13/04/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Modification)
// Only adds the param object iff the object doesn't already exist in the array
- (void)safeAddObject:(id)anObject;

// only remove the param object iff the object exists in the array
- (void)safeRemoveObject:(id)anObject;
@end
