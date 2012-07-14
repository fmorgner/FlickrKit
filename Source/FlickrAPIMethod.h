/*
 *
 * FlickrAPIMethod.h
 * -------------------------------------------------------------------------
 * begin                 : 2012-07-12
 * copyright             : Copyright (C) 2012 by Felix Morgner
 * email                 : felix.morgner@gmail.com
 * =========================================================================
 *                                                                         |
 *   This program is free software; you can redistribute it and/or modify  |
 *   it under the terms of the GNU General Public License as published by  |
 *   the Free Software Foundation; either version 3 of the License, or     |
 *   (at your option) any later version.                                   |
 *                                                                         |
 *   This program is distributed in the hope that it will be useful,       |
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        |
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         |
 *   GNU General Public License for more details.                          |
 *                                                                         |
 *   You should have received a copy of the GNU General Public License     |
 *   along with this program; if not, write to the                         |
 *                                                                         |
 *   Free Software Foundation, Inc.,                                       |
 *   59 Temple Place Suite 330,                                            |
 *   Boston, MA  02111-1307, USA.                                          |
 * =========================================================================
 *
 */

/*!
 * \class FlickrAPIMethod FlickrAPIMethod.h
 * \author Felix Morgner http://www.felixmorgner.ch
 *
 * This class represents API methods. It facilitates all the necessary conformity
 * checks and encapsulates the method very cleanly.
 *
 */

#import <Foundation/Foundation.h>

static NSString* FlickrKitAPIMethodErrorDomain = @"FlickrKitAPIMethodErrorDomain";
static NSString* FlickrAPIBaseURLFormat = @"http://api.flickr.com/services/rest/?method=%@";

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


@interface FlickrAPIMethod : NSObject

+ (FlickrAPIMethod*)methodWithName:(NSString*)aName andParameters:(NSDictionary*)theParameters error:(NSError**)anError;
- (NSURL*)methodURL;

@property(strong, readonly) NSString* name;
@property(strong, readonly) NSArray* parameters;

@end
