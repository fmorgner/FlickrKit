//
//  FlickrPhoto.h
//  FlickrLinks
//
//  Created by Felix Morgner on 16.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

	

@class FKPerson;
@class FKLicense;
@class FKAPIResponse;

@interface FKPhoto : NSObject <NSURLConnectionDelegate>

+ (FKPhoto*)photo;
+ (FKPhoto*)photoWithID:(NSString*)anID;
+ (FKPhoto*)photoWithXMLElement:(NSXMLElement*)anElement  error:(NSError**)error;
+ (FKPhoto*)photoWithAPIResponse:(FKAPIResponse*)aResponse  error:(NSError**)error;

- (void)fetchInformation:(unsigned int)anInformationMask;

- (void)fetchEXIFInformation;
- (void)fetchImageOfSize:(FKImageSize)aSize;
- (void)fetchAllContexts;
- (void)fetchContext; //1.1
- (void)fetchComments;
- (void)fetchFavorites;
- (void)fetchGeneralInformation;

+ (NSString*)stringForImageSize:(FKImageSize)aSize;
+ (NSString*)localizedStringForImageSize:(FKImageSize)aSize;

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

@property(strong) FKLicense* license;
@property(strong) FKPerson* owner;

@property(weak) FKPhoto* next;
@property(weak) FKPhoto* previous;

@end
