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

@implementation FlickrPhotoset

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
		_ID = anID;
		_title = aTitle;
		NSURL* url = flickrMethodURL(FlickrAPIMethodPhotosetGetInfo, @{@"photoset_id": _ID}, NO);
		FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
		[dataFetcher fetchDataAtURL:url withCompletionHandler:^(id fetchResult) {
			if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
				{
				NSError* error;
				NSXMLElement* photosetElement = [[[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/photoset" error:&error] lastObject];
				[self loadSetInformationFromXMLElement:photosetElement];
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


@end

@implementation FlickrPhotoset(Private)

- (void)loadSetInformationFromXMLElement:(NSXMLElement *)anElement
	{
	_ID = (!_ID) ? _ID : [[anElement attributeForName:@"id"] stringValue];
	_title = (!_title) ? _title : [[[anElement elementsForName:@"title"] lastObject] stringValue];
	
	_owner = [FlickrPerson personWithID:[[anElement attributeForName:@"owner"] stringValue]];
	_desc = [[[anElement elementsForName:@"description"] lastObject] stringValue];
	_primary = [[anElement attributeForName:@"primary"] stringValue];
	_photoCount = [[[anElement attributeForName:@"photos"] stringValue] intValue];
	}

@end
