//
//  FlickrLicense.h
//  FlickrKit
//
//  Created by Felix Morgner on 18.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
	{
  FlickrLicenseAllRightsReserved = 0,
  FlickrLicenseCCByNcSa = 1,
	FlickrLicenseCCByNc = 2,
	FlickrLicenseCCByNcNd = 3,
	FlickrLicenseCCBy = 4,
	FlickrLicenseCCBySa = 5,
	FlickrLicenseCCByNd = 6,
	FlickrLicenseNoKnownRestrictions = 7,
	FlickrLicenseUSGovernmentWork = 8
	};

@interface FlickrLicense : NSObject
	{
	@private
  NSInteger code;
	}

- (id)initWithCode:(NSInteger)aCode;
+ (id)licenseWithCode:(NSInteger)aCode;

- (NSString*)name;
- (NSURL*)URL;

@property(nonatomic, assign) NSInteger code;

@end
