//
//  FlickrAuthorizationController.h
//  FlickrKit
//
//  Created by Felix Morgner on 14.05.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FKAuthorizationSheetController;

@interface FKAuthorizationController : NSObject
	{
  }

- (void)generateAuthorizationURLForPermission:(NSString*)aPermission;
- (void)authorizeForPermission:(NSString*)aPermission;

@property(strong) FKAuthorizationSheetController* authorizationSheetController;
@property(copy) NSURL* authorizationURL;
@property(copy) NSString* frob;

@end
