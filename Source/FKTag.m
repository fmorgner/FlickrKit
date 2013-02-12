//
//  FlickrTag.m
//  FlickrKit
//
//  Created by Felix Morgner on 15.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FKTag.h"

@implementation FKTag

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
	if ((self = [super init]))
		{
		_ID = [[anElement attributeForName:@"id"] stringValue];
		_rawName = [[anElement attributeForName:@"raw"] stringValue];
		_name = [anElement stringValue];

		FKPerson* searchResult = [[FKPersonManager sharedManager] personForID:[[anElement attributeForName:@"author"] stringValue]];
		
		if (searchResult)
			{
			_author = searchResult;
  		}
		else
			{
			_author = [FKPerson personWithID:[[anElement attributeForName:@"author"] stringValue]];
			[[FKPersonManager sharedManager] addPerson:_author];
			}
		
    }
	return self;
	}

+ (FKTag*)tagWithXMLElement:(NSXMLElement*)anElement
	{
	return [[FKTag alloc] initWithXMLElement:anElement];
	}


@end
