//
//  FlickrSet.m
//  FlickrKit
//
//  Created by Felix Morgner on 23.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FKPhotoset.h"
#import "FKPersonManager.h"
#import "FKAPIResponse.h"
#import "FKAPIMethod.h"
#import "FKAuthorizationContext.h"

@interface FKPhotoset()

- (void)parseXMLElement:(NSXMLElement*)anElement;

@end

@implementation FKPhotoset

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
		
		FKAPIMethod* methodGetInfo = [FKAPIMethod methodWithName:FKMethodNamePhotosetGetInfo parameters:@{@"photoset_id" : _ID} authorizationContext:[FKAuthorizationContext sharedContext] error:nil];
		
		[methodGetInfo callWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FKAPIResponse class]] && [[(FKAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSError* error;
				NSXMLElement* photosetElement = [[[(FKAPIResponse*)methodCallResult xml] nodesForXPath:@"rsp/photoset" error:&error] lastObject];
				[self parseXMLElement:photosetElement];
				}
		}];
		
		}

	return self;
	}

+ (FKPhotoset*)setWithXMLElement:(NSXMLElement*)anElement
	{
	return [[FKPhotoset alloc] initWithXMLElement:anElement];
	}
	
+ (FKPhotoset*)setWithID:(NSString*)anID title:(NSString*)atitle
	{
	return [[FKPhotoset alloc] initWithID:anID title:atitle];
	}

- (void)parseXMLElement:(NSXMLElement *)anElement
	{
	self.ID = (!_ID) ? _ID : [[anElement attributeForName:@"id"] stringValue];
	self.title = (!self.title) ? self.title : [[[anElement elementsForName:@"title"] lastObject] stringValue];
	
	self.owner = [FKPerson personWithID:[[anElement attributeForName:@"owner"] stringValue]];
	self.desc = [[[anElement elementsForName:@"description"] lastObject] stringValue];
	self.primary = [[anElement attributeForName:@"primary"] stringValue];
	self.photoCount = [[[anElement attributeForName:@"photos"] stringValue] intValue];
	}

@end
