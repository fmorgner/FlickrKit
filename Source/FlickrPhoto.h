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
	

@class FlickrPerson;
@class FlickrLicense;
@class FlickrAPIResponse;

@interface FlickrPhoto : NSObject <NSURLConnectionDelegate>

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
- (void)fetchAllContexts;
- (void)fetchContext; //1.1
- (void)fetchComments;
- (void)fetchFavorites;
- (void)fetchGeneralInformation;

+ (NSString*)stringForImageSize:(FlickrImageSize)aSize;
+ (NSString*)localizedStringForImageSize:(FlickrImageSize)aSize;

@property(strong) NSString* ID;
@property(strong) NSString* title;
@property(strong) NSString* description;

@property(assign) NSInteger commentCount;

@property(strong) NSDate* dateTaken;
@property(strong) NSDate* datePosted;
@property(strong) NSDate* dateLastUpdate;

@property(strong) NSMutableArray* photosets;
@property(strong) NSMutableArray* pools;
@property(strong) NSMutableArray* tags;
@property(strong) NSMutableArray* comments;
@property(strong) NSMutableArray* favorites;
@property(strong) NSMutableArray* galleries;
@property(strong) NSMutableArray* exifTags;

@property(strong) NSMutableDictionary* URLs;

@property(strong) NSImage* image;

@property(strong) FlickrLicense* license;
@property(strong) FlickrPerson* owner;

@property(weak) FlickrPhoto* next;
@property(weak) FlickrPhoto* previous;

@end
