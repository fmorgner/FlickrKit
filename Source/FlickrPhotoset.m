//
//  FlickrSet.m
//  FlickrKit
//
//  Created by Felix Morgner on 23.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPhotoset.h"
#import "FlickrPersonManager.h"
#import "FlickrAsynchronousFetcher.h"
#import "FlickrKitConstants.h"
#import "FlickrAPIResponse.h"

@interface FlickrPhotoset(Private)

- (void)loadSetInformationFromXMLElement:(NSXMLElement*)anElement;
@end

@implementation FlickrPhotoset(Private)

- (void)loadSetInformationFromXMLElement:(NSXMLElement *)anElement
	{
	self.ID = (!ID) ? ID : [[anElement attributeForName:@"id"] stringValue];
	self.title = (!title) ? title : [[[anElement elementsForName:@"title"] lastObject] stringValue];
	
	self.owner = [FlickrPerson personWithID:[[anElement attributeForName:@"owner"] stringValue]];
	self.desc = [[[anElement elementsForName:@"description"] lastObject] stringValue];
	self.primary = [[anElement attributeForName:@"primary"] stringValue];
	self.photoCount = [[[anElement attributeForName:@"photos"] stringValue] intValue];
	}

@end

@implementation FlickrPhotoset

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

+ (FlickrPhotoset*)setWithXMLElement:(NSXMLElement*)anElement
	{
	return [[[FlickrPhotoset alloc] initWithXMLElement:anElement] autorelease];
	}
	
+ (FlickrPhotoset*)setWithID:(NSString*)anID title:(NSString*)atitle
	{
	return [[[FlickrPhotoset alloc] initWithID:anID title:atitle] autorelease];
	}

- (void)dealloc
{
    [super dealloc];
}

@end
