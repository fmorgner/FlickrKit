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
	NSString* status;
	NSData* rawContent;
	NSXMLDocument* xmlContent;
	NSError* error;
	}

- (id)initWithData:(NSData*)theData;
+ (FlickrAPIResponse*)responseWithData:(NSData*)theData;

@property(nonatomic,readonly) NSString* status;
@property(nonatomic,readonly) NSData* rawContent;
@property(nonatomic,readonly) NSXMLDocument* xmlContent;
@property(nonatomic,readonly) NSError* error;

@end
