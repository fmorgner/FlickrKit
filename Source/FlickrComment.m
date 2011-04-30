//
//  FlickrComment.m
//  FlickrKit
//
//  Created by Felix Morgner on 27.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrComment.h"


@implementation FlickrComment

@synthesize ID, url, author, rawText, dateCreated, strippedText;

- (id)init
	{	
	if ((self = [super init]))
		{
  	
		}
    
	return self;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{	
	if ((self = [super init]))
		{
  	self.ID = [[anElement attributeForName:@"id"] stringValue];
		self.author = [FlickrPerson personWithID:[[anElement attributeForName:@"author"] stringValue]];
		self.url = [NSURL URLWithString:[[anElement attributeForName:@"permalink"] stringValue]];
		self.dateCreated = [NSDate dateWithTimeIntervalSince1970:[[[anElement attributeForName:@"datecreate"] stringValue] integerValue]];
		self.rawText = [anElement stringValue];
		
		NSRange r;
		NSString* stripped = [[rawText copy] autorelease];
		while ((r = [stripped rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    		stripped = [stripped stringByReplacingCharactersInRange:r withString:@""];
		
		self.strippedText = stripped;
		}
    
	return self;
	}

- (FlickrComment*)commentWithXMLElement:(NSXMLElement*)anElement
	{
	return [[[FlickrComment alloc] initWithXMLElement:anElement] autorelease];
	}


- (void)dealloc
	{
  [super dealloc];
	}

@end
