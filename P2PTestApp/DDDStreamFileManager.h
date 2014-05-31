//
//  DDDFileManager.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/31/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDStreamFileManager : NSObject
+ (instancetype)sharedInstance;

// These methods will create and destroy files as streaming begins and ends
- (NSURL *)startStreamToFile;
- (void)stopStreamToFile;
@end
