//
//  FlickrTag.m
//  FlickrKit
//
//  Created by Felix Morgner on 15.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrTag.h"


@implementation FlickrTag

@synthesize ID;
@synthesize author;
@synthesize rawName;
@synthesize name;

- (id)init
	{
	if ((self = [super init]))
		{
		ID = nil;
		author = nil;
		rawName = nil;
		name = nil;
    }
	return self;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
	if ((self = [super init]))
		{
		ID = [[anElement attributeForName:@"ID"] stringValue];
		author = [[anElement attributeForName:@"author"] stringValue];
		rawName = [[anElement attributeForName:@"raw"] stringValue];
		name = [anElement stringValue];
    }
	return self;
	}

- (FlickrTag*)tagWithXMLElement:(NSXMLElement*)anElement
	{
	return [[[FlickrTag alloc] initWithXMLElement:anElement] autorelease];
	}

- (void)dealloc
	{
	[ID release];
	[author release];
	[rawName release];
	[name release];
	[super dealloc];
	}

@end
