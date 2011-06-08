//
//  FlickrAuthorizationController.m
//  FlickrKit
//
//  Created by Felix Morgner on 14.05.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrAuthorizationController.h"
#import "FlickrKitConstants.h"
#import "FlickrAsynchronousFetcher.h"
#import "FlickrAPIResponse.h"

@interface FlickrAuthorizationController(Private)

- (void)requestFrob;

@end

@implementation FlickrAuthorizationController(Private)

- (void)requestFrob
	{
	FlickrAsynchronousFetcher* frobFetcher = [FlickrAsynchronousFetcher new];
	[frobFetcher fetchDataAtURL:flickrMethodURL(@"flickr.auth.getFrob", nil, NO) withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSXMLNode* frobNode = [[[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/frob" error:nil] lastObject];
			frob = [[frobNode stringValue] copy];
			}
	}];
	}

@end

@implementation FlickrAuthorizationController

@synthesize authorizationURL, frob;

- (id)init
	{
	if ((self = [super init]))
		{
		[self addObserver:self forKeyPath:@"frob" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
  return self;
	}

- (void)dealloc
	{
	[self removeObserver:self forKeyPath:@"frob"];
	[frob release];
	[permission release];
	[authorizationURL release];
  [super dealloc];
	}

- (void)generateAuthorizationURLForPermission:(NSString*)aPermission
	{
	permission = [aPermission copy];
	[self requestFrob];
	}
	
- (void)authorizeForPermission:(NSString*)aPermission
	{
	
	}

@end
