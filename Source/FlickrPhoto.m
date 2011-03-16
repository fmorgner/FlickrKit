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
@synthesize description;
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

- (id)initWithXMLElement:(NSXMLElement*)anElement error:(NSError**)error
	{
	if((self = [super init]))
		{
		}
	return self;
	}

- (id)initWithDictionary:(NSDictionary*)aDictionary error:(NSError**)error
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
		self.description = [[[(NSXMLElement*)photoElement nodesForXPath:@"description" error:nil] lastObject] stringValue];

		NSXMLElement* datesElement = [[(NSXMLElement*)photoElement nodesForXPath:@"dates" error:nil] lastObject];
		self.dateTaken = [NSDate dateWithNaturalLanguageString:[[datesElement attributeForName:@"taken"] stringValue]];
		self.datePosted = [NSDate dateWithTimeIntervalSince1970:[[[datesElement attributeForName:@"posted"] stringValue] doubleValue]];
		self.dateLastUpdate = [NSDate dateWithTimeIntervalSince1970:[[[datesElement attributeForName:@"lastupdate"] stringValue] doubleValue]];
		
		NSArray* tagsArray = [(NSXMLElement*)photoElement nodesForXPath:@"tags/tag" error:nil];
		NSMutableArray* parsedTagsArray = [NSMutableArray arrayWithCapacity:[tagsArray count]];
		[tagsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[parsedTagsArray addObject:[FlickrTag tagWithXMLElement:obj]];
		}];
		self.tags = (NSArray*)parsedTagsArray;
		
		self.commentCount = [[[[(NSXMLElement*)photoElement nodesForXPath:@"comments" error:nil] lastObject] stringValue] intValue];
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
