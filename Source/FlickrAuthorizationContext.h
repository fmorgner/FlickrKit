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

@property(strong) OAuthToken* token;
@property(strong) OAuthConsumer* consumer;

@end
