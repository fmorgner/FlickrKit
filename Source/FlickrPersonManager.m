//
//  FlickrPersonManager.m
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPersonManager.h"

@interface FlickrPersonManager (Private)

- (void)setPeople:(NSMutableArray*)newPeople;

@end

@implementation FlickrPersonManager (Private)

- (void)setPeople:(NSMutableArray*)newPeople
	{
	if(newPeople != people)
		{
		[people release];
		people = [newPeople retain];
		}
	}

@end

@implementation FlickrPersonManager

static FlickrPersonManager* sharedPersonManager = nil;

#pragma mark - Object lifecycle

- (id)init
	{
	if((self = [super init]))
		{
		people = [[NSMutableArray alloc] init];
		}
	return self;
	}

- (void)dealloc
	{
	[people release];
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
 
- (oneway void)release
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
	NSArray* filterResult = [people filteredArrayUsingPredicate:filterPredicate];
	return [filterResult lastObject];
	}
	
- (FlickrPerson*)personForUsername:(NSString*)anUsername
	{
	NSPredicate* filterPredicate = [NSPredicate predicateWithFormat:@"username like %@", anUsername];
	NSArray* filterResult = [people filteredArrayUsingPredicate:filterPredicate];
	return [filterResult lastObject];
	}
	
- (NSArray*)peopleForName:(NSString*)aName
	{
	NSPredicate* filterPredicate = [NSPredicate predicateWithFormat:@"name like %@", aName];
	NSArray* filterResult = [people filteredArrayUsingPredicate:filterPredicate];
	return filterResult;
	}
	
- (NSArray*)peopleForLocation:(NSString*)aLocation
	{
	NSPredicate* filterPredicate = [NSPredicate predicateWithFormat:@"location like %@", aLocation];
	NSArray* filterResult = [people filteredArrayUsingPredicate:filterPredicate];
	return filterResult;
	}

- (NSArray*)peopleForProStatus:(BOOL)theStatus
	{
	NSPredicate* filterPredicate = [NSPredicate predicateWithFormat:@"proStatus == %@", [NSNumber numberWithBool:theStatus]];
	NSArray* filterResult = [people filteredArrayUsingPredicate:filterPredicate];
	return filterResult;
	}

- (NSArray*)people
	{
	return (NSArray*)people;
	}

#pragma mark - Person management methods

- (BOOL)addPerson:(FlickrPerson*)aPerson
	{
	if(![self personForID:aPerson.ID])
		{
		[[self mutableArrayValueForKey:@"people"] addObject:aPerson];
		}
	return YES;
	}

- (BOOL)removePerson:(FlickrPerson*)aPerson
	{
	return YES;
	}

@end
