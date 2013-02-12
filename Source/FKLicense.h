//
//  FlickrLicense.h
//  FlickrKit
//
//  Created by Felix Morgner on 18.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKLicense : NSObject

- (id)initWithCode:(FlickrLicenseCode)aCode;
+ (id)licenseWithCode:(FlickrLicenseCode)aCode;

- (NSString*)name;
- (NSURL*)URL;
- (NSArray*)icons;

@property(nonatomic, assign) NSInteger code;

@end
