//
//  FlickrAuthorizationContext.h
//  FlickrKit
//
//  Created by Felix Morgner on 24.01.12.
//  Copyright (c) 2012 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OAuthToken;
@class OAuthConsumer;

@interface FlickrAuthorizationContext : NSObject

+ (FlickrAuthorizationContext*)sharedContext;

@property(readonly) OAuthToken* token;
@property(readonly) OAuthConsumer* consumer;
@property(strong) NSString* key;
@property(strong) NSString* secret;

@end
