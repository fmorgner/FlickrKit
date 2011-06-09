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
#import "NSString+MD5Hash.h"

@interface FlickrAuthorizationController(Private)

- (void)requestFrob;
- (void)authSheetDidClose;

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
	[frobFetcher release];
	}

- (void)authSheetDidClose
	{
	FlickrAsynchronousFetcher* tokenFetcher = [FlickrAsynchronousFetcher new];
	[tokenFetcher fetchDataAtURL:flickrMethodURL(@"flickr.auth.getToken", [NSDictionary dictionaryWithObject:frob forKey:@"frob"], NO) withCompletionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[FlickrAPIResponse class]] && [[(FlickrAPIResponse*)fetchResult status] isEqualToString:@"ok"])
			{
			NSXMLNode* frobNode = [[[(FlickrAPIResponse*)fetchResult xmlContent] nodesForXPath:@"rsp/auth" error:nil] lastObject];
			}
	}];
	[tokenFetcher release];
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
	[self addObserver:self forKeyPath:@"authorizationURL" options:NSKeyValueObservingOptionNew context:NULL];
	[self generateAuthorizationURLForPermission:aPermission];
	}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
	{
	if([keyPath isEqualToString:@"frob"])
		{
		if(!![frob length])
			{
			NSMutableString* urlString = [NSMutableString stringWithFormat:FlickrAuthURL, APIKey, permission, frob];
			NSString* signatureBaseString = [NSMutableString stringWithFormat:@"%@api_key%@frob%@perms%@", APISecret, APIKey, frob, permission];
			NSString* signature = [[signatureBaseString MD5Hash] lowercaseString];
			[urlString appendFormat:@"&api_sig=%@", signature];
			
			self.authorizationURL = [NSURL URLWithString:urlString];
			}
		}
	else if([keyPath isEqualToString:@"authorizationURL"])
		{
		FlickrAuthorizationSheetController* authSheetController = [[FlickrAuthorizationSheetController alloc] initWithWindowNibName:@"FlickrAuthorizationSheetController" authURL:authorizationURL];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authSheetDidClose) name:FlickrAuthorizationSheetDidClose object:nil];
		[authSheetController presentSheet];
		}
	}
@end