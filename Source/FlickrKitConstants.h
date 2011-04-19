//
//  FlickrKitConstants.h
//  FlickrKit
//
//  Created by Felix Morgner on 24.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

static NSString* FlickrAPIBaseURL = @"http://api.flickr.com/services/rest/?method=%@&api_key=%@";



static NSString* FlickrAPIMethodPhotosGetInfo = @"flickr.photos.getInfo";
static NSString* FlickrAPIMethodPhotosGetAllContexts = @"flickr.photos.getAllContexts";
static NSString* FlickrAPIMethodPhotosCommentsGetList = @"flickr.photos.comments.getList";
static NSString* FlickrAPIMethodPhotosGetFavorites = @"flickr.photos.getFavorites";
static NSString* FlickrAPIMethodPhotosGetSizes = @"flickr.photos.getSizes";
static NSString* FlickrAPIMethodGalleriesGetListForPhoto = @"flickr.galleries.getListForPhoto";
static NSString* FlickrAPIMethodPeopleGetInfo = @"flickr.people.getInfo";
static NSString* FlickrAPIMethodPhotosGetEXIF = @"flickr.photos.getExif&photo_id=%@";