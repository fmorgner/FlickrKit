//
//  FlickrAPIRequestDelegate.h
//  FlickrKit
//
//  Created by Felix Morgner on 08.07.12.
//  Copyright (c) 2012 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrAPIMethodCall;

@protocol FlickrAPIRequestDelegate <NSObject>

- (void)requestDidFinish:(FlickrAPIMethodCall*)theRequest;
- (void)request:(FlickrAPIMethodCall*)theRequest didFailWithError:(NSError*)theError;

@end
