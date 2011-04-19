//
//  FlickrEXIFTag.m
//  FlickrKit
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrEXIFTag.h"


@implementation FlickrEXIFTag

@synthesize label, raw, clean, value, tagspace, tag, tagspaceID;

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
  if ((self = [super init]))
		{
		label = [[[anElement attributeForName:@"label"] stringValue] copy];
		tagspace = [[[anElement attributeForName:@"tagspace"] stringValue] copy];
		tagspaceID = [[[anElement attributeForName:@"tagspaceID"] stringValue] intValue];
		tag = [[[anElement attributeForName:@"tag"] stringValue] intValue];
		
		raw = [[[[anElement elementsForName:@"raw"] lastObject] stringValue] copy];
		clean = [[[[anElement elementsForName:@"clean"] lastObject] stringValue] copy];
		
		(clean) ? (self.value = clean) : (self.value = raw);
    }

  return self;
	}

+ (FlickrEXIFTag*)exifTagWithXMLElement:(NSXMLElement*)anElement
	{
	return [[[FlickrEXIFTag alloc] initWithXMLElement:anElement] autorelease];
	}

- (void)dealloc
	{
	[tagspace release];
	[clean release];
	[label release];
	[value release];
	[raw release];
	
	tagspaceID = 0;
	tag = 0;
	
  [super dealloc];
	}

@end