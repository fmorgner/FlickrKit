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
			sharedPersonManager = [[super allocWithZone:NULL] init];
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
	NSPredicate* filterPredicate = [NSPredicate predicateWithFormat:@"ID like %@", anID];
	NSArray* filterResult = [persons filteredArrayUsingPredicate:filterPredicate];
	return [filterResult lastObject];
	}
	
- (FlickrPerson*)personForUsername:(NSString*)anUserame
	{
	NSPredicate* filterPredicate = [NSPredicate predicateWithFormat:@"username like %@", anUserame];
	NSArray* filterResult = [persons filteredArrayUsingPredicate:filterPredicate];
	return [filterResult lastObject];
	}
	
- (NSArray*)personsForName:(NSString*)aName
	{
	NSPredicate* filterPredicate = [NSPredicate predicateWithFormat:@"name like %@", aName];
	NSArray* filterResult = [persons filteredArrayUsingPredicate:filterPredicate];
	return filterResult;
	}
	
- (NSArray*)personsForLocation:(NSString*)aLocation
	{
	NSPredicate* filterPredicate = [NSPredicate predicateWithFormat:@"location like %@", aLocation];
	NSArray* filterResult = [persons filteredArrayUsingPredicate:filterPredicate];
	return filterResult;
	}

#pragma mark - Person management methods

- (BOOL)addPerson:(FlickrPerson*)aPerson
	{
	if(![self personForID:aPerson.ID])
		[persons addObject:aPerson];
	return YES;
	}

- (BOOL)removePerson:(FlickrPerson*)aPerson
	{
	return YES;
	}

@end
