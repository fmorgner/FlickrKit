//
//  FlickrPerson.m
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPerson.h"
#import "FlickrPersonManager.h"
#import "FlickrKitResourceManager.h"

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
		return searchResult;
		}
	
  if ((self = [super init]))
		{
		[self loadPersonInformationFromXMLElement:anElement];
    }

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
		return searchResult;
		}
	
  if ((self = [super init]))
		{
		loaded = NO;
		self.ID = anID;
		receivedData = [[NSMutableData alloc] init];
		[self fetchPersonInformation];
    }	
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
	[receivedData setLength:0];

	NSString* escapedUserID = [ID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* apiKey = [[FlickrKitResourceManager sharedManager] valueForKey:@"apiKey"];
	NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.people.getInfo&api_key=%@&user_id=%@", apiKey, escapedUserID]];
	[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0] delegate:self];
	}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
	{
	[receivedData appendData:data];
	}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
	{
	NSError* error;
	NSXMLDocument* xmlDocument = [[[NSXMLDocument alloc] initWithData:receivedData options:0 error:&error] autorelease];
	NSXMLElement* personElement = [[xmlDocument nodesForXPath:@"rsp/person" error:&error] lastObject];
	[self loadPersonInformationFromXMLElement:personElement];
	}
@end
