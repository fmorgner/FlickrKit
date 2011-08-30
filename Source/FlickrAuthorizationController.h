//
//  FlickrAuthorizationController.h
//  FlickrKit
//
//  Created by Felix Morgner on 14.05.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrAuthorizationSheetController;

@interface FlickrAuthorizationController : NSObject
	{
	@protected
		NSString* frob;
		NSString* permission;
		FlickrAuthorizationSheetController* authorizationSheetController;
	
	@public
		NSURL* authorizationURL;
	}

- (void)generateAuthorizationURLForPermission:(NSString*)aPermission;
- (void)authorizeForPermission:(NSString*)aPermission;

@property(retain) FlickrAuthorizationSheetController* authorizationSheetController;
@property(copy) NSURL* authorizationURL;
@property(copy) NSString* frob;

@end
