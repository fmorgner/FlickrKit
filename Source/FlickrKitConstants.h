//
//  FlickrKitConstants.h
//  FlickrKit
//
//  Created by Felix Morgner on 24.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

// This macro allows us to easily retrieve the API key in any place of the framework

#define APIKey [(NSObject*)[NSApp delegate] valueForKey:@"apiKey"]
#define APISecret [(NSObject*)[NSApp delegate] valueForKey:@"apiSecret"]

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
static NSString* FlickrAPIMethodPhotosGetInfo = @"flickr.photos.getInfo&photo_id=%@";

// This method is used to gather all visible pools and sets a photo belongs to.
static NSString* FlickrAPIMethodPhotosGetAllContexts = @"flickr.photos.getAllContexts&photo_id=%@";

// This method is used to gather all comments on a photo.
static NSString* FlickrAPIMethodPhotosCommentsGetList = @"flickr.photos.comments.getList&photo_id=%@";

// This method is used to gather a list of people who favorited a photo.
static NSString* FlickrAPIMethodPhotosGetFavorites = @"flickr.photos.getFavorites&photo_id=%@";

// This method is used to gather a list of URLs for available sizes of a photo.
static NSString* FlickrAPIMethodPhotosGetSizes = @"flickr.photos.getSizes&photo_id=%@";

// This method is used to gather the EXIF information of a photo.
static NSString* FlickrAPIMethodPhotosGetEXIF = @"flickr.photos.getExif&photo_id=%@";

// - flickr.galleries.* methods

// This method is used to gather a list of galleries a photo appears in.
static NSString* FlickrAPIMethodGalleriesGetListForPhoto = @"flickr.galleries.getListForPhoto&photo_id=%@";

// - flickr.people.* methods

// This method is used to gather some information about a person.
static NSString* FlickrAPIMethodPeopleGetInfo = @"flickr.people.getInfo&user_id=%@";

// - Helper functions

// This function returns an NSURL object for a given method which is either singed or not signed
// with a user token. This NSURL object can then be used to call API methods.
//
// This function takes three arguments:
// method: the method to call
// arguments: the arguments for the method
// sign: whether or no to sing the call with a user token

extern NSURL* flickrMethodURL(NSString* method, NSDictionary* arguments, BOOL sign);

// ---- Image size stuff ---- //

// FlickrImageSize enumeration: represents the sizes of images you can fetch from flickr.

typedef enum _FlickrImageSize
	{
  FlickrImageSizeSquare = 1,
	FlickrImageSizeThumbnail = 2,
	FlickrImageSizeSmall = 4,
	FlickrImageSizeMedium = 8,
	FlickrImageSizeMedium640 = 16,
	FlickrImageSizeLarge = 32,
	FlickrImageSizeOriginal = 64,
	} FlickrImageSize;
	
// Returns an NSString object representing the name of the given FlickrImageSize.
// This can be very useful to formulate and xpath query.

extern NSString* flickrImageSizeString(FlickrImageSize size);

// Returns an NSString object containing the localized name of the given FlickrImageSize.
extern NSString* flickrImageSizeLocalizedString(FlickrImageSize size);

// ---- Notifications ---- //

static NSString* FlickrPersonLoadingDidFinishNotification = @"FlickrPersonLoadingDidFinishNotification";