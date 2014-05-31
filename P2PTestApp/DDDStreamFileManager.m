//
//  DDDFileManager.m
//  P2PTestApp
//
//  Created by Sidd Sathyam on 5/31/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDStreamFileManager.h"

#define DDDInputStreamFileName @"DDDInputStreamFileBuffer"

@interface DDDStreamFileManager()
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSURL *currentFileURL;
@end
@implementation DDDStreamFileManager
+ (instancetype) sharedInstance
{
	static DDDStreamFileManager* sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[DDDStreamFileManager alloc] init];
        // do any init for the shared instance here
	});
	return sharedInstance;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		self.fileManager = [NSFileManager defaultManager];
		self.currentFileURL = nil;
		[self setupFile];
	}
	return self;
}

- (void)setupFile
{
	NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	NSString *filePath = [folderPath stringByAppendingPathComponent:DDDInputStreamFileName];
	self.currentFileURL = [NSURL fileURLWithPath:filePath isDirectory:YES];
	if(![self.fileManager createFileAtPath:filePath contents:nil attributes:nil])
		NSLog(@"ERROR: File not created at path: %@", filePath);
}

- (NSURL *)startStreamToFile
{
	BOOL isDirectory;
	if (![self.fileManager fileExistsAtPath:self.currentFileURL.absoluteString isDirectory:&isDirectory])
		[self setupFile];
	
	return self.currentFileURL;
}

- (void)stopStreamToFile
{
	BOOL isDirectory;
	if ([self.fileManager fileExistsAtPath:self.currentFileURL.absoluteString isDirectory:&isDirectory])
	{
		NSError *error;
		[self.fileManager removeItemAtURL:self.currentFileURL error:&error];
		if (error)
			NSLog(@"ERROR in stopping stream to file: %@", error);
	}
		
}

@end
