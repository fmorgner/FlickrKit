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
#import "FlickrAPIMethodCall.h"

@interface FlickrPhotoset()

- (void)parseXMLElement:(NSXMLElement*)anElement;

@end

@implementation FlickrPhotoset

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
	if ((self = [super init]))
		{
		[self parseXMLElement:anElement];
    }
	return self;
	}

- (id)initWithID:(NSString*)anID title:(NSString*)aTitle
	{
	if((self = [super init]))
		{
		_ID = anID;
		_title = aTitle;

		NSURL* url = flickrMethodURL(FlickrAPIMethodPhotosetGetInfo, @{@"photoset_id": _ID}, NO);
		FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
		[dataFetcher fetchDataAtURL:url withCompletionHandler:^(id fetchResult) {
			if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
				{
				NSError* error;
				NSXMLElement* photosetElement = [[[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/photoset" error:&error] lastObject];
				[self parseXMLElement:photosetElement];
				}
		}];
		}

	return self;
	}

+ (FlickrPhotoset*)setWithXMLElement:(NSXMLElement*)anElement
	{
	return [[FlickrPhotoset alloc] initWithXMLElement:anElement];
	}
	
+ (FlickrPhotoset*)setWithID:(NSString*)anID title:(NSString*)atitle
	{
	return [[FlickrPhotoset alloc] initWithID:anID title:atitle];
	}

- (void)parseXMLElement:(NSXMLElement *)anElement
	{
	self.ID = (!_ID) ? _ID : [[anElement attributeForName:@"id"] stringValue];
	self.title = (!self.title) ? self.title : [[[anElement elementsForName:@"title"] lastObject] stringValue];
	
	self.owner = [FlickrPerson personWithID:[[anElement attributeForName:@"owner"] stringValue]];
	self.desc = [[[anElement elementsForName:@"description"] lastObject] stringValue];
	self.primary = [[anElement attributeForName:@"primary"] stringValue];
	self.photoCount = [[[anElement attributeForName:@"photos"] stringValue] intValue];
	}

@end
