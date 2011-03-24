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
		self.ID = nil;
		self.author = nil;
		self.rawName = nil;
		self.name = nil;
    }
	return self;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
	if ((self = [super init]))
		{
		self.ID = [[anElement attributeForName:@"id"] stringValue];
		self.rawName = [[anElement attributeForName:@"raw"] stringValue];
		self.name = [anElement stringValue];

		personManager = [FlickrPersonManager sharedManager];
		FlickrPerson* searchResult = [personManager personForID:[[anElement attributeForName:@"author"] stringValue]];
		
		if (searchResult)
			{
			self.author = searchResult;
  		}
		else
			{
			self.author = [FlickrPerson personWithID:[[anElement attributeForName:@"author"] stringValue]];
			[personManager addPerson:self.author];
			}
		
    }
	return self;
	}

+ (FlickrTag*)tagWithXMLElement:(NSXMLElement*)anElement
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
