//
//  FlickrKitConstants.h
//  FlickrKit
//
//  Created by Felix Morgner on 24.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

// ---- API call URL stuff ---- //

/* 
 * BASICS
 * 
 * There are some basic things to know about API calls.
 * for each API call the current user must have the
 * permissions to access the requested information.
 * This means, that if no user is authenticated,
 * the information must be public, or otherwise can't
 * be fetched.
 *
 * If no information is to be fetched, the user must
 * have the permission to change the requested sttribute
 * or else the call will fail. Some method calls must be
 * singned with a user token.
 * 
 */

// This is the authorization URL. It is used to authorize an application for
// certain permissions on a user account.
static NSString* FlickrAuthURLFormat = @"http://flickr.com/services/auth/?api_key=%@&perms=%@&frob=%@";

// - Helper functions

// This function returns an NSURL object for a given method which is either singed or not signed
// with a user token. This NSURL object can then be used to call API methods.
//
// This function takes three arguments:
// method: the method to call
// arguments: the arguments for the method
// sign: whether or no to sing the call with a user token

extern NSURL* flickrMethodURL(NSString* method, NSDictionary* arguments, BOOL sign);

// ---- Notifications ---- //

static NSString* FlickrAsynchronousFetcherDidFailNotification = @"FlickrAsynchronousFetcherDidFailNotification";
static NSString* FlickrPhotoDidChangeNotification = @"FlickrPhotoDidChangeNotification";
static NSString* FlickrAuthorizationURLDidChangeNotification = @"FlickrAuthorizationURLDidChange";
static NSString* FlickrAuthorizationSheetDidClose = @"FlickrAuthorizationSheedDidClose";
static NSString* FlickrAuthorizationControllerDidReceiveToken = @"FlickrAuthorizationControllerDidReceiveToken";

// ---- Notification userInfo keys ---- //
static NSString* FlickrURLKey = @"url";
static NSString* FlickrHTTPStatusKey = @"HTTPStatus";
static NSString* FlickrDescriptionKey = @"description";
static NSString* FlickrTokenKey = @"token";
