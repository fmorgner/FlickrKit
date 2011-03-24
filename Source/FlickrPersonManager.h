//
//  FlickrPersonManager.h
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPerson.h"

@interface FlickrPersonManager : NSObject
	{
	@private
	NSMutableArray* persons;
	}

+ (FlickrPersonManager*)sharedManager;

- (FlickrPerson*)personForID:(NSString*)anID;
- (FlickrPerson*)personForUsername:(NSString*)anUserame;
- (NSArray*)peopleForName:(NSString*)aName;
- (NSArray*)peopleForLocation:(NSString*)aLocation;
- (NSArray*)peopleForProStatus:(BOOL)theStatus;


- (BOOL)addPerson:(FlickrPerson*)aPerson;
- (BOOL)removePerson:(FlickrPerson*)aPerson;
@end
