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

- (FlickrPerson*)personForID:(NSString*)anID;
- (FlickrPerson*)personForUsername:(NSString*)anUserame;
- (NSArray*)personsForName:(NSString*)aName;
- (NSArray*)personsForLocation:(NSString*)aLocation;

- (BOOL)addPerson:(FlickrPerson*)aPerson;
- (BOOL)removePerson:(FlickrPerson*)aPerson;
@end
