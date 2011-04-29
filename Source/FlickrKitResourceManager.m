//
//  FlickrKitResourceManager.m
//  FlickrKit
//
//  Created by Felix Morgner on 17.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrKitResourceManager.h"
#import "FlickrKitConstants.h"

@implementation FlickrKitResourceManager

static FlickrKitResourceManager* sharedResourceManager = nil;

#pragma mark - Object lifecycle

- (id)init
	{
	if((self = [super init]))
		{

		}
	return self;
	}

- (void)dealloc
	{
	[super dealloc];
	}

#pragma mark - Singleton implementation

+ (FlickrKitResourceManager*)sharedManager
	{
	@synchronized(self)
		{
		if (sharedResourceManager == nil)
			{
			sharedResourceManager = [[super allocWithZone:NULL] init];
			}
		}
	return sharedResourceManager;
	}

+ (id)allocWithZone:(NSZone *)zone
	{
  return [[self sharedManager] retain];
	}

- (id)copyWithZone:(NSZone *)zone
	{
  return self;
	}
 
- (id)retain
	{
  return self;
	}
 
- (NSUInteger)retainCount
	{
  return UINT_MAX;
	}
 
- (void)release
	{
	}
 
- (id)autorelease
	{
  return self;
	}

@end
