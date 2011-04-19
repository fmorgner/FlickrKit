//
//  FlickrPhoto.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPhoto.h"
#import "FlickrAsynchronousFetcher.h"
#import "FlickrKitConstants.h"
#import "FlickrEXIFTag.h"

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
@synthesize exifTags;
@synthesize ID;
@synthesize license;
@synthesize dateTaken;
@synthesize datePosted;
@synthesize dateLastUpdate;
@synthesize URLs;
@synthesize owner;

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
	
	NSXMLElement* photoElement = (NSXMLElement*)[[aResponse.xmlContent rootElement] childAtIndex:0];
	
	if((self = [super init]))
		{
		self.ID = [[(NSXMLElement*)photoElement attributeForName:@"id"] stringValue];
		self.title = [[[(NSXMLElement*)photoElement nodesForXPath:@"title" error:nil] lastObject] stringValue];
		self.description = [[[(NSXMLElement*)photoElement nodesForXPath:@"description" error:nil] lastObject] stringValue];

		self.commentCount = [[[[(NSXMLElement*)photoElement nodesForXPath:@"comments" error:nil] lastObject] stringValue] intValue];
		self.license = [FlickrLicense licenseWithCode:[[[(NSXMLElement*)photoElement attributeForName:@"license"] stringValue] intValue]];

		NSXMLElement* ownerElement = [[photoElement nodesForXPath:@"owner" error:nil] lastObject];
		self.owner = [FlickrPerson personWithID:[[ownerElement attributeForName:@"nsid"] stringValue]];

		NSXMLElement* datesElement = [[photoElement nodesForXPath:@"dates" error:nil] lastObject];
		self.dateTaken = [NSDate dateWithNaturalLanguageString:[[datesElement attributeForName:@"taken"] stringValue]];
		self.datePosted = [NSDate dateWithTimeIntervalSince1970:[[[datesElement attributeForName:@"posted"] stringValue] doubleValue]];
		self.dateLastUpdate = [NSDate dateWithTimeIntervalSince1970:[[[datesElement attributeForName:@"lastupdate"] stringValue] doubleValue]];
		
		NSArray* tagsArray = [(NSXMLElement*)photoElement nodesForXPath:@"tags/tag" error:nil];
		NSMutableArray* parsedTagsArray = [NSMutableArray arrayWithCapacity:[tagsArray count]];
		[tagsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[parsedTagsArray addObject:[FlickrTag tagWithXMLElement:obj]];
		}];
		self.tags = (NSArray*)parsedTagsArray;
		
		NSArray* urlsArray = [(NSXMLElement*)photoElement nodesForXPath:@"urls/url" error:nil];
		NSMutableDictionary* urlsDictionary = [NSMutableDictionary dictionaryWithCapacity:[urlsArray count]];
		[urlsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[urlsDictionary setObject:[NSURL URLWithString:[obj stringValue]] forKey:[[obj attributeForName:@"type"] stringValue]];
		}];
		self.URLs = (NSDictionary*)urlsDictionary;
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

#pragma mark - Instance Methods
	
- (void)fetchEXIFInformation
	{
	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	NSString* methodString = [NSString stringWithFormat:FlickrAPIMethodPhotosGetEXIF, ID];
	NSString* urlString = [NSString stringWithFormat:FlickrAPIBaseURL, methodString, [[NSApp delegate] apiKey]];
	NSURL* exifURL = [NSURL URLWithString:urlString];
	[dataFetcher fetchDataAtURL:exifURL withCompletionHandler:^(NSData *fetchedData) {
		FlickrAPIResponse* response = [FlickrAPIResponse responseWithData:fetchedData];
		if([response.status isEqualToString:@"ok"])
			{
			NSXMLDocument* xmlDocument = [response xmlContent];
			NSArray* nodes = [xmlDocument nodesForXPath:@"rsp/photo/exif" error:nil];
			NSMutableArray* fetchedExifTags = [NSMutableArray arrayWithCapacity:[nodes count]];
			for(NSXMLElement* element in nodes)
				{
				[fetchedExifTags addObject:[FlickrEXIFTag exifTagWithXMLElement:element]];
				}
			self.exifTags = fetchedExifTags;
			}
	}];
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
	[URLs release];
	[owner release];
	[super dealloc];
	}

@end
