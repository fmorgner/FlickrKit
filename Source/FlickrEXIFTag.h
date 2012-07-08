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

@property(strong) NSString* label;
@property(strong) NSString* value;
@property(strong) NSString* raw;
@property(strong) NSString* clean;
@property(strong) NSString* tagspace;

@property(assign) short tagspaceID;
@property(assign) short tag;

@end
