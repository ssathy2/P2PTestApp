//
//  DDDBaseViewController.h
//  autolayouttest
//
//  Created by Sidd Sathyam on 02/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDDViewModel.h"

@interface DDDViewController : UIViewController

// Set the viewmodel property to be able to pass on view models between vc's
@property (strong, nonatomic) DDDViewModel *viewModel;

// Subclasses implement this method to be able to bind properties of classes to resulting destination vc's of segues
- (NSDictionary *)segueIdentifierToContainerViewControllerMapping;

// Subclassers should implement this if the path to this viewcontroller is not that that can be found by the system
+ (instancetype)instance;

// Uses "Main.storyboard" by default if this is not implemented
+ (NSString *)storyboardName;

// the identifier of the viewcontroller in the storyboard or nib...Uses the name of the class as default
+ (NSString *)identifier;
@end
