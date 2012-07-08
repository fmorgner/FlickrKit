//
//  FlickrEXIFTag.m
//  FlickrKit
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrEXIFTag.h"


@implementation FlickrEXIFTag

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
  if ((self = [super init]))
		{
		_label = [[anElement attributeForName:@"label"] stringValue];
		_tagspace = [[anElement attributeForName:@"tagspace"] stringValue];
		_tagspaceID = [[[anElement attributeForName:@"tagspaceID"] stringValue] intValue];
		_tag = [[[anElement attributeForName:@"tag"] stringValue] intValue];
		
		_raw = [[[anElement elementsForName:@"raw"] lastObject] stringValue];
		_clean = [[[anElement elementsForName:@"clean"] lastObject] stringValue];
		
		_value = (_clean) ? _clean : _raw;
    }

  return self;
	}

+ (FlickrEXIFTag*)exifTagWithXMLElement:(NSXMLElement*)anElement
	{
	return [[FlickrEXIFTag alloc] initWithXMLElement:anElement];
	}

@end
