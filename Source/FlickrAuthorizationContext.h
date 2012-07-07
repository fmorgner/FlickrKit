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

- (id)initWithToken:(OAuthToken*)aToken;
+	(FlickrAuthorizationContext*)contextWithToken:(OAuthToken*)aToken;

- (id)initWithConsumer:(OAuthConsumer*)aConsumer;
+	(FlickrAuthorizationContext*)contextWithConsumer:(OAuthConsumer*)aConsumer;

@property(strong) OAuthToken* token;
@property(strong) OAuthConsumer* consumer;

@end
