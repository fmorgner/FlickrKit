//
//  FlickrSet.m
//  FlickrKit
//
//  Created by Felix Morgner on 23.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPhotoset.h"
#import "FlickrPersonManager.h"
#import "FlickrAPIResponse.h"
#import "FlickrAPIMethodCall.h"
#import "FlickrAPIMethod.h"
#import "FlickrAuthorizationContext.h"

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
		
		FlickrAPIMethod* methodGetInfo = [FlickrAPIMethod methodWithName:FlickrAPIMethodPhotosetGetInfo andParameters:@{@"photoset_id" : _ID} error:nil];
		FlickrAPIMethodCall* methodCall = [FlickrAPIMethodCall methodCallWithAuthorizationContext:[FlickrAuthorizationContext sharedContext] method:methodGetInfo];
		
		[methodCall dispatchWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSError* error;
				NSXMLElement* photosetElement = [[[(FlickrAPIResponse*)methodCallResult xmlContent] nodesForXPath:@"rsp/photoset" error:&error] lastObject];
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
