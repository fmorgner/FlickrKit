//
//  FlickrEXIFTag.h
//  FlickrKit
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrEXIFTag : NSObject
	{
	NSString* label;
	NSString* value;
	NSString* raw;
	NSString* clean;
	NSString* tagspace;
	
	short tagspaceID;
	short tag;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;
+ (FlickrEXIFTag*)exifTagWithXMLElement:(NSXMLElement*)anElement;

@property(readonly) NSString* label;
@property(readonly) NSString* value;
@property(readonly) NSString* raw;
@property(readonly) NSString* clean;
@property(readonly) NSString* tagspace;

@property(assign) short tagspaceID;
@property(assign) short tag;

@end
