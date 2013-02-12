//
//  FlickrPhoto.m
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FKPhoto.h"
#import "FKTag.h"
#import "FKLicense.h"
#import "FKPerson.h"
#import "FKEXIFTag.h"
#import "FKPhotoset.h"
#import "FKComment.h"

#import "FKAuthorizationContext.h"
#import "FKAPIMethod.h"
#import "FKAPIResponse.h"

@interface FKPhoto()

- (id)initWithID:(NSString*)anID;
- (id)initWithXMLElement:(NSXMLElement*)anElement  error:(NSError**)error;
- (id)initWithAPIResponse:(FKAPIResponse*)aResponse  error:(NSError**)error;

- (void)parseXMLElement:(NSXMLElement*)anElement;

@property(strong) NSMutableData* imageData;

@end

@implementation FKPhoto

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

- (id)initWithAPIResponse:(FKAPIResponse*)aResponse error:(NSError**)error
	{
	if(!aResponse || [aResponse.status isEqualToString:@"fail"])
		return nil;

	if(![[[aResponse.xml rootElement] childAtIndex:0].name isEqualToString:@"photo"])
		return nil;
	
	NSXMLElement* photoElement = (NSXMLElement*)[[aResponse.xml rootElement] childAtIndex:0];
	
	if((self = [super init]))
		{
		[self parseXMLElement:photoElement];
		}
	
	return self;
	}

#pragma mark - Convenience allocators

+ (FKPhoto*)photo
	{
	return [[FKPhoto alloc] init];
	}
	
+ (FKPhoto*)photoWithXMLElement:(NSXMLElement*)anElement error:(NSError**)error
	{
	return [[FKPhoto alloc] initWithXMLElement:anElement error:(NSError**)error];
	}

+ (FKPhoto*)photoWithAPIResponse:(FKAPIResponse*)aResponse error:(NSError**)error
	{
	return [[FKPhoto alloc] initWithAPIResponse:aResponse error:(NSError**)error];
	}

+ (FKPhoto*)photoWithID:(NSString*)anID
	{
	return [[FKPhoto alloc] initWithID:anID];
	}

#pragma mark - Information Fetching

- (void)fetchInformation:(unsigned int)anInformationMask
	{
	if(anInformationMask & kFlickrPhotoInformationEXIF)
		[self fetchEXIFInformation];
		
	if(anInformationMask & kFlickrPhotoInformationContexts)
		[self fetchAllContexts];
		
	if(anInformationMask & kFlickrPhotoInformationComments)
		[self fetchComments];

	if(anInformationMask & kFlickrPhotoInformationFavorites)
		[self fetchFavorites];
		
	if(anInformationMask & kFlickrPhotoInformationGeneral)
		[self fetchGeneralInformation];
	}	

- (void)fetchEXIFInformation
	{
	FKAPIMethod* methodGetExif = [FKAPIMethod methodWithName:FKMethodNamePhotosGetEXIF parameters:@{@"photo_id" : _ID} authorizationContext:[FKAuthorizationContext sharedContext] error:nil];
	
	if(methodGetExif)
		{
		[methodGetExif callWithCompletionHandler:^(id methodCallResult) {
		if([methodCallResult isKindOfClass:[FKAPIResponse class]] && [[(FKAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
			{
			NSArray* nodes = [[(FKAPIResponse*)methodCallResult xml] nodesForXPath:@"rsp/photo/exif" error:nil];
			NSMutableArray* fetchedExifTags = [NSMutableArray arrayWithCapacity:[nodes count]];
			for(NSXMLElement* element in nodes)
				{
				[fetchedExifTags addObject:[FKEXIFTag exifTagWithXMLElement:element]];
				}
			self.exifTags = fetchedExifTags;
			}
		}];
		}
	
	}

- (void)fetchImageOfSize:(FlickrImageSize)aSize
	{
	FKAPIMethod* methodGetSizes = [FKAPIMethod methodWithName:FKMethodNamePhotosGetSizes parameters:@{@"photo_id" : _ID} authorizationContext:[FKAuthorizationContext sharedContext] error:nil];
	
	if(methodGetSizes)
		{
		[methodGetSizes callWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FKAPIResponse class]] && [[(FKAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSError* error;
				NSArray* nodes = [[(FKAPIResponse*)methodCallResult xml] nodesForXPath:[NSString stringWithFormat:@"rsp/sizes/size[@label='%@']", [FKPhoto stringForImageSize:aSize]] error:&error];
				
				if(error)
					return; // TODO: add more sophisticated error handling
				
				_imageData = [NSMutableData data];
				[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[nodes lastObject] attributeForName:@"source"] stringValue]]] delegate:self];
				
				}
		}];
		}
	}
	
