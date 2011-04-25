//
//  FlickrSet.m
//  FlickrKit
//
//  Created by Felix Morgner on 23.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrSet.h"
#import "FlickrPersonManager.h"

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
		self.ID = [[anElement attributeForName:@"id"] stringValue];
		self.title = [[[anElement elementsForName:@"title"] lastObject] stringValue];
		self.owner = [FlickrPerson personWithID:[[anElement attributeForName:@"author"] stringValue]];
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
