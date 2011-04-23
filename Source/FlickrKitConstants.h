//
//  FlickrKitConstants.h
//  FlickrKit
//
//  Created by Felix Morgner on 24.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#define APIKey [(NSObject*)[NSApp delegate] valueForKey:@"apiKey"]

static NSString* FlickrAPIBaseURL = @"http://api.flickr.com/services/rest/?method=%@&api_key=%@";

static NSString* FlickrAPIMethodPhotosGetInfo = @"flickr.photos.getInfo&photo_id=%@";
static NSString* FlickrAPIMethodPhotosGetAllContexts = @"flickr.photos.getAllContexts&photo_id=%@";
static NSString* FlickrAPIMethodPhotosCommentsGetList = @"flickr.photos.comments.getList&photo_id=%@";
static NSString* FlickrAPIMethodPhotosGetFavorites = @"flickr.photos.getFavorites&photo_id=%@";
static NSString* FlickrAPIMethodPhotosGetSizes = @"flickr.photos.getSizes&photo_id=%@";
static NSString* FlickrAPIMethodGalleriesGetListForPhoto = @"flickr.galleries.getListForPhoto&photo_id=%@";
static NSString* FlickrAPIMethodPhotosGetEXIF = @"flickr.photos.getExif&photo_id=%@";
static NSString* FlickrAPIMethodPeopleGetInfo = @"flickr.people.getInfo&user_id=%@";

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

extern NSString* flickrImageSizeString(FlickrImageSize size);
