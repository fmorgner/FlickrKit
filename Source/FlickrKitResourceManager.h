//
//  FlickrKitResourceManager.h
//  FlickrKit
//
//  Created by Felix Morgner on 17.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrKitTypes.h"

@interface FlickrKitResourceManager : NSObject
	{
	@private
	NSBundle* kitBundle;
	}
	
+ (FlickrKitResourceManager*)sharedManager;

- (NSArray*)imagesForLicense:(FlickrLicense)aLicense;

@end
