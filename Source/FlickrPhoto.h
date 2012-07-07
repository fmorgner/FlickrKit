//
//  FlickrPhoto.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrKitConstants.h"

typedef enum _FlickrPhotoInformation
	{
	kFlickrPhotoInformationEXIF = 1,
	kFlickrPhotoInformationContexts = 2,
	kFlickrPhotoInformationComments = 4,
	kFlickrPhotoInformationFavorites = 8,
	kFlickrPhotoInformationGeneral = 16,
	kFlickrPhotoInformationAll = 31
	} FlickrPhotoInformation;

// FlickrImageSize enumeration: represents the sizes of images you can fetch from flickr.

typedef enum _FlickrImageSize
	{
  kFlickrImageSizeSquare = 1,
	kFlickrImageSizeThumbnail = 2,
	kFlickrImageSizeSmall = 4,
	kFlickrImageSizeMedium = 8,
	kFlickrImageSizeMedium640 = 16,
	kFlickrImageSizeLarge = 32,
	kFlickrImageSizeOriginal = 64,
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

- (id)initWithID:(NSString*)anID;
- (id)initWithXMLElement:(NSXMLElement*)anElement  error:(NSError**)error;
- (id)initWithAPIResponse:(FlickrAPIResponse*)aResponse  error:(NSError**)error;

+ (FlickrPhoto*)photo;
+ (FlickrPhoto*)photoWithID:(NSString*)anID;
+ (FlickrPhoto*)photoWithXMLElement:(NSXMLElement*)anElement  error:(NSError**)error;
+ (FlickrPhoto*)photoWithAPIResponse:(FlickrAPIResponse*)aResponse  error:(NSError**)error;

- (void)fetchInformation:(unsigned int)anInformationMask;

- (void)fetchEXIFInformation;
- (void)fetchImageOfSize:(FlickrImageSize)aSize;
- (void)fetchContexts;
- (void)fetchComments;
- (void)fetchFavorites;
- (void)fetchGeneralInformation;

@property(nonatomic, strong) NSString* ID;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* description;

@property(nonatomic, assign) NSInteger commentCount;

@property(nonatomic, strong) NSDate* dateTaken;
@property(nonatomic, strong) NSDate* datePosted;
@property(nonatomic, strong) NSDate* dateLastUpdate;

@property(nonatomic, strong) NSArray* photosets;
@property(nonatomic, strong) NSArray* pools;
@property(nonatomic, strong) NSArray* tags;
@property(nonatomic, strong) NSArray* comments;
@property(nonatomic, strong) NSArray* favorites;
@property(nonatomic, strong) NSArray* galleries;
@property(nonatomic, strong) NSArray* exifTags;

@property(nonatomic, strong) NSDictionary* URLs;

@property(nonatomic, strong) NSImage* image;

@property(nonatomic, strong) FlickrLicense* license;
@property(nonatomic, strong) FlickrPerson* owner;
@end
