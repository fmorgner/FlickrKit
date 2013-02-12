//
//  FlickrAuthorizationContext.m
//  FlickrKit
//
//  Created by Felix Morgner on 24.01.12.
//  Copyright (c) 2012 Felix Morgner. All rights reserved.
//

#import "FKAuthorizationContext.h"
#import <OAuthKit/OAuthKit.h>

@interface FKAuthorizationContext ()

@property(strong) OAuthConsumer* internalConsumer;
@property(strong) OAuthToken* internalToken;

@end

@implementation FKAuthorizationContext

__strong static FKAuthorizationContext* _sharedContext;

+ (FKAuthorizationContext *)sharedContext
	{
	static dispatch_once_t once = 0;
	dispatch_once(&once, ^{
		_sharedContext = [[self alloc] init];
        _sharedContext.internalConsumer = [OAuthConsumer consumer];
        _sharedContext.internalToken =[OAuthToken token];
		});
	return _sharedContext;
	}

- (void)setKey:(NSString *)key
	{
	_internalConsumer.key = key;
	}

- (NSString *)key
	{
	return _internalConsumer.key;
	}
	
- (void)setSecret:(NSString *)secret
	{
	_internalConsumer.secret = secret;
	}

- (NSString *)secret
	{
	return _internalConsumer.secret;
	}

- (OAuthToken *)token
	{
	return _internalToken;
	}

- (OAuthConsumer *)consumer
	{
	return _internalConsumer;
	}
	
@end
