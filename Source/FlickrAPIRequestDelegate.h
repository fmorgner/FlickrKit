//
//  FlickrAPIRequestDelegate.h
//  FlickrKit
//
//  Created by Felix Morgner on 08.07.12.
//  Copyright (c) 2012 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrAPIRequest;

@protocol FlickrAPIRequestDelegate <NSObject>

- (void)requestDidFinish:(FlickrAPIRequest*)theRequest;
- (void)request:(FlickrAPIRequest*)theRequest didFailWithError:(NSError*)theError;

@end
