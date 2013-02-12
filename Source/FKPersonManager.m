//
//  FlickrPersonManager.m
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FKPersonManager.h"

@interface FKPersonManager (Private)

- (void)setPeople:(NSMutableArray*)newPeople;

@end

@implementation FKPersonManager (Private)

- (void)setPeople:(NSMutableArray*)newPeople
	{
	if(newPeople != people)
		{
		people = newPeople;
		}
	}

@end

@implementation FKPersonManager

__strong static FKPersonManager* sharedPersonManager = nil;

#pragma mark - Object lifecycle

- (id)init
	{
	if((self = [super init]))
		{
		people = [[NSMutableArray alloc] init];
		}
	return self;
	}


#pragma mark - Singleton implementation

+ (FKPersonManager*)sharedManager
	{
	static dispatch_once_t once = 0;
	dispatch_once(&once, ^{
		sharedPersonManager = [[self alloc] init];
		});
	return sharedPersonManager;
	}

#pragma mark - Search methods

- (FKPerson*)personForID:(NSString*)anID
	{
	NSPredicate* filterPredicate = [NSPredicate predicateWithFormat:@"ID like %@", anID];
	NSArray* filterResult = [people filteredArrayUsingPredicate:filterPredicate];
	return [filterResult lastObject];
	}
	
- (FKPerson*)personForUsername:(NSString*)anUsername
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
	NSPredicate* filterPredicate = [NSPredicate predicateWithFormat:@"proStatus == %@", @(theStatus)];
	NSArray* filterResult = [people filteredArrayUsingPredicate:filterPredicate];
	return filterResult;
	}

- (NSArray*)people
	{
	return (NSArray*)people;
	}

#pragma mark - Person management methods

- (BOOL)addPerson:(FKPerson*)aPerson
	{
	if(![self personForID:aPerson.ID])
		{
		[[self mutableArrayValueForKey:@"people"] addObject:aPerson];
		}
	return YES;
	}

- (BOOL)removePerson:(FKPerson*)aPerson
	{
	return YES;
	}

@end
