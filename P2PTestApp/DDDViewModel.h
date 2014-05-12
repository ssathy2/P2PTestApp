//
//  DDDViewModel.h
//  autolayouttest
//
//  Created by Sidd Sathyam on 01/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

// An empty protocol declaration that inherting view models must inherit from when defining view model delegate methods
@protocol DDDViewModelListener <NSObject> @optional
@end

@interface DDDViewModel : NSObject

- (void)registerListener:(id<DDDViewModelListener>)listener;
- (void)deregisterListener:(id<DDDViewModelListener>)listener;

- (void)callDelegateListenersWithSelector:(SEL)selector;
- (void)callDelegateListenersWithSelector:(SEL)selector withObject:(id)object;
@end
