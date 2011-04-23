//
//  FlickrKitResourceManager.m
//  FlickrKit
//
//  Created by Felix Morgner on 17.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrKitResourceManager.h"
#import "FlickrKitConstants.h"

@implementation FlickrKitResourceManager

static FlickrKitResourceManager* sharedResourceManager = nil;

#pragma mark - Object lifecycle

- (id)init
	{
	if((self = [super init]))
		{
		kitBundle = [NSBundle bundleWithIdentifier:@"ch.felixmorgner.FlickrKit"];
		}
	return self;
	}

- (void)dealloc
	{
	[super dealloc];
	}

#pragma mark - Singleton implementation

+ (FlickrKitResourceManager*)sharedManager
	{
	@synchronized(self)
		{
		if (sharedResourceManager == nil)
			{
			sharedResourceManager = [[super allocWithZone:NULL] init];
			}
		}
	return sharedResourceManager;
	}

+ (id)allocWithZone:(NSZone *)zone
	{
  return [[self sharedManager] retain];
	}

- (id)copyWithZone:(NSZone *)zone
	{
  return self;
	}
 
- (id)retain
	{
  return self;
	}
 
- (NSUInteger)retainCount
	{
  return UINT_MAX;
	}
 
- (void)release
	{
	}
 
- (id)autorelease
	{
  return self;
	}

#pragma mark - Resource accessing methods

- (NSArray*)imagesForLicense:(FlickrLicense*)aLicense
	{
	NSArray* returnArray = nil;

	if(aLicense.code == FlickrLicenseCCBy || aLicense.code ==  FlickrLicenseCCByNc || aLicense.code ==  FlickrLicenseCCByNcNd || aLicense.code ==  FlickrLicenseCCByNcSa || aLicense.code ==  FlickrLicenseCCByNd || aLicense.code ==  FlickrLicenseCCBySa)
		{	
		NSImage* ccImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"cc.large" ofType:@"png"]] autorelease];
		NSImage* byImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"by.large" ofType:@"png"]] autorelease];
		NSImage* ncImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"nc.large" ofType:@"png"]] autorelease];
		NSImage* ndImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"nd.large" ofType:@"png"]] autorelease];
		NSImage* saImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"sa.large" ofType:@"png"]] autorelease];

		switch (aLicense.code)
			{
			case FlickrLicenseCCBy:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, nil];
				[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					[(NSImage*)obj setName:[aLicense name]];
				}];
				break;
				
			case FlickrLicenseCCByNc:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, ncImage, nil];
				[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					[(NSImage*)obj setName:[aLicense name]];
				}];
				break;
				
			case FlickrLicenseCCByNcNd:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, ncImage, ndImage, nil];
				[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					[(NSImage*)obj setName:[aLicense name]];
				}];
				break;
				
			case FlickrLicenseCCByNcSa:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, ncImage, saImage, nil];
				[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					[(NSImage*)obj setName:[aLicense name]];
				}];
				break;
				
			case FlickrLicenseCCByNd:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, ndImage, nil];
				[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					[(NSImage*)obj setName:[aLicense name]];
				}];
				break;
				
			case FlickrLicenseCCBySa:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, saImage, nil];
				[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					[(NSImage*)obj setName:[aLicense name]];
				}];
				break;
				
			default:
				break;
			}
		}
	else if(aLicense.code == FlickrLicenseAllRightsReserved)
		{
		NSImage* crImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"cr.large" ofType:@"png"]] autorelease];
		returnArray = [NSArray arrayWithObject:crImage];
		[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[(NSImage*)obj setName:[aLicense name]];
		}];
		}
	
	return returnArray;
	}
@end
