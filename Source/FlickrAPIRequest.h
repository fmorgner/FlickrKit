/*
 *
 * FlickrAPIRequest.h
 * -------------------------------------------------------------------------
 * begin                 : 2012-07-08
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
 * \class FlickrAPIRequest FlickrAPIRequest.h
 * \author Felix Morgner http://www.felixmorgner.ch
 *
 * This class is used to create and dispatch API requests at the flickr.com website.
 * It handles all the necessary steps to call an API method via the public interface.
 */

#import <Foundation/Foundation.h>
#import "FlickrAPIRequestDelegate.h"

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


@class FlickrAuthorizationContext;
@class FlickrAPIMethod;

@interface FlickrAPIRequest : NSObject

/*! @{ 
 * \name Object creation
 */

/*!
 * \param anAuthContext The authorization context which should be used
 * \param aMethod The method that should be called
 *
 * \return An initialized FlickrAPIRequest instance with a retaincount of 1
 *
 * \since 1.1
 *
 * \brief Initialize an instance of FlickrAPIRequest
 *
 * This instance-method initializes a prior allocated instance of FlickrAPIRequest
 * using an authorization context, a method and the associated method parameters.
 *
 * Returns nil if the object could not be initialized.
 */

- (id)initWithAuthorizationContext:(FlickrAuthorizationContext*)anAuthContext method:(FlickrAPIMethod*)aMethod;

/*!
 * \param anAuthContext The authorization context which should be used
 * \param aMethod The method that should be called
 *
 * \return An alocated an initialized FlickrAPIRequest instance with a retaincount of 1
 *
 * \since 1.1
 *
 * \brief Allocate and initialize an instance of FlickrAPIRequest
 *
 * This class-method allocates and initializes an instance of FlickrAPIRequest
 * using an authorization context, a method and the associated method parameters.
 *
 * Returns nil if the object could not be created.
 */

+ (FlickrAPIRequest*)requestWithAuthorizationContext:(FlickrAuthorizationContext*)anAuthContext method:(FlickrAPIMethod*)aMethod;

/*! @} */

/*! @{ 
 * \name Request processing
 */

/*!
 *
 * \return nothing
 *
 * \since 1.1
 *
 * \brief Fetch the request thats being messaged
 *
 * This instance-method fetches the messaged request. You need the either supply a block
 * via the completionHander property, a delegate via the delegate property
 * or listen for notifications.
 *
 */

- (void)fetch;

/*! @} */


/*! @{ 
 * \name Request properties
 */

@property(strong) void (^completionHandler)(id); /*!< The completion handler to be invoked when the request finishes.*/
@property(assign) id<FlickrAPIRequestDelegate> delegate; /*!< The delegate to be called when the request finishes.*/
@property(readonly, getter = isRunning) BOOL running; /*!< The status of the request.*/

/*! @} */

@end
