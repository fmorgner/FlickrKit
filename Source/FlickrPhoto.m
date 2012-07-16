//
//  FlickrPhoto.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrPhoto.h"
#import "FlickrTag.h"
#import "FlickrLicense.h"
#import "FlickrPerson.h"
#import "FlickrEXIFTag.h"
#import "FlickrPhotoset.h"
#import "FlickrComment.h"

#import "FlickrAuthorizationContext.h"
#import "FlickrAPIMethod.h"
#import "FlickrAPIMethodCall.h"
#import "FlickrAPIResponse.h"

@interface FlickrPhoto()

- (void)parseXMLElement:(NSXMLElement*)anElement;

@property(strong) NSMutableData* imageData;

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
		[self parseXMLElement:anElement];
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
	FlickrAPIMethod* methodGetExif = [FlickrAPIMethod methodWithName:FlickrAPIMethodPhotosGetEXIF andParameters:@{@"photo_id" : _ID} error:nil];
	
	if(methodGetExif)
		{
		FlickrAPIMethodCall* methodCall = [FlickrAPIMethodCall methodCallWithAuthorizationContext:[FlickrAuthorizationContext sharedContext] method:methodGetExif];
		[methodCall dispatchWithCompletionHandler:^(id methodCallResult) {
		if([methodCallResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
			{
			NSArray* nodes = [[(FlickrAPIResponse*)methodCallResult xmlContent] nodesForXPath:@"rsp/photo/exif" error:nil];
			NSMutableArray* fetchedExifTags = [NSMutableArray arrayWithCapacity:[nodes count]];
			for(NSXMLElement* element in nodes)
				{
				[fetchedExifTags addObject:[FlickrEXIFTag exifTagWithXMLElement:element]];
				}
			self.exifTags = fetchedExifTags;
			}
		}];
		}
	
	}

- (void)fetchImageOfSize:(FlickrImageSize)aSize
	{
	FlickrAPIMethod* methodGetSizes = [FlickrAPIMethod methodWithName:FlickrAPIMethodPhotosGetSizes andParameters:@{@"photo_id" : _ID} error:nil];
	
	if(methodGetSizes)
		{
		FlickrAPIMethodCall* methodCall = [FlickrAPIMethodCall methodCallWithAuthorizationContext:[FlickrAuthorizationContext sharedContext] method:methodGetSizes];
		[methodCall dispatchWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSError* error;
				NSArray* nodes = [[(FlickrAPIResponse*)methodCallResult xmlContent] nodesForXPath:[NSString stringWithFormat:@"rsp/sizes/size[@label='%@']", [FlickrPhoto stringForImageSize:aSize]] error:&error];
				
				if(error)
					return; // TODO: add more sophisticated error handling
				
				_imageData = [NSMutableData data];
				[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[nodes lastObject] attributeForName:@"source"] stringValue]]] delegate:self];
				
				}
		}];
		}
	}
	
- (void)fetchContexts
	{
	FlickrAPIMethod* methodGetAllContexts = [FlickrAPIMethod methodWithName:FlickrAPIMethodPhotosGetAllContexts andParameters:@{@"photo_id" : _ID} error:nil];
	
	if(methodGetAllContexts)
		{
		FlickrAPIMethodCall* methodCall = [FlickrAPIMethodCall methodCallWithAuthorizationContext:[FlickrAuthorizationContext sharedContext] method:methodGetAllContexts];
		[methodCall dispatchWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSArray* setNodes = [[(FlickrAPIResponse*)methodCallResult xmlContent] nodesForXPath:@"rsp/set" error:nil];

				NSMutableArray* setArray = [NSMutableArray arrayWithCapacity:[setNodes count]];
				for(NSXMLElement* element in setNodes)
					{
					[setArray addObject:[FlickrPhotoset setWithID:[[element attributeForName:@"id"] stringValue] title:[[element attributeForName:@"title"] stringValue]]];
					}
				self.photosets = setArray;

				NSArray* poolNodes = [[(FlickrAPIResponse*)methodCallResult xmlContent] nodesForXPath:@"rsp/pool" error:nil];

				NSMutableArray* poolArray = [NSMutableArray arrayWithCapacity:[setNodes count]];
				for(NSXMLElement* element in poolNodes)
					{
					[poolArray addObject:[[element attributeForName:@"title"] stringValue]];
					}
				self.pools = poolArray;
				}
		}];
		}
	}
	
- (void)fetchComments
	{
	FlickrAPIMethod* methodCommentsGetList = [FlickrAPIMethod methodWithName:FlickrAPIMethodPhotosCommentsGetList andParameters:@{@"photo_id": _ID} error:nil];

	if(methodCommentsGetList)
		{
		FlickrAPIMethodCall* methodCall = [FlickrAPIMethodCall methodCallWithAuthorizationContext:[FlickrAuthorizationContext sharedContext] method:methodCommentsGetList];
		[methodCall dispatchWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSArray* nodes = [[(FlickrAPIResponse*)methodCallResult xmlContent] nodesForXPath:@"rsp/comments/comment" error:nil];
				NSMutableArray* commentsArray = [NSMutableArray arrayWithCapacity:[nodes count]];
				for(NSXMLElement* element in nodes)
					{
					[commentsArray addObject:[FlickrComment commentWithXMLElement:element]];
					}
				self.comments = commentsArray;
				}
		}];
		}
	}

