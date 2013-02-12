//
//  FlickrAuthorizationController.m
//  FlickrKit
//
//  Created by Felix Morgner on 14.05.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FKAuthorizationController.h"
#import "FKAuthorizationSheetController.h"
#import "FKAPIResponse.h"
#import "FlickrToken.h"
#import "NSString+MD5Hash.h"

@interface FKAuthorizationController(Private)

- (void)requestFrob;
- (void)authSheetDidClose;

@end

@implementation FKAuthorizationController

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
/*
			NSMutableString* urlString = [NSMutableString stringWithFormat:@"%@%@%@%@", FlickrAuthURLFormat, APIKey, permission, _frob];
			NSString* signatureBaseString = [NSMutableString stringWithFormat:@"%@api_key%@frob%@perms%@", APISecret, APIKey, _frob, permission];
			NSString* signature = [[signatureBaseString MD5Hash] lowercaseString];
			[urlString appendFormat:@"&api_sig=%@", signature];
			
			self.authorizationURL = [NSURL URLWithString:urlString];
*/			}
		}
	else if([keyPath isEqualToString:@"authorizationURL"])
		{
		self.authorizationSheetController = [FKAuthorizationSheetController authorizationSheetControllerWithURL:authorizationURL];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authSheetDidClose) name:FKNotificationAuthorizationSheetDidClose object:nil];
		[_authorizationSheetController presentSheet];
		}
	}
@end
