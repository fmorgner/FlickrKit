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
	NSString* __unsafe_unretained status;
	NSData* __unsafe_unretained rawContent;
	NSXMLDocument* xmlContent;
	NSError* __unsafe_unretained error;
	}

- (id)initWithData:(NSData*)theData;
+ (FlickrAPIResponse*)responseWithData:(NSData*)theData;

@property(unsafe_unretained, nonatomic,readonly) NSString* status;
@property(unsafe_unretained, nonatomic,readonly) NSData* rawContent;
@property(nonatomic,readonly) NSXMLDocument* xmlContent;
@property(unsafe_unretained, nonatomic,readonly) NSError* error;

@end
