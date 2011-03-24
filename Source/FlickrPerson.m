//
//  FlickrPerson.m
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPerson.h"


@implementation FlickrPerson

@synthesize ID;
@synthesize username;
@synthesize name;
@synthesize location;
@synthesize firstPhotoTaken;
@synthesize firstPhotoUploaded;
@synthesize photoCount;
@synthesize proStatus;

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
		self.ID =  [[anElement attributeForName:@"nsid"] stringValue];
		self.proStatus = [[[anElement attributeForName:@"ispro"] stringValue] boolValue];
		iconServerID = [[[anElement attributeForName:@"iconserver"] stringValue] intValue];
		iconFarmID = [[[anElement attributeForName:@"iconfarm"] stringValue] intValue];
		
		self.username =  [[[anElement elementsForName:@"username"] lastObject] stringValue];
		self.name =  [[[anElement elementsForName:@"realname"] lastObject] stringValue];
		
		NSXMLElement* photosElement = [[anElement elementsForName:@"photos"] lastObject];
		self.firstPhotoTaken = [NSDate dateWithString:[[[photosElement elementsForName:@"firstdatetaken"] lastObject] stringValue]];
		self.firstPhotoUploaded = [NSDate dateWithTimeIntervalSince1970:[[[[photosElement elementsForName:@"firstdatetaken"] lastObject] stringValue] intValue]];
    }

	return self;
	}
	
+ (FlickrPerson*)personWithXMLElement:(NSXMLElement*)anElement
	{
	return [[[FlickrPerson alloc] initWithXMLElement:anElement] autorelease];
	}

- (void)dealloc
	{
  [super dealloc];
	}

@end
