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

// This is the base url for every API call. Every call needs to at least
// have a method and the api_key of the calling application

static NSString* FlickrAPIBaseURL = @"http://api.flickr.com/services/rest/?method=%@&api_key=%@";

// - flickr.photos.* methods

// This method is used to gather some basic information about a photo.
static NSString* FlickrAPIMethodPhotosGetInfo = @"flickr.photos.getInfo";

// This method is used to gather all visible pools and sets a photo belongs to.
static NSString* FlickrAPIMethodPhotosGetAllContexts = @"flickr.photos.getAllContexts";

// This method is used to gather all comments on a photo.
static NSString* FlickrAPIMethodPhotosCommentsGetList = @"flickr.photos.comments.getList";

// This method is used to gather a list of people who favorited a photo.
static NSString* FlickrAPIMethodPhotosGetFavorites = @"flickr.photos.getFavorites";

// This method is used to gather a list of URLs for available sizes of a photo.
static NSString* FlickrAPIMethodPhotosGetSizes = @"flickr.photos.getSizes";

// This method is used to gather the EXIF information of a photo.
static NSString* FlickrAPIMethodPhotosGetEXIF = @"flickr.photos.getExif";

// - flickr.galleries.* methods

// This method is used to gather a list of galleries a photo appears in.
static NSString* FlickrAPIMethodGalleriesGetListForPhoto = @"flickr.galleries.getListForPhoto";

// - flickr.people.* methods

// This method is used to gather some information about a person.
static NSString* FlickrAPIMethodPeopleGetInfo = @"flickr.people.getInfo";

// - flickr.photoset.* methods

// This method is used to gather some information about a photoset
static NSString* FlickrAPIMethodPhotosetGetInfo = @"flickr.photosets.getInfo";

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

static NSString* FlickrPersonLoadingDidFinishNotification = @"FlickrPersonLoadingDidFinishNotification";
static NSString* FlickrAsynchronousFetcherDidFailNotification = @"FlickrAsynchronousFetcherDidFailNotification";
static NSString* FlickrPhotoDidChangeNotification = @"FlickrPhotoDidChangeNotification";
static NSString* FlickrAuthorizationURLDidChangeNotification = @"FlickrAuthorizationURLDidChange";

// ---- Notification userInfo keys ---- //
static NSString* FlickrURLKey = @"url";
static NSString* FlickrHTTPStatusKey = @"HTTPStatus";
static NSString* FlickrDescriptionKey = @"description";