- (void)fetchAllContexts
	{
	FKAPIMethod* methodGetAllContexts = [FKAPIMethod methodWithName:FKMethodNamePhotosGetAllContexts parameters:@{@"photo_id" : _ID} authorizationContext:[FKAuthorizationContext sharedContext] error:nil];
	
	if(methodGetAllContexts)
		{
		[methodGetAllContexts callWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FKAPIResponse class]] && [[(FKAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSArray* setNodes = [[(FKAPIResponse*)methodCallResult xml] nodesForXPath:@"rsp/set" error:nil];

				NSMutableArray* setArray = [NSMutableArray arrayWithCapacity:[setNodes count]];
				for(NSXMLElement* element in setNodes)
					{
					[setArray addObject:[FKPhotoset setWithID:[[element attributeForName:@"id"] stringValue] title:[[element attributeForName:@"title"] stringValue]]];
					}
				self.photosets = setArray;

				NSArray* poolNodes = [[(FKAPIResponse*)methodCallResult xml] nodesForXPath:@"rsp/pool" error:nil];

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

- (void)fetchContext
	{
	FKAPIMethod* methodGetContext = [FKAPIMethod methodWithName:FKMethodNamePhotosGetContext parameters:@{@"photo_id" : _ID} authorizationContext:[FKAuthorizationContext sharedContext] error:nil];
	
	if(methodGetContext)
		{
		__block __weak FKPhoto* thisPhoto = self;
		[methodGetContext callWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FKAPIResponse class]] && [[(FKAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				thisPhoto.previous = [FKPhoto photoWithID:[[[[[(FKAPIResponse*)methodCallResult xml] nodesForXPath:@"rsp/prevphoto" error:nil] lastObject] attributeForName:@"id"] stringValue]];
				thisPhoto.next = [FKPhoto photoWithID:[[[[[(FKAPIResponse*)methodCallResult xml] nodesForXPath:@"rsp/nextphoto" error:nil] lastObject] attributeForName:@"id"] stringValue]];
				}
		}];
		}
	}

- (void)fetchComments
	{
	FKAPIMethod* methodCommentsGetList = [FKAPIMethod methodWithName:FKMethodNamePhotosCommentsGetList parameters:@{@"photo_id": _ID} authorizationContext:[FKAuthorizationContext sharedContext] error:nil];

	if(methodCommentsGetList)
		{
		[methodCommentsGetList callWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FKAPIResponse class]] && [[(FKAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSArray* nodes = [[(FKAPIResponse*)methodCallResult xml] nodesForXPath:@"rsp/comments/comment" error:nil];
				NSMutableArray* commentsArray = [NSMutableArray arrayWithCapacity:[nodes count]];
				for(NSXMLElement* element in nodes)
					{
					[commentsArray addObject:[FKComment commentWithXMLElement:element]];
					}
				self.comments = commentsArray;
				}
		}];
		}
	}

- (void)fetchFavorites
	{
	FKAPIMethod* methodGetFavorites = [FKAPIMethod methodWithName:FKMethodNamePhotosGetFavorites parameters:@{@"photo_id" : _ID} authorizationContext:[FKAuthorizationContext sharedContext] error:nil];

	if(methodGetFavorites)
		{
		[methodGetFavorites callWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FKAPIResponse class]] && [[(FKAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSError* error;
				NSArray* personArray = [[(FKAPIResponse*)methodCallResult xml] nodesForXPath:@"rsp/photo/person" error:&error];
				
				if(error)
					return; // TODO: Add more sophisticated error handling
				
				NSMutableArray* favoriteArray = [NSMutableArray arrayWithCapacity:[personArray count]];
				
				for(NSXMLElement* element in personArray)
					{
					NSString* personID = [[element attributeForName:@"nsid"] stringValue];
					[favoriteArray addObject:[FKPerson personWithID:personID]];
					}
				
				self.favorites = favoriteArray;
				}
		}];
		}
	}

- (void)fetchGeneralInformation
	{
	FKAPIMethod* methodGetInfo = [FKAPIMethod methodWithName:FKMethodNamePhotosGetInfo parameters:@{@"photo_id" : _ID} authorizationContext:[FKAuthorizationContext sharedContext] error:nil];

	if(methodGetInfo)
		{
		[methodGetInfo callWithCompletionHandler:^(id methodCallResult) {
			if([methodCallResult isKindOfClass:[FKAPIResponse class]] && [[(FKAPIResponse*)methodCallResult status] isEqualToString:@"ok"])
				{
				NSXMLElement* photoElement = (NSXMLElement*)[[[(FKAPIResponse*)methodCallResult xml] rootElement] childAtIndex:0];

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
	self.license = [FKLicense licenseWithCode:[[[(NSXMLElement*)anElement attributeForName:@"license"] stringValue] intValue]];

	self.owner = [FKPerson personWithID:[[[[anElement nodesForXPath:@"owner" error:nil] lastObject] attributeForName:@"nsid"] stringValue]];

	self.dateTaken = [NSDate dateWithNaturalLanguageString:[[[[anElement nodesForXPath:@"dates" error:nil] lastObject] attributeForName:@"taken"] stringValue]];
	self.datePosted = [NSDate dateWithTimeIntervalSince1970:[[[[[anElement nodesForXPath:@"dates" error:nil] lastObject] attributeForName:@"posted"] stringValue] doubleValue]];
	self.dateLastUpdate = [NSDate dateWithTimeIntervalSince1970:[[[[[anElement nodesForXPath:@"dates" error:nil] lastObject] attributeForName:@"lastupdate"] stringValue] doubleValue]];
	
	self.tags = [NSMutableArray arrayWithCapacity:[[(NSXMLElement*)anElement nodesForXPath:@"tags/tag" error:nil] count]];

	[[(NSXMLElement*)anElement nodesForXPath:@"tags/tag" error:nil] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[(NSMutableArray*)_tags addObject:[FKTag tagWithXMLElement:obj]];
	}];
	
	self.URLs = [NSMutableDictionary dictionaryWithCapacity:[[(NSXMLElement*)anElement nodesForXPath:@"urls/url" error:nil] count]];

	[[(NSXMLElement*)anElement nodesForXPath:@"urls/url" error:nil] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[_URLs setObject:[NSURL URLWithString:[obj stringValue]] forKey:[[obj attributeForName:@"type"] stringValue]];
	}];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:(NSString*)FKNotificationPhotoDidChange object:self];
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
