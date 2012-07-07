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
		_label = [[[anElement attributeForName:@"label"] stringValue] copy];
		_tagspace = [[[anElement attributeForName:@"tagspace"] stringValue] copy];
		_tagspaceID = [[[anElement attributeForName:@"tagspaceID"] stringValue] intValue];
		_tag = [[[anElement attributeForName:@"tag"] stringValue] intValue];
		
		_raw = [[[[anElement elementsForName:@"raw"] lastObject] stringValue] copy];
		_clean = [[[[anElement elementsForName:@"clean"] lastObject] stringValue] copy];
		
		(_clean) ? (_value = _clean) : (_value = _raw);
    }

  return self;
	}

+ (FlickrEXIFTag*)exifTagWithXMLElement:(NSXMLElement*)anElement
	{
	return [[FlickrEXIFTag alloc] initWithXMLElement:anElement];
	}

- (void)dealloc
	{
	
	_tagspaceID = 0;
	_tag = 0;
	
	}

@end
