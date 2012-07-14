//
//  FlickrAuthorizationContext.m
//  FlickrKit
//
//  Created by Felix Morgner on 24.01.12.
//  Copyright (c) 2012 Felix Morgner. All rights reserved.
//

#import "FlickrAuthorizationContext.h"
#import <OAuthKit/OAuthKit.h>

@implementation FlickrAuthorizationContext

__strong static FlickrAuthorizationContext* _sharedContext;

+ (FlickrAuthorizationContext *)sharedContext
	{
	static dispatch_once_t once = 0;
	dispatch_once(&once, ^{
		_sharedContext = [[self alloc] init];
		});
	return _sharedContext;
	}

@end
