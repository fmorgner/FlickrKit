//
//  FlickrPhoto.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrKitConstants.h"

#define kFlickrPhotoInformationEXIF 1
#define kFlickrPhotoInformationContexts 2
#define kFlickrPhotoInformationComments 4
#define kFlickrPhotoInformationFavorites 8

#define kFlickrPhotoInformationAll 15

// FlickrImageSize enumeration: represents the sizes of images you can fetch from flickr.

typedef enum _FlickrImageSize
	{
  FlickrImageSizeSquare = 1,
	FlickrImageSizeThumbnail = 2,
	FlickrImageSizeSmall = 4,
	FlickrImageSizeMedium = 8,
	FlickrImageSizeMedium640 = 16,
	FlickrImageSizeLarge = 32,
	FlickrImageSizeOriginal = 64,
	} FlickrImageSize;
	
// Returns an NSString object representing the name of the given FlickrImageSize.
// This can be very useful to formulate and xpath query.

NSString* flickrImageSizeString(FlickrImageSize size);

// Returns an NSString object containing the localized name of the given FlickrImageSize.
NSString* flickrImageSizeLocalizedString(FlickrImageSize size);


@class FlickrPerson;
@class FlickrLicense;
@class FlickrAPIResponse;

@interface FlickrPhoto : NSObject
	{
	NSString* ID;
	NSString* title;
	NSString* description;

	NSInteger commentCount;
	
	NSDate* dateTaken;
	NSDate* datePosted;
	NSDate* dateLastUpdate;
	
	NSArray* photosets;
	NSArray* pools;
	NSArray* tags;
	NSArray* comments;
	NSArray* favorites;
	NSArray* galleries;
	NSArray* exifTags;

	NSDictionary* URLs;
	
	NSImage* image;
	
	FlickrLicense* license;
	FlickrPerson* owner;
	}


- (id)initWithXMLElement:(NSXMLElement*)anElement  error:(NSError**)error;
- (id)initWithDictionary:(NSDictionary*)aDictionary  error:(NSError**)error;
- (id)initWithAPIResponse:(FlickrAPIResponse*)aResponse  error:(NSError**)error;
- (id)initWithID:(NSString*)anID;

+ (FlickrPhoto*)photo;
+ (FlickrPhoto*)photoWithID:(NSString*)anID;
+ (FlickrPhoto*)photoWithXMLElement:(NSXMLElement*)anElement  error:(NSError**)error;
+ (FlickrPhoto*)photoWithDictionary:(NSDictionary*)aDictionary  error:(NSError**)error;
+ (FlickrPhoto*)photoWithAPIResponse:(FlickrAPIResponse*)aResponse  error:(NSError**)error;

- (void)fetchInformation:(unsigned int)anInformationMask;

- (void)fetchEXIFInformation;
- (void)fetchImageOfSize:(FlickrImageSize)aSize;
- (void)fetchContexts;
- (void)fetchComments;
- (void)fetchFavorites;

@property(nonatomic, retain) NSString* ID;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* description;

@property(nonatomic, assign) NSInteger commentCount;

@property(nonatomic, retain) NSDate* dateTaken;
@property(nonatomic, retain) NSDate* datePosted;
@property(nonatomic, retain) NSDate* dateLastUpdate;

@property(nonatomic, retain) NSArray* photosets;
@property(nonatomic, retain) NSArray* pools;
@property(nonatomic, retain) NSArray* tags;
@property(nonatomic, retain) NSArray* comments;
@property(nonatomic, retain) NSArray* favorites;
@property(nonatomic, retain) NSArray* galleries;
@property(nonatomic, retain) NSArray* exifTags;

@property(nonatomic, retain) NSDictionary* URLs;

@property(nonatomic, retain) NSImage* image;

@property(nonatomic, retain) FlickrLicense* license;
@property(nonatomic, retain) FlickrPerson* owner;
@end
