//
//  FlickrComment.m
//  FlickrKit
//
//  Created by Felix Morgner on 27.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FKComment.h"


@implementation FKComment

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{	
	if ((self = [super init]))
		{
  	_ID = [[anElement attributeForName:@"id"] stringValue];
		_author = [FKPerson personWithID:[[anElement attributeForName:@"author"] stringValue]];
		_url = [NSURL URLWithString:[[anElement attributeForName:@"permalink"] stringValue]];
		_dateCreated = [NSDate dateWithTimeIntervalSince1970:[[[anElement attributeForName:@"datecreate"] stringValue] integerValue]];
		_rawText = [anElement stringValue];
	
		NSMutableString *html = [NSMutableString stringWithCapacity:[_rawText length]];

		NSScanner *scanner = [NSScanner scannerWithString:_rawText];
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

		_strippedText = (NSString*)html;
		}
    
	return self;
	}

+ (FKComment*)commentWithXMLElement:(NSXMLElement*)anElement
	{
	return [[FKComment alloc] initWithXMLElement:anElement];
	}



@end
