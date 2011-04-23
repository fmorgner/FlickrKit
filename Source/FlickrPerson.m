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

@synthesize ID;
@synthesize username;
@synthesize name;
@synthesize location;
@synthesize firstPhotoTaken;
@synthesize firstPhotoUploaded;
@synthesize photoCount;
@synthesize proStatus;
@synthesize loaded;

- (id)init
	{
  if ((self = [super init]))
		{
    }

  return self;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
	NSString* NSID = [[anElement attributeForName:@"nsid"] stringValue];
	
	FlickrPerson* searchResult = [[FlickrPersonManager sharedManager] personForID:NSID];
	
	if(searchResult)
		{
		return [searchResult retain];
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
	return [[[FlickrPerson alloc] initWithXMLElement:anElement] autorelease];
	}

- (id)initWithID:(NSString*)anID
	{
	FlickrPerson* searchResult = [[FlickrPersonManager sharedManager] personForID:anID];
	
	if(searchResult)
		{
		return [searchResult retain];
		}
	
  if ((self = [super init]))
		{
		loaded = NO;
		self.ID = anID;
		receivedData = [[NSMutableData alloc] init];
		[self fetchPersonInformation];
    }
	
	[[FlickrPersonManager sharedManager] addPerson:self];
	return self;
	}

+ (FlickrPerson*)personWithID:(NSString*)anID
	{
	return [[[FlickrPerson alloc] initWithID:anID] autorelease];
	}

- (void)dealloc
	{
	[ID release];
	[username release];
	[name release];
	[location release];
	[firstPhotoTaken release];
	[firstPhotoUploaded release];
	[receivedData release];
  [super dealloc];
	}

- (void)loadPersonInformationFromXMLElement:(NSXMLElement*)anElement
	{
	self.ID = [[anElement attributeForName:@"nsid"] stringValue];
	self.proStatus = [[[anElement attributeForName:@"ispro"] stringValue] boolValue];
	iconServerID = [[[anElement attributeForName:@"iconserver"] stringValue] intValue];
	iconFarmID = [[[anElement attributeForName:@"iconfarm"] stringValue] intValue];
	
	self.username =  [[[anElement elementsForName:@"username"] lastObject] stringValue];
	self.name =  [[[anElement elementsForName:@"realname"] lastObject] stringValue];
	
	NSXMLElement* photosElement = [[anElement elementsForName:@"photos"] lastObject];
	self.firstPhotoTaken = [NSDate dateWithString:[[[photosElement elementsForName:@"firstdatetaken"] lastObject] stringValue]];
	self.firstPhotoUploaded = [NSDate dateWithTimeIntervalSince1970:[[[[photosElement elementsForName:@"firstdatetaken"] lastObject] stringValue] intValue]];
	
	loaded = YES;
	}

- (void)fetchPersonInformation
	{
	NSString* escapedUserID = [ID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* methodString = [NSString stringWithFormat:FlickrAPIMethodPeopleGetInfo, escapedUserID];
	NSString* urlString = [NSString stringWithFormat:FlickrAPIBaseURL, methodString, APIKey];
	
	NSURL* informationURL = [NSURL URLWithString:urlString];
	
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
