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

- (id)initWithCode:(NSInteger)aCode
	{
	if ((self = [super init]))
		{
		code = aCode;
    }
  
	return self;
	}

+ (id)licenseWithCode:(NSInteger)aCode
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
  	case FlickrLicenseAllRightsReserved:
    	returnName = @"All Rights Reserved";
    	break;
  	case FlickrLicenseCCBy:
    	returnName = @"CreativeCommons Attribution 2.0 Generic";
    	break;
		case FlickrLicenseCCByNc:
			returnName = @"CreativeCommons Attribution-NonCommercial 2.0 Generic";
			break;
		case FlickrLicenseCCByNcNd:
			returnName = @"CreativeCommons Attribution-NonCommercial-NoDerivs 2.0 Generic";
			break;
		case FlickrLicenseCCByNcSa:
			returnName = @"CreativeCommons Attribution-NonCommercial-ShareAlike 2.0 Generic";
			break;
		case FlickrLicenseCCByNd:
			returnName = @"CreativeCommons Attribution-NoDerivs 2.0 Generic";
			break;
		case FlickrLicenseCCBySa:
			returnName = @"CreativeCommons Attribution-ShareAlike 2.0 Generic";
			break;
		case FlickrLicenseNoKnownRestrictions:
			returnName = @"No known copyright restrictions";
			break;
		case FlickrLicenseUSGovernmentWork:
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
  	case FlickrLicenseAllRightsReserved:
    	returnURL = nil;
    	break;
  	case FlickrLicenseCCBy:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by/2.0/"];
    	break;
		case FlickrLicenseCCByNc:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by-nc/2.0/"];
			break;
		case FlickrLicenseCCByNcNd:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by-nc-nd/2.0/"];
			break;
		case FlickrLicenseCCByNcSa:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by-nc-sa/2.0/"];
			break;
		case FlickrLicenseCCByNd:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by-nd/2.0/"];
			break;
		case FlickrLicenseCCBySa:
    	returnURL = [NSURL URLWithString:@"http://creativecommons.org/licenses/by-sa/2.0/"];
			break;
		case FlickrLicenseNoKnownRestrictions:
    	returnURL = [NSURL URLWithString:@"http://www.flickr.com/commons/usage/"];
			break;
		case FlickrLicenseUSGovernmentWork:
    	returnURL = [NSURL URLWithString:@"http://www.usa.gov/copyright.shtml"];
			break;
  	default:
			returnURL = nil;
    	break;
		}
	
	return returnURL;
	}

@end
