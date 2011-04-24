//
//  FlickrPhoto.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPhoto.h"
#import "FlickrAsynchronousFetcher.h"
#import "FlickrAPIResponse.h"
#import "FlickrTag.h"
#import "FlickrLicense.h"
#import "FlickrPerson.h"
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

#pragma mark - Information Fetching
	
- (void)fetchEXIFInformation
	{
	NSString* methodString = [NSString stringWithFormat:FlickrAPIMethodPhotosGetEXIF, ID];
	NSString* urlString = [NSString stringWithFormat:FlickrAPIBaseURL, methodString, APIKey];
	
	NSURL* exifURL = [NSURL URLWithString:urlString];

	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	
	[dataFetcher fetchDataAtURL:exifURL withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSArray* nodes = [[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/photo/exif" error:nil];
			NSMutableArray* fetchedExifTags = [NSMutableArray arrayWithCapacity:[nodes count]];
			for(NSXMLElement* element in nodes)
				{
				[fetchedExifTags addObject:[FlickrEXIFTag exifTagWithXMLElement:element]];
				}
			self.exifTags = fetchedExifTags;
			}
	}];
	}

- (void)fetchImageOfSize:(FlickrImageSize)aSize
	{
	NSString* methodString = [NSString stringWithFormat:FlickrAPIMethodPhotosGetSizes, ID];
	NSString* urlString = [NSString stringWithFormat:FlickrAPIBaseURL, methodString, APIKey];
	
	NSURL* sizeURL = [NSURL URLWithString:urlString];

	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	
	[dataFetcher fetchDataAtURL:sizeURL withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSError* error;
			NSArray* nodes = [[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:[NSString stringWithFormat:@"rsp/sizes/size[@label='%@']", flickrImageSizeString(aSize)] error:&error];
			
			if(error)
				return; // TODO: add more sophisticated error handling
			
			NSURL* imageURL = [NSURL URLWithString:[[[nodes lastObject] attributeForName:@"source"] stringValue]];
			
			[dataFetcher fetchDataAtURL:imageURL withCompletionHandler:^(id fetchResult) {
				if(![fetchResult isKindOfClass:[NSError class]])
					self.image = [[[NSImage alloc] initWithData:fetchResult] autorelease];
			}];
			}
	}];
	}
	
- (void)fetchContexts
	{
	}
	
- (void)fetchComments
	{
	}

- (void)fetchFavorites
	{
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
