//
//  FlickrLicense.m
//  FlickrKit
//
//  Created by Felix Morgner on 18.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrLicense.h"


@implementation FlickrLicense

@synthesize code;

- (id)initWithCode:(FlickrLicenseCode)aCode
	{
	if ((self = [super init]))
		{
		code = aCode;
    }
  
	return self;
	}

+ (id)licenseWithCode:(FlickrLicenseCode)aCode
	{
	return [[[FlickrLicense alloc]  initWithCode:aCode] autorelease];
	}

- (void)dealloc
	{
	[super dealloc];
	}

- (NSString*)name
	{
	NSString* returnName;
	
	switch (code)
		{
  	case kFlickrLicenseAllRightsReserved:
    	returnName = @"All Rights Reserved";
    	break;
  	case kFlickrLicenseCCBy:
    	returnName = @"CreativeCommons Attribution 2.0 Generic";
    	break;
		case kFlickrLicenseCCByNc:
			returnName = @"CreativeCommons Attribution-NonCommercial 2.0 Generic";
			break;
		case kFlickrLicenseCCByNcNd:
			returnName = @"CreativeCommons Attribution-NonCommercial-NoDerivs 2.0 Generic";
			break;
		case kFlickrLicenseCCByNcSa:
			returnName = @"CreativeCommons Attribution-NonCommercial-ShareAlike 2.0 Generic";
			break;
		case kFlickrLicenseCCByNd:
			returnName = @"CreativeCommons Attribution-NoDerivs 2.0 Generic";
			break;
		case kFlickrLicenseCCBySa:
			returnName = @"CreativeCommons Attribution-ShareAlike 2.0 Generic";
			break;
		case kFlickrLicenseNoKnownRestrictions:
			returnName = @"No known copyright restrictions";
			break;
		case kFlickrLicenseUSGovernmentWork:
			returnName = @"United States Government Work";
			break;
  	default:
			returnName = @"";
    	break;
		}
	
	return returnName;
	}

- (NSURL*)URL
	{
	NSURL* returnURL;
	
	switch (code)
		{
  	case kFlickrLicenseAllRightsReserved:
    	returnURL = nil;
    	break;
  	case kFlickrLicenseCCBy:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by/2.0/"];
    	break;
		case kFlickrLicenseCCByNc:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by-nc/2.0/"];
			break;
		case kFlickrLicenseCCByNcNd:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by-nc-nd/2.0/"];
			break;
		case kFlickrLicenseCCByNcSa:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by-nc-sa/2.0/"];
			break;
		case kFlickrLicenseCCByNd:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by-nd/2.0/"];
			break;
		case kFlickrLicenseCCBySa:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by-sa/2.0/"];
			break;
		case kFlickrLicenseNoKnownRestrictions:
    	returnURL = [NSURL URLWithString:@"http://www.flickr.com/commons/usage/"];
			break;
		case kFlickrLicenseUSGovernmentWork:
    	returnURL = [NSURL URLWithString:@"http://www.usa.gov/copyright.shtml"];
			break;
  	default:
			returnURL = nil;
    	break;
		}
	
	return returnURL;
	}

- (NSArray*)icons
	{
	NSArray* returnArray = nil;

	NSImage* ccImage = [[[NSImage alloc] initWithContentsOfFile:[KitBundle pathForResource:@"cc.large" ofType:@"png"]] autorelease];
	NSImage* byImage = [[[NSImage alloc] initWithContentsOfFile:[KitBundle pathForResource:@"by.large" ofType:@"png"]] autorelease];
	NSImage* ncImage = [[[NSImage alloc] initWithContentsOfFile:[KitBundle pathForResource:@"nc.large" ofType:@"png"]] autorelease];
	NSImage* ndImage = [[[NSImage alloc] initWithContentsOfFile:[KitBundle pathForResource:@"nd.large" ofType:@"png"]] autorelease];
	NSImage* saImage = [[[NSImage alloc] initWithContentsOfFile:[KitBundle pathForResource:@"sa.large" ofType:@"png"]] autorelease];
	NSImage* crImage = [[[NSImage alloc] initWithContentsOfFile:[KitBundle pathForResource:@"cr.large" ofType:@"png"]] autorelease];

	switch (self.code)
		{
		case kFlickrLicenseCCBy:
			returnArray = [NSArray arrayWithObjects:ccImage, byImage, nil];
			[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[(NSImage*)obj setName:[self name]];
			}];
			break;
			
		case kFlickrLicenseCCByNc:
			returnArray = [NSArray arrayWithObjects:ccImage, byImage, ncImage, nil];
			[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[(NSImage*)obj setName:[self name]];
			}];
			break;
			
		case kFlickrLicenseCCByNcNd:
			returnArray = [NSArray arrayWithObjects:ccImage, byImage, ncImage, ndImage, nil];
			[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[(NSImage*)obj setName:[self name]];
			}];
			break;
			
		case kFlickrLicenseCCByNcSa:
			returnArray = [NSArray arrayWithObjects:ccImage, byImage, ncImage, saImage, nil];
			[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[(NSImage*)obj setName:[self name]];
			}];
			break;
			
		case kFlickrLicenseCCByNd:
			returnArray = [NSArray arrayWithObjects:ccImage, byImage, ndImage, nil];
			[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[(NSImage*)obj setName:[self name]];
			}];
			break;
			
		case kFlickrLicenseCCBySa:
			returnArray = [NSArray arrayWithObjects:ccImage, byImage, saImage, nil];
			[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[(NSImage*)obj setName:[self name]];
			}];
			break;
		
		case kFlickrLicenseAllRightsReserved:
			returnArray = [NSArray arrayWithObject:crImage];
			[returnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[(NSImage*)obj setName:[self name]];
			}];
			break;
						
		default:
			break;
		}
	
	return returnArray;
	}

@end
