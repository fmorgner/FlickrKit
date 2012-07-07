//
//  FlickrTag.m
//  FlickrKit
//
//  Created by Felix Morgner on 15.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrTag.h"

@implementation FlickrTag

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
	if ((self = [super init]))
		{
		_ID = [[anElement attributeForName:@"id"] stringValue];
		_rawName = [[anElement attributeForName:@"raw"] stringValue];
		_name = [anElement stringValue];

		FlickrPerson* searchResult = [[FlickrPersonManager sharedManager] personForID:[[anElement attributeForName:@"author"] stringValue]];
		
		if (searchResult)
			{
			_author = searchResult;
  		}
		else
			{
			_author = [FlickrPerson personWithID:[[anElement attributeForName:@"author"] stringValue]];
			[[FlickrPersonManager sharedManager] addPerson:_author];
			}
		
    }
	return self;
	}

+ (FlickrTag*)tagWithXMLElement:(NSXMLElement*)anElement
	{
	return [[FlickrTag alloc] initWithXMLElement:anElement];
	}


@end
