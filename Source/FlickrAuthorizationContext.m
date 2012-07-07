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

@synthesize token, consumer;

- (id)initWithToken:(OAuthToken*)aToken
	{
	if((self = [super init]))
		{
		self.token = aToken;
		}
	return self;
	}
	
+	(FlickrAuthorizationContext*)contextWithToken:(OAuthToken*)aToken
	{
	return [[FlickrAuthorizationContext alloc] initWithToken:aToken];
	}

- (id)initWithConsumer:(OAuthConsumer*)aComsumer
	{
	if((self = [super init]))
		{
		self.consumer = aComsumer;
		}
	return self;
	}
	
+	(FlickrAuthorizationContext*)contextWithConsumer:(OAuthConsumer*)aConsumer
	{
	return [[FlickrAuthorizationContext alloc] initWithConsumer:aConsumer];
	}


@end
