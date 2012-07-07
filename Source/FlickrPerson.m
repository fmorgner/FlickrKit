//
//  FlickrPerson.m
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPerson.h"
#import "FlickrPersonManager.h"
#import "FlickrKitConstants.h"
#import "FlickrAsynchronousFetcher.h"
#import "FlickrAPIResponse.h"

@implementation FlickrPerson

- (id)init
	{
  if ((self = [super init]))
		{
    }

  return self;
	}

- (id)initWithCoder:(NSCoder *)aDecoder
	{
  if ((self = [super init]))
		{
		if([aDecoder allowsKeyedCoding])
			{
			_ID = [aDecoder decodeObjectForKey:@"ID"];
			_username = [aDecoder decodeObjectForKey:@"username"];
			_name = [aDecoder decodeObjectForKey:@"name"];
			_location = [aDecoder decodeObjectForKey:@"location"];
			_firstPhotoTaken = [aDecoder decodeObjectForKey:@"firstPhotoTaken"];
			_firstPhotoUploaded = [aDecoder decodeObjectForKey:@"firstPhotoUploaded"];
			_photoCount = [aDecoder decodeIntegerForKey:@"photoCount"];
			_proStatus = [aDecoder decodeBoolForKey:@"proStatus"];
			iconServerID = [aDecoder decodeIntForKey:@"iconServerID"];
			iconFarmID = [aDecoder decodeIntForKey:@"iconFarmID"];
			}
		else
			{
			_ID = [aDecoder decodeObject];
			_username = [aDecoder decodeObject];
			_name = [aDecoder decodeObject];
			_location = [aDecoder decodeObject];
			_firstPhotoTaken = [aDecoder decodeObject];
			_firstPhotoUploaded = [aDecoder decodeObject];
			[aDecoder decodeValueOfObjCType:@encode(NSUInteger) at:&_photoCount];
			[aDecoder decodeValueOfObjCType:@encode(BOOL) at:&_proStatus];
			[aDecoder decodeValueOfObjCType:@encode(short) at:&iconServerID];
			[aDecoder decodeValueOfObjCType:@encode(short) at:&iconFarmID];
			}
    }

  return self;
	}
	
- (void)encodeWithCoder:(NSCoder *)aCoder
	{
	if([aCoder allowsKeyedCoding])
		{
		[aCoder encodeObject:_ID forKey:@"ID"];
		[aCoder encodeObject:_username forKey:@"username"];
		[aCoder encodeObject:_name forKey:@"name"];
		[aCoder encodeObject:_location forKey:@"location"];
		[aCoder encodeObject:_firstPhotoTaken forKey:@"firstPhotoTaken"];
		[aCoder encodeObject:_firstPhotoUploaded forKey:@"firstPhotoUploaded"];
		[aCoder encodeInteger:_photoCount forKey:@"photoCount"];
		[aCoder encodeBool:_proStatus forKey:@"proStatus"];
		[aCoder encodeInt:iconServerID forKey:@"iconServerID"];
		[aCoder encodeInt:iconFarmID forKey:@"iconFarmID"];
		}
	else
		{
		[aCoder encodeObject:_ID];
		[aCoder encodeObject:_username];
		[aCoder encodeObject:_name];
		[aCoder encodeObject:_location];
		[aCoder encodeObject:_firstPhotoTaken];
		[aCoder encodeObject:_firstPhotoUploaded];
		[aCoder encodeValueOfObjCType:@encode(NSUInteger) at:&_photoCount];
		[aCoder encodeValueOfObjCType:@encode(BOOL) at:&_proStatus];
		[aCoder encodeValueOfObjCType:@encode(short) at:&iconServerID];
		[aCoder encodeValueOfObjCType:@encode(short) at:&iconFarmID];
		}
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
	NSString* NSID = [[anElement attributeForName:@"nsid"] stringValue];
	
	FlickrPerson* searchResult = [[FlickrPersonManager sharedManager] personForID:NSID];
	
	if(searchResult)
		{
		return searchResult;
		}
	
  if ((self = [super init]))
		{
		[self loadPersonInformationFromXMLElement:anElement];
    }

	[[FlickrPersonManager sharedManager] addPerson:self];
	return self;
	}
	
+ (FlickrPerson*)personWithXMLElement:(NSXMLElement*)anElement
	{
	return [[FlickrPerson alloc] initWithXMLElement:anElement];
	}

- (id)initWithID:(NSString*)anID
	{
	FlickrPerson* searchResult = [[FlickrPersonManager sharedManager] personForID:anID];
	
	if(searchResult)
		{
		return searchResult;
		}
	
  if ((self = [super init]))
		{
		_ID = anID;
		[self fetchPersonInformation];
    }
	
	[[FlickrPersonManager sharedManager] addPerson:self];
	return self;
	}

+ (FlickrPerson*)personWithID:(NSString*)anID
	{
	return [[FlickrPerson alloc] initWithID:anID];
	}


- (void)loadPersonInformationFromXMLElement:(NSXMLElement*)anElement
	{
	_ID = [[anElement attributeForName:@"nsid"] stringValue];
	_proStatus = [[[anElement attributeForName:@"ispro"] stringValue] boolValue];
	iconServerID = [[[anElement attributeForName:@"iconserver"] stringValue] intValue];
	iconFarmID = [[[anElement attributeForName:@"iconfarm"] stringValue] intValue];
	
	_username =  [[[anElement elementsForName:@"username"] lastObject] stringValue];
	_name =  [[[anElement elementsForName:@"realname"] lastObject] stringValue];
	
	NSXMLElement* photosElement = [[anElement elementsForName:@"photos"] lastObject];
	_firstPhotoTaken = [NSDate dateWithString:[[[photosElement elementsForName:@"firstdatetaken"] lastObject] stringValue]];
	_firstPhotoUploaded = [NSDate dateWithTimeIntervalSince1970:[[[[photosElement elementsForName:@"firstdatetaken"] lastObject] stringValue] intValue]];
	_photoCount = [[[[photosElement elementsForName:@"count"] lastObject] stringValue] integerValue];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FlickrPersonLoadingDidFinishNotification object:self];
	}

- (void)fetchPersonInformation
	{
	NSString* escapedUserID = [_ID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL* informationURL = flickrMethodURL(@"flickr.people.getInfo", @{@"user_id": escapedUserID}, NO);
	
	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	[dataFetcher fetchDataAtURL:informationURL withCompletionHandler:^(id fetchResult) {
			if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
				{
				NSError* error;
				NSXMLDocument* xmlDocument = [fetchResult xmlContent];
				NSXMLElement* personElement = [[xmlDocument nodesForXPath:@"rsp/person" error:&error] lastObject];
				
				if(error)
					return; // TODO: add more sophisticated error handling
					
				[self loadPersonInformationFromXMLElement:personElement];
				}
	}];
	}

@end
