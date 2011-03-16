//
//  FlickrPersonManager.m
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPersonManager.h"

@implementation FlickrPersonManager

static FlickrPersonManager* sharedPersonManager = nil;

#pragma mark - Object lifecycle

- (id)init
	{
	if((self = [super init]))
		{
		persons = [[NSMutableArray alloc] init];
		}
	return self;
	}

- (void)dealloc
	{
	[persons release];
	[super dealloc];
	}

#pragma mark - Singleton implementation

+ (FlickrPersonManager*)sharedManager
	{
	@synchronized(self)
		{
		if (sharedPersonManager == nil)
			{
			sharedPersonManager = [[FlickrPersonManager alloc] init];
			}
		}
	return sharedPersonManager;
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

#pragma mark - Search methods

- (FlickrPerson*)personForID:(NSString*)anID
	{
	return nil;
	}
	
- (FlickrPerson*)personForUsername:(NSString*)anUserame
	{
	return nil;
	}
	
- (NSArray*)personsForName:(NSString*)aName
	{
	return nil;
	}
	
- (NSArray*)personsForLocation:(NSString*)aLocation
	{
	return nil;
	}

#pragma mark - Person management methods

- (BOOL)addPerson:(FlickrPerson*)aPerson
	{
	return YES;
	}

- (BOOL)removePerson:(FlickrPerson*)aPerson
	{
	return YES;
	}

@end
