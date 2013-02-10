//
//  FlickrAPIResponse.h
//  FlickrLinks
//
//  Created by Felix Morgner on 03.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* kFlickrErrorDomain = @"FlickrErrorDomain";

@interface FlickrAPIResponse : NSObject
	{
	NSXMLDocument*  xml;
	NSString*       status;
	NSError*        error;
	NSData*         raw;
	}

+ (FlickrAPIResponse*)responseWithData:(NSData*)theData error:(NSError**)anError;

@property(readonly) NSXMLDocument* xml;
@property(readonly) NSString* status;
@property(readonly) NSError* error;
@property(readonly) NSData* raw;

@end
