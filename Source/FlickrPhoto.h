//
//  FlickrPhoto.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrKitConstants.h"

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