- (void)fetchFavorites
	{
	FlickrAPIMethod* methodGetFavorites = [FlickrAPIMethod methodWithName:FlickrAPIMethodPhotosGetFavorites andParameters:@{@"photo_id" : _ID} error:nil];

	if(methodGetFavorites)
		{
		FlickrAPIMethodCall* methodCall = [FlickrAPIMethodCall methodCallWithAuthorizationContext:[FlickrAuthorizationContext sharedContext] method:methodGetFavorites];
		[methodCall dispatchWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSError* error;
				NSArray* personArray = [[(FlickrAPIResponse*)methodCallResult xmlContent] nodesForXPath:@"rsp/photo/person" error:&error];
				
				if(error)
					return; // TODO: Add more sophisticated error handling
				
				NSMutableArray* favoriteArray = [NSMutableArray arrayWithCapacity:[personArray count]];
				
				for(NSXMLElement* element in personArray)
					{
					NSString* personID = [[element attributeForName:@"nsid"] stringValue];
					[favoriteArray addObject:[FlickrPerson personWithID:personID]];
					}
				
				self.favorites = favoriteArray;
				}
		}];
		}
	}

- (void)fetchGeneralInformation
	{
	FlickrAPIMethod* methodGetInfo = [FlickrAPIMethod methodWithName:FlickrAPIMethodPhotosGetInfo andParameters:@{@"photo_id" : _ID} error:nil];

	if(methodGetInfo)
		{
		FlickrAPIMethodCall* methodCall = [FlickrAPIMethodCall methodCallWithAuthorizationContext:[FlickrAuthorizationContext sharedContext] method:methodGetInfo];
		[methodCall dispatchWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSXMLElement* photoElement = (NSXMLElement*)[[[(FlickrAPIResponse*)methodCallResult xmlContent] rootElement] childAtIndex:0];

				[self parseXMLElement:photoElement];
				}
		}];
		}
	}

#pragma mark - Image size helper functions

+ (NSString*)stringForImageSize:(FlickrImageSize)aSize
	{
	NSString* returnString = nil;

	switch (aSize)
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

+ (NSString*)localizedStringForImageSize:(FlickrImageSize)aSize
	{
	NSString* returnString = nil;
	
	switch (aSize)
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

#pragma mark - Private Methods

- (void)parseXMLElement:(NSXMLElement*)anElement
	{
	if(!anElement)
		return;
	
	self.ID = [[(NSXMLElement*)anElement attributeForName:@"id"] stringValue];
	self.title = [[[(NSXMLElement*)anElement nodesForXPath:@"title" error:nil] lastObject] stringValue];
	self.description = [[[(NSXMLElement*)anElement nodesForXPath:@"description" error:nil] lastObject] stringValue];

	self.commentCount = [[[[(NSXMLElement*)anElement nodesForXPath:@"comments" error:nil] lastObject] stringValue] intValue];
	self.license = [FlickrLicense licenseWithCode:[[[(NSXMLElement*)anElement attributeForName:@"license"] stringValue] intValue]];

	self.owner = [FlickrPerson personWithID:[[[[anElement nodesForXPath:@"owner" error:nil] lastObject] attributeForName:@"nsid"] stringValue]];

	self.dateTaken = [NSDate dateWithNaturalLanguageString:[[[[anElement nodesForXPath:@"dates" error:nil] lastObject] attributeForName:@"taken"] stringValue]];
	self.datePosted = [NSDate dateWithTimeIntervalSince1970:[[[[[anElement nodesForXPath:@"dates" error:nil] lastObject] attributeForName:@"posted"] stringValue] doubleValue]];
	self.dateLastUpdate = [NSDate dateWithTimeIntervalSince1970:[[[[[anElement nodesForXPath:@"dates" error:nil] lastObject] attributeForName:@"lastupdate"] stringValue] doubleValue]];
	
	self.tags = [NSMutableArray arrayWithCapacity:[[(NSXMLElement*)anElement nodesForXPath:@"tags/tag" error:nil] count]];

	[[(NSXMLElement*)anElement nodesForXPath:@"tags/tag" error:nil] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[(NSMutableArray*)_tags addObject:[FlickrTag tagWithXMLElement:obj]];
	}];
	
	self.URLs = [NSMutableDictionary dictionaryWithCapacity:[[(NSXMLElement*)anElement nodesForXPath:@"urls/url" error:nil] count]];

	[[(NSXMLElement*)anElement nodesForXPath:@"urls/url" error:nil] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[_URLs setObject:[NSURL URLWithString:[obj stringValue]] forKey:[[obj attributeForName:@"type"] stringValue]];
	}];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FlickrPhotoDidChangeNotification object:self];
	}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
	{
	[_imageData appendData:data];
	}
	
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
	{
	self.image = [[NSImage alloc] initWithData:_imageData];
	_imageData = nil;
	}
@end
