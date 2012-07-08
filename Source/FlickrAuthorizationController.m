//
//  FlickrAuthorizationController.m
//  FlickrKit
//
//  Created by Felix Morgner on 14.05.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrAuthorizationController.h"
#import "FlickrAuthorizationSheetController.h"
#import "FlickrKitConstants.h"
#import "FlickrAsynchronousFetcher.h"
#import "FlickrAPIResponse.h"
#import "FlickrToken.h"
#import "NSString+MD5Hash.h"

@interface FlickrAuthorizationController(Private)

- (void)requestFrob;
- (void)authSheetDidClose;

@end

@implementation FlickrAuthorizationController

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
	}

- (void)generateAuthorizationURLForPermission:(NSString*)aPermission
	{
	permission = [aPermission copy];
	[self requestFrob];
	}
	
- (void)authorizeForPermission:(NSString*)aPermission
	{
	[self addObserver:self forKeyPath:@"authorizationURL" options:NSKeyValueObservingOptionNew context:NULL];
	[self generateAuthorizationURLForPermission:aPermission];
	}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
	{
	if([keyPath isEqualToString:@"frob"])
		{
		if(!![_frob length])
			{
			NSMutableString* urlString = [NSMutableString stringWithFormat:@"%@%@%@%@", FlickrAuthURLFormat, APIKey, permission, _frob];
			NSString* signatureBaseString = [NSMutableString stringWithFormat:@"%@api_key%@frob%@perms%@", APISecret, APIKey, _frob, permission];
			NSString* signature = [[signatureBaseString MD5Hash] lowercaseString];
			[urlString appendFormat:@"&api_sig=%@", signature];
			
			self.authorizationURL = [NSURL URLWithString:urlString];
			}
		}
	else if([keyPath isEqualToString:@"authorizationURL"])
		{
		self.authorizationSheetController = [FlickrAuthorizationSheetController authorizationSheetControllerWithURL:authorizationURL];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authSheetDidClose) name:FlickrAuthorizationSheetDidClose object:nil];
		[_authorizationSheetController presentSheet];
		}
	}
@end

@implementation FlickrAuthorizationController(Private)

- (void)requestFrob
	{
	FlickrAsynchronousFetcher* frobFetcher = [FlickrAsynchronousFetcher new];
	[frobFetcher fetchDataAtURL:flickrMethodURL(@"flickr.auth.getFrob", nil, NO) withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSXMLNode* frobNode = [[[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/frob" error:nil] lastObject];
			self.frob = [frobNode stringValue];
			}
	}];
	}

- (void)authSheetDidClose
	{
	FlickrAsynchronousFetcher* tokenFetcher = [FlickrAsynchronousFetcher new];
	[tokenFetcher fetchDataAtURL:flickrMethodURL(@"flickr.auth.getToken", @{@"frob": _frob}, NO) withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSXMLNode* tokenNode = [[[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/auth" error:nil] lastObject];
			FlickrToken* token = [[FlickrToken alloc] initWithXMLElement:(NSXMLElement*)tokenNode];
			[[NSNotificationCenter defaultCenter] postNotificationName:FlickrAuthorizationControllerDidReceiveToken object:self userInfo:@{FlickrTokenKey: [token copy]}];
			}
	}];
	}

@end
