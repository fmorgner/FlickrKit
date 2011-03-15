//
//  FlickrPhoto.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrAPIResponse.h"

typedef enum
	{
  kFlickrLicenseAllRightsReseved = 0,
  kFlickrLicenseCCByNcSa = 1,
	kFlickrLicenseCCByNc = 2,
	kFlickrLicenseCCByNcNd = 3,
	kFlickrLicenseCCBy = 4,
	kFlickrLicenseCCBySa = 5,
	kFlickrLicenseCCByNd = 6,
	kFlickrLicenseNoKnownRestrictions = 7,
	kFlickrLicenseUSGovernmentWork = 8,
	} FlickrLicense;

@interface FlickrPhoto : NSObject
	{
	NSImage* image;
	NSString* title;
	NSInteger commentCount;
	
	NSDate* dateTaken;
	NSDate* datePosted;
	NSDate* dateLastUpdate;
	
	NSArray* sets;
	NSArray* pools;
	NSArray* tags;
	NSArray* comments;
	NSArray* favorites;
	NSArray* galleries;
	
	NSString* ID;
	
	FlickrLicense license;
	}


- (id)initWithXMLElement:(NSXMLElement*)anElement  error:(NSError**)error;
- (id)initWithDictionary:(NSDictionary*)aDictionary  error:(NSError**)error;
- (id)initWithAPIResponse:(FlickrAPIResponse*)aResponse  error:(NSError**)error;

+ (FlickrPhoto*)photo;
+ (FlickrPhoto*)photoWithXMLElement:(NSXMLElement*)anElement  error:(NSError**)error;
+ (FlickrPhoto*)photoWithDictionary:(NSDictionary*)aDictionary  error:(NSError**)error;
+ (FlickrPhoto*)photoWithAPIResponse:(FlickrAPIResponse*)aResponse  error:(NSError**)error;

@property(nonatomic, retain) NSImage* image;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, assign) NSInteger commentCount;

@property(nonatomic, retain) NSDate* dateTaken;
@property(nonatomic, retain) NSDate* datePosted;
@property(nonatomic, retain) NSDate* dateLastUpdate;

@property(nonatomic, retain) NSArray* sets;
@property(nonatomic, retain) NSArray* pools;
@property(nonatomic, retain) NSArray* tags;
@property(nonatomic, retain) NSArray* comments;
@property(nonatomic, retain) NSArray* favorites;
@property(nonatomic, retain) NSArray* galleries;

@property(nonatomic, retain) NSString* ID;

@property(nonatomic, assign) FlickrLicense license;

@end
