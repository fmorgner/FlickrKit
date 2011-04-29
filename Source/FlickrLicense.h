//
//  FlickrLicense.h
//  FlickrKit
//
//  Created by Felix Morgner on 18.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _FlickrLicenseCode
	{
  kFlickrLicenseAllRightsReserved = 0,
  kFlickrLicenseCCByNcSa = 1,
	kFlickrLicenseCCByNc = 2,
	kFlickrLicenseCCByNcNd = 3,
	kFlickrLicenseCCBy = 4,
	kFlickrLicenseCCBySa = 5,
	kFlickrLicenseCCByNd = 6,
	kFlickrLicenseNoKnownRestrictions = 7,
	kFlickrLicenseUSGovernmentWork = 8
	} FlickrLicenseCode;

@interface FlickrLicense : NSObject
	{
	@private
  NSInteger code;
	}

- (id)initWithCode:(FlickrLicenseCode)aCode;
+ (id)licenseWithCode:(FlickrLicenseCode)aCode;

- (NSString*)name;
- (NSURL*)URL;
- (NSArray*)icons;

@property(nonatomic, assign) NSInteger code;

@end
