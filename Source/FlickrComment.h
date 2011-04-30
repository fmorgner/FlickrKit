//
//  FlickrComment.h
//  FlickrKit
//
//  Created by Felix Morgner on 27.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPerson.h"

@interface FlickrComment : NSObject
	{
	NSString* ID;
	NSString* rawText;
	NSString* strippedText;
	NSDate* dateCreated;
	NSURL* url;
	FlickrPerson* author;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;

- (FlickrComment*)commentWithXMLElement:(NSXMLElement*)anElement;


@property(copy) NSString* ID;
@property(copy) NSString* rawText;
@property(copy) NSString* strippedText;
@property(copy) NSDate* dateCreated;
@property(copy) NSURL* url;

@property(retain) FlickrPerson* author;

@end
