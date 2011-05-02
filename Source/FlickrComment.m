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

		
	
		NSMutableString *html = [NSMutableString stringWithCapacity:[rawText length]];

		NSScanner *scanner = [NSScanner scannerWithString:rawText];
		NSString *tempText = nil;

		while (![scanner isAtEnd])
			{
			[scanner scanUpToString:@"<" intoString:&tempText];

			if (tempText != nil)
			[html appendString:tempText];

			[scanner scanUpToString:@">" intoString:NULL];

			if (![scanner isAtEnd])
			[scanner setScanLocation:[scanner scanLocation] + 1];

			tempText = nil;
			}

		self.strippedText = (NSString*)html;
		}
    
	return self;
	}

+ (FlickrComment*)commentWithXMLElement:(NSXMLElement*)anElement
	{
	return [[[FlickrComment alloc] initWithXMLElement:anElement] autorelease];
	}


- (void)dealloc
	{
  [super dealloc];
	}

@end
