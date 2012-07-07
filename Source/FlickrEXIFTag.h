//
//  FlickrEXIFTag.h
//  FlickrKit
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrEXIFTag : NSObject

- (id)initWithXMLElement:(NSXMLElement*)anElement;
+ (FlickrEXIFTag*)exifTagWithXMLElement:(NSXMLElement*)anElement;

@property(readonly) NSString* label;
@property(readonly) NSString* value;
@property(readonly) NSString* raw;
@property(readonly) NSString* clean;
@property(readonly) NSString* tagspace;

@property(readonly) short tagspaceID;
@property(readonly) short tag;

@end
