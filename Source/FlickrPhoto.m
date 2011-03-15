//
//  FlickrPhoto.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPhoto.h"


@implementation FlickrPhoto

@synthesize image;
@synthesize pools;
@synthesize tags;
@synthesize sets;
@synthesize comments;
@synthesize commentCount;
@synthesize title;
@synthesize favorites;
@synthesize galleries;
@synthesize ID;
@synthesize license;
@synthesize dateTaken;
@synthesize datePosted;
@synthesize dateLastUpdate;

#pragma mark - Object initialization

- (id)init
	{
	if((self = [super init]))
		{
		}
	return self;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;
	{
	if((self = [super init]))
		{
		}
	return self;
	}

- (id)initWithDictionary:(NSDictionary*)aDictionary;
	{
	if((self = [super init]))
		{
		}
	return self;
	}

- (id)initWithAPIResponse:(FlickrAPIResponse*)aResponse error:(NSError**)error
	{
	if(!aResponse || [aResponse.status isEqualToString:@"fail"])
		return nil;

	if(![[[aResponse.xmlContent rootElement] childAtIndex:0].name isEqualToString:@"photo"])
		return nil;
	
	NSXMLNode* photoElement = [[aResponse.xmlContent rootElement] childAtIndex:0];
	
	if((self = [super init]))
		{
		self.ID = [[(NSXMLElement*)photoElement attributeForName:@"id"] stringValue];
		self.license = [[[(NSXMLElement*)photoElement attributeForName:@"license"] stringValue] intValue];
		self.title = [[[(NSXMLElement*)photoElement nodesForXPath:@"title" error:nil] lastObject] stringValue];
		
		self.dateTaken = [NSDate dateWithNaturalLanguageString:[[[[(NSXMLElement*)photoElement nodesForXPath:@"dates" error:nil] lastObject] attributeForName:@"taken"] stringValue]];
		self.datePosted = [NSDate dateWithTimeIntervalSince1970:[[[[[(NSXMLElement*)photoElement nodesForXPath:@"dates" error:nil] lastObject] attributeForName:@"posted"] stringValue] doubleValue]];
		self.dateLastUpdate = [NSDate dateWithTimeIntervalSince1970:[[[[[(NSXMLElement*)photoElement nodesForXPath:@"dates" error:nil] lastObject] attributeForName:@"lastupdate"] stringValue] doubleValue]];
		}
	return self;
	}

#pragma mark - Convenience allocators

+ (FlickrPhoto*)photo
	{
	return [[[FlickrPhoto alloc] init] autorelease];
	}
	
+ (FlickrPhoto*)photoWithXMLElement:(NSXMLElement*)anElement error:(NSError**)error
	{
	return [[[FlickrPhoto alloc] initWithXMLElement:anElement error:(NSError**)error] autorelease];
	}

+ (FlickrPhoto*)photoWithDictionary:(NSDictionary*)aDictionary error:(NSError**)error
	{
	return [[[FlickrPhoto alloc] initWithDictionary:aDictionary error:(NSError**)error] autorelease];
	}

+ (FlickrPhoto*)photoWithAPIResponse:(FlickrAPIResponse*)aResponse error:(NSError**)error
	{
	return [[[FlickrPhoto alloc] initWithAPIResponse:aResponse error:(NSError**)error] autorelease];
	}

#pragma mark - Object deallocation

- (void)dealloc
	{
	[tags release];
	[image release];
	[pools release];
	[sets release];
	[comments release];
	[title release];
	[favorites release];
	[galleries release];
	[super dealloc];
	}

@end
