//
//  FlickrKitResourceManager.m
//  FlickrKit
//
//  Created by Felix Morgner on 17.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrKitResourceManager.h"


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

- (NSArray*)imagesForLicense:(FlickrLicense)aLicense
	{
	NSArray* returnArray = nil;

	if(aLicense == kFlickrLicenseCCBy || aLicense ==  kFlickrLicenseCCByNc || aLicense ==  kFlickrLicenseCCByNcNd || aLicense ==  kFlickrLicenseCCByNcSa || aLicense ==  kFlickrLicenseCCByNd || aLicense ==  kFlickrLicenseCCBySa)
		{	
		NSImage* ccImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"cc.large" ofType:@"png"]] autorelease];
		NSImage* byImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"by.large" ofType:@"png"]] autorelease];
		NSImage* ncImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"nc.large" ofType:@"png"]] autorelease];
		NSImage* ndImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"nd.large" ofType:@"png"]] autorelease];
		NSImage* saImage = [[[NSImage alloc] initWithContentsOfFile:[kitBundle pathForResource:@"sa.large" ofType:@"png"]] autorelease];

		switch (aLicense)
			{
			case kFlickrLicenseCCBy:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, nil];
				break;
				
			case kFlickrLicenseCCByNc:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, ncImage, nil];
				break;
				
			case kFlickrLicenseCCByNcNd:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, ncImage, ndImage, nil];
				break;
				
			case kFlickrLicenseCCByNcSa:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, ncImage, saImage, nil];
				break;
				
			case kFlickrLicenseCCByNd:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, ndImage, nil];
				break;
				
			case kFlickrLicenseCCBySa:
				returnArray = [NSArray arrayWithObjects:ccImage, byImage, saImage, nil];
				break;
				
			default:
				break;
			}
		}
	
	return returnArray;
	}

@end
