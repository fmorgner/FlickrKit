/*
 *
 * FlickrAPIMethodCall.m
 * -------------------------------------------------------------------------
 * begin                 : 2012-07-08
 * copyright             : Copyright (C) 2012 by Felix Morgner
 * email                 : felix.morgner@gmail.com
 * =========================================================================
 *                                                                         |
 *   This program is free software; you can redistribute it and/or modify  |
 *   it under the terms of the GNU General Public License as published by  |
 *   the Free Software Foundation; either version 3 of the License, or     |
 *   (at your option) any later version.                                   |
 *                                                                         |
 *   This program is distributed in the hope that it will be useful,       |
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        |
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         |
 *   GNU General Public License for more details.                          |
 *                                                                         |
 *   You should have received a copy of the GNU General Public License     |
 *   along with this program; if not, write to the                         |
 *                                                                         |
 *   Free Software Foundation, Inc.,                                       |
 *   59 Temple Place Suite 330,                                            |
 *   Boston, MA  02111-1307, USA.                                          |
 * =========================================================================
 *
 */

#import "FlickrAPIMethod.h"
#import "FlickrAPIMethodCall.h"
#import "FlickrAPIResponse.h"
#import "FlickrAuthorizationContext.h"
#import <OAuthKit/OAuthKit.h>

@interface FlickrAPIMethodCall ()

@property(strong) FlickrAuthorizationContext* authorizationContext;
@property(strong) FlickrAPIMethod* APIMethod;

@end

@implementation FlickrAPIMethodCall

- (id)initWithAuthorizationContext:(FlickrAuthorizationContext*)anAuthContext method:(FlickrAPIMethod*)aMethod;
	{
	if((self = [super init]))
		{
		_authorizationContext = anAuthContext;
		_APIMethod = aMethod;
		}

	return self;
	}

+ (FlickrAPIMethodCall*)methodCallWithAuthorizationContext:(FlickrAuthorizationContext*)anAuthContext method:(FlickrAPIMethod*)aMethod;
	{
	return [[FlickrAPIMethodCall alloc] initWithAuthorizationContext:anAuthContext method:aMethod];
	}

- (void)dispatch
  {
	#warning fix this!!!
	OAuthRequest* theRequest = [OAuthRequest requestWithURL:[_APIMethod methodURL] consumer:[_authorizationContext consumer] token:[_authorizationContext token] realm:@"" signerClass:[OAuthSignerHMAC class]];
	
	for(OAuthParameter* parameter in [_APIMethod parameters])
		{
		[theRequest addParameter:parameter];
		}
	
	[theRequest prepare];
	
	if(theRequest.isPrepared)
		{
		OAuthRequestFetcher* theFetcher = [[OAuthRequestFetcher alloc] init];
		[theFetcher fetchRequest:theRequest completionHandler:^(id fetchResult) {
			if([fetchResult isKindOfClass:[NSData class]])
				_completionHandler([FlickrAPIResponse responseWithData:(NSData*)fetchResult]);
		}];
		}
	}

- (void)dispatchWithCompletionHandler:(void (^)(id response))aCompletionHandler
	{
	_completionHandler = aCompletionHandler;
	[self dispatch];
	}
	

@end
