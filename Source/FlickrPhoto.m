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
#import "FlickrPhotoset.h"
#import "FlickrComment.h"

@interface FlickrPhoto(Private)

- (void)parseXMLElement:(NSXMLElement*)anElement;

@end

@implementation FlickrPhoto

#pragma mark - Object initialization

- (id)init
	{
	if((self = [super init]))
		{
		}
	return self;
	}

- (id)initWithID:(NSString *)anID
	{
	if((self = [super init]))
		{
		_ID = anID;
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

- (id)initWithAPIResponse:(FlickrAPIResponse*)aResponse error:(NSError**)error
	{
	if(!aResponse || [aResponse.status isEqualToString:@"fail"])
		return nil;

	if(![[[aResponse.xmlContent rootElement] childAtIndex:0].name isEqualToString:@"photo"])
		return nil;
	
	NSXMLElement* photoElement = (NSXMLElement*)[[aResponse.xmlContent rootElement] childAtIndex:0];
	
	if((self = [super init]))
		{
		[self parseXMLElement:photoElement];
		}
	
	return self;
	}

#pragma mark - Convenience allocators

+ (FlickrPhoto*)photo
	{
	return [[FlickrPhoto alloc] init];
	}
	
+ (FlickrPhoto*)photoWithXMLElement:(NSXMLElement*)anElement error:(NSError**)error
	{
	return [[FlickrPhoto alloc] initWithXMLElement:anElement error:(NSError**)error];
	}

+ (FlickrPhoto*)photoWithAPIResponse:(FlickrAPIResponse*)aResponse error:(NSError**)error
	{
	return [[FlickrPhoto alloc] initWithAPIResponse:aResponse error:(NSError**)error];
	}

+ (FlickrPhoto*)photoWithID:(NSString*)anID
	{
	return [[FlickrPhoto alloc] initWithID:anID];
	}

#pragma mark - Information Fetching

- (void)fetchInformation:(unsigned int)anInformationMask
	{
	if(anInformationMask & kFlickrPhotoInformationEXIF)
		[self fetchEXIFInformation];
		
	if(anInformationMask & kFlickrPhotoInformationContexts)
		[self fetchContexts];
		
	if(anInformationMask & kFlickrPhotoInformationComments)
		[self fetchComments];

	if(anInformationMask & kFlickrPhotoInformationFavorites)
		[self fetchFavorites];
		
	if(anInformationMask & kFlickrPhotoInformationGeneral)
		[self fetchGeneralInformation];
	}	

- (void)fetchEXIFInformation
	{
	NSURL* url = flickrMethodURL(FlickrAPIMethodPhotosGetEXIF, @{@"photo_id": _ID}, NO);

	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	[dataFetcher fetchDataAtURL:url withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSArray* nodes = [[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/photo/exif" error:nil];
			NSMutableArray* fetchedExifTags = [NSMutableArray arrayWithCapacity:[nodes count]];
			for(NSXMLElement* element in nodes)
				{
				[fetchedExifTags addObject:[FlickrEXIFTag exifTagWithXMLElement:element]];
				}
			_exifTags = fetchedExifTags;
			}
	}];
	}

- (void)fetchImageOfSize:(FlickrImageSize)aSize
	{
	NSURL* url = flickrMethodURL(FlickrAPIMethodPhotosGetSizes, @{@"photo_id": _ID}, NO);

	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	[dataFetcher fetchDataAtURL:url withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSError* error;
			NSArray* nodes = [[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:[NSString stringWithFormat:@"rsp/sizes/size[@label='%@']", flickrImageSizeString(aSize)] error:&error];
			
			if(error)
				return; // TODO: add more sophisticated error handling
			
			NSURL* imageURL = [NSURL URLWithString:[[[nodes lastObject] attributeForName:@"source"] stringValue]];
			
			FlickrAsynchronousFetcher* imageFetcher = [FlickrAsynchronousFetcher new];
			[imageFetcher fetchDataAtURL:imageURL withCompletionHandler:^(id fetchResult)
				{
				if(![fetchResult isKindOfClass:[NSError class]])
					_image = [[NSImage alloc] initWithData:fetchResult];
			}];
			}
	}];
	}
	
- (void)fetchContexts
	{
	NSURL* url = flickrMethodURL(FlickrAPIMethodPhotosGetAllContexts, @{@"photo_id": _ID}, NO);

	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	[dataFetcher fetchDataAtURL:url withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSArray* setNodes = [[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/set" error:nil];

			NSMutableArray* setArray = [NSMutableArray arrayWithCapacity:[setNodes count]];
			for(NSXMLElement* element in setNodes)
				{
				[setArray addObject:[FlickrPhotoset setWithID:[[element attributeForName:@"id"] stringValue] title:[[element attributeForName:@"title"] stringValue]]];
				}
			_photosets = setArray;

			NSArray* poolNodes = [[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/pool" error:nil];

			NSMutableArray* poolArray = [NSMutableArray arrayWithCapacity:[setNodes count]];
			for(NSXMLElement* element in poolNodes)
				{
				[poolArray addObject:[[element attributeForName:@"title"] stringValue]];
				}
			_pools = poolArray;
			}
	}];
	}
	
- (void)fetchComments
	{
	NSURL* url = flickrMethodURL(FlickrAPIMethodPhotosCommentsGetList, @{@"photo_id": _ID}, NO);

	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	[dataFetcher fetchDataAtURL:url withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSArray* nodes = [[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/comments/comment" error:nil];
			NSMutableArray* commentsArray = [NSMutableArray arrayWithCapacity:[nodes count]];
			for(NSXMLElement* element in nodes)
				{
				[commentsArray addObject:[FlickrComment commentWithXMLElement:element]];
				}
			_comments = commentsArray;
			}
	}];
	}

- (void)fetchFavorites
	{
	NSURL* url = flickrMethodURL(FlickrAPIMethodPhotosGetFavorites, @{@"photo_id": _ID}, NO);
	
	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	[dataFetcher fetchDataAtURL:url withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSError* error;
			NSArray* personArray = [[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/photo/person" error:&error];
			
			if(error)
				return; // TODO: Add more sophisticated error handling
			
			NSMutableArray* favoriteArray = [NSMutableArray arrayWithCapacity:[personArray count]];
			
			for(NSXMLElement* element in personArray)
				{
				NSString* personID = [[element attributeForName:@"nsid"] stringValue];
				[favoriteArray addObject:[FlickrPerson personWithID:personID]];
				}
			
			_favorites = favoriteArray;
			}

	}];
	}

- (void)fetchGeneralInformation
	{
	NSURL* url = flickrMethodURL(FlickrAPIMethodPhotosGetInfo, @{@"photo_id": _ID}, NO);
	
	FlickrAsynchronousFetcher* dataFetcher = [FlickrAsynchronousFetcher new];
	[dataFetcher fetchDataAtURL:url withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSXMLElement* photoElement = (NSXMLElement*)[[[(FlickrAPIResponse*)fetchResult xmlContent] rootElement] childAtIndex:0];

			[self parseXMLElement:photoElement];
			}
	}];
	}

#pragma mark - Object deallocation


@end

#pragma mark - Image size helper functions

NSString* flickrImageSizeString(FlickrImageSize size)
	{
	NSString* returnString = nil;

	switch (size)
		{
  case kFlickrImageSizeSquare:
		returnString = @"Square";    
    break;
  case kFlickrImageSizeThumbnail:
		returnString = @"Thumbnail";    
    break;
  case kFlickrImageSizeSmall:
		returnString = @"Small";    
    break;
  case kFlickrImageSizeMedium:
		returnString = @"Medium";    
    break;
  case kFlickrImageSizeMedium640:
		returnString = @"Medium 640";    
    break;
  case kFlickrImageSizeLarge:
		returnString = @"Large";    
    break;
  case kFlickrImageSizeOriginal:
		returnString = @"Original";    
    break;
  default:
    break;
		}
	
	return returnString;
	}

NSString* flickrImageSizeLocalizedString(FlickrImageSize size)
	{
	NSString* returnString = nil;
	
	switch (size)
		{
  case kFlickrImageSizeSquare:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeSquare", @"FlickrImageSize", KitBundle, @"The square size");
    break;
  case kFlickrImageSizeThumbnail:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeThumbnail", @"FlickrImageSize", KitBundle, @"The thumbnail size");    
    break;
  case kFlickrImageSizeSmall:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeSmall", @"FlickrImageSize", KitBundle, @"The small size");    
    break;
  case kFlickrImageSizeMedium:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeMedium", @"FlickrImageSize", KitBundle, @"The medium size");    
    break;
  case kFlickrImageSizeMedium640:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeMedium640", @"FlickrImageSize", KitBundle, @"The medium 640 size");    
    break;
  case kFlickrImageSizeLarge:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeLarge", @"FlickrImageSize", KitBundle, @"The large size");    
    break;
  case kFlickrImageSizeOriginal:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeOriginal", @"FlickrImageSize", KitBundle, @"The original size");    
    break;
  default:
    break;
		}
	
	return returnString;
	}

@implementation FlickrPhoto(Private)

- (void)parseXMLElement:(NSXMLElement*)anElement
	{
	if(!anElement)
		return;
	
	_ID = [[(NSXMLElement*)anElement attributeForName:@"id"] stringValue];
	_title = [[[(NSXMLElement*)anElement nodesForXPath:@"title" error:nil] lastObject] stringValue];
	_description = [[[(NSXMLElement*)anElement nodesForXPath:@"description" error:nil] lastObject] stringValue];

	_commentCount = [[[[(NSXMLElement*)anElement nodesForXPath:@"comments" error:nil] lastObject] stringValue] intValue];
	_license = [FlickrLicense licenseWithCode:[[[(NSXMLElement*)anElement attributeForName:@"license"] stringValue] intValue]];

	NSXMLElement* ownerElement = [[anElement nodesForXPath:@"owner" error:nil] lastObject];
	_owner = [FlickrPerson personWithID:[[ownerElement attributeForName:@"nsid"] stringValue]];

	NSXMLElement* datesElement = [[anElement nodesForXPath:@"dates" error:nil] lastObject];
	_dateTaken = [NSDate dateWithNaturalLanguageString:[[datesElement attributeForName:@"taken"] stringValue]];
	_datePosted = [NSDate dateWithTimeIntervalSince1970:[[[datesElement attributeForName:@"posted"] stringValue] doubleValue]];
	_dateLastUpdate = [NSDate dateWithTimeIntervalSince1970:[[[datesElement attributeForName:@"lastupdate"] stringValue] doubleValue]];
	
	NSArray* tagsArray = [(NSXMLElement*)anElement nodesForXPath:@"tags/tag" error:nil];
	NSMutableArray* parsedTagsArray = [NSMutableArray arrayWithCapacity:[tagsArray count]];
	[tagsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[parsedTagsArray addObject:[FlickrTag tagWithXMLElement:obj]];
	}];
	_tags = (NSArray*)parsedTagsArray;
	
	NSArray* urlsArray = [(NSXMLElement*)anElement nodesForXPath:@"urls/url" error:nil];
	NSMutableDictionary* urlsDictionary = [NSMutableDictionary dictionaryWithCapacity:[urlsArray count]];
	[urlsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[urlsDictionary setObject:[NSURL URLWithString:[obj stringValue]] forKey:[[obj attributeForName:@"type"] stringValue]];
	}];
	_URLs = (NSDictionary*)urlsDictionary;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FlickrPhotoDidChangeNotification object:self];
	}

@end
