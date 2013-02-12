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
#import "NSString+MD5Hash.h"

@interface FKAuthorizationController()

@property NSString* permission;

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
	_permission = [aPermission copy];
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
			}
		}
	else if([keyPath isEqualToString:@"authorizationURL"])
		{
		self.authorizationSheetController = [FKAuthorizationSheetController authorizationSheetControllerWithURL:_authorizationURL];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authSheetDidClose) name:FKNotificationAuthorizationSheetDidClose object:nil];
		[_authorizationSheetController presentSheet];
		}
	}
@end
