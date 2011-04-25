//
//  FlickrSet.m
//  FlickrKit
//
//  Created by Felix Morgner on 23.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrSet.h"
#import "FlickrPersonManager.h"
#import "FlickrAsynchronousFetcher.h"
#import "FlickrKitConstants.h"
#import "FlickrAPIResponse.h"

@interface FlickrSet(Private)

- (void)loadSetInformationFromXMLElement:(NSXMLElement*)anElement;
@end

@implementation FlickrSet(Private)

- (void)loadSetInformationFromXMLElement:(NSXMLElement *)anElement
	{
	self.ID = (!ID) ? ID : [[anElement attributeForName:@"id"] stringValue];
	self.title = (!title) ? title : [[[anElement elementsForName:@"title"] lastObject] stringValue];
	
	self.owner = [FlickrPerson personWithID:[[anElement attributeForName:@"author"] stringValue]];
	self.desc = [[[anElement elementsForName:@"description"] lastObject] stringValue];
	self.primary = [[anElement attributeForName:@"primary"] stringValue];
	self.photoCount = [[[anElement attributeForName:@"photos"] stringValue] intValue];
	}

@end

@implementation FlickrSet

@synthesize ID;
@synthesize primary;
@synthesize title;
@synthesize desc;
@synthesize owner;
@synthesize photoCount;

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
	if ((self = [super init]))
		{
		[self loadSetInformationFromXMLElement:anElement];
    }
	return self;
	}

- (id)initWithID:(NSString*)anID title:(NSString*)aTitle
	{
	if((self = [super init]))
		{
		self.ID = anID;
		self.title = aTitle;
		}

	NSURL* url = flickrMethodURL(FlickrAPIMethodPhotosetGetInfo, [NSDictionary dictionaryWithObject:ID forKey:@"photoset_id"], NO);
	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	[dataFetcher fetchDataAtURL:url withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSError* error;
			NSXMLElement* photosetElement = [[[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/photoset" error:&error] lastObject];
			[self loadSetInformationFromXMLElement:photosetElement];
			}

	}];

	return self;
	}

+ (FlickrSet*)setWithXMLElement:(NSXMLElement*)anElement
	{
	return [[[FlickrSet alloc] initWithXMLElement:anElement] autorelease];
	}
	
+ (FlickrSet*)setWithID:(NSString*)anID title:(NSString*)atitle
	{
	return [[[FlickrSet alloc] initWithID:anID title:atitle] autorelease];
	}

- (void)dealloc
{
    [super dealloc];
}

@end
