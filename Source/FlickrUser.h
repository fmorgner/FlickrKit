//
//  FlickrUser.h
//  FlickrKit
//
//  Created by Felix Morgner on 14.05.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPerson.h"

@interface FlickrUser : FlickrPerson
	{
	NSString* token;
	}

@property(copy) NSString* token;

@end
