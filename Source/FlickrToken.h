//
//  FlickrToken.h
//  FlickrKit
//
//  Created by Felix Morgner on 10.06.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrPerson;

@interface FlickrToken : NSObject <NSCopying>
	{
	NSString* tokenString;
	NSString* permissions;
	FlickrPerson* user;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;

@property(copy) NSString* tokenString;
@property(copy) NSString* permissions;
@property(retain) FlickrPerson* user;


@end
