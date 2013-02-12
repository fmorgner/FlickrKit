/*
 *
 * FlickrKitConstants.m
 * -------------------------------------------------------------------------
 * begin                 : 2013-02-11
 * copyright             : Copyright (C) 2013 by Felix Morgner
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

#import "FKConstants.h"

NSString* const FKErrorDomainAPIMethod = @"FKAPIMethodErrorDomain";
NSString* const FKErrorDomainAPIResponse = @"FKErrorDomainAPIResponse";

// ---- BEGIN ---- Flickr API method names ---- //

// flickr.photos.*

NSString* const FKMethodNamePhotosGetInfo = @"flickr.photos.getInfo";
NSString* const FKMethodNamePhotosGetAllContexts = @"flickr.photos.getAllContexts";
NSString* const FKMethodNamePhotosGetContext = @"flickr.photos.getContext";
NSString* const FKMethodNamePhotosCommentsGetList = @"flickr.photos.comments.getList";
NSString* const FKMethodNamePhotosGetFavorites = @"flickr.photos.getFavorites";
NSString* const FKMethodNamePhotosGetSizes = @"flickr.photos.getSizes";
NSString* const FKMethodNamePhotosGetEXIF = @"flickr.photos.getExif";

// flickr.galleries.*

NSString* const FKMethodNameGalleriesGetListForPhoto = @"flickr.galleries.getListForPhoto";

// flickr.people.*

NSString* const FKMethodNamePeopleGetInfo = @"flickr.people.getInfo";

// flickr.photoset.*

NSString* const FKMethodNamePhotosetGetInfo = @"flickr.photosets.getInfo";

// ---- END ---- Flickr API method names ---- //


// ---- Notifications ---- //

NSString* const FKNotificationAsynchronousFetcherDidFail = @"FlickrAsynchronousFetcherDidFailNotification";
NSString* const FKNotificationPhotoDidChange = @"FlickrPhotoDidChangeNotification";
NSString* const FKNotificationAuthorizationURLDidChange = @"FlickrAuthorizationURLDidChange";
NSString* const FKNotificationAuthorizationSheetDidClose = @"FlickrAuthorizationSheedDidClose";
NSString* const FKNotificationAuthorizationControllerDidReceiveToken = @"FlickrAuthorizationControllerDidReceiveToken";
NSString* const FKNotificationPersonDidChange = @"FKNotificationPersonDidChange";

// ---- Notification userInfo keys ---- //
NSString* const FlickrURLKey = @"url";
NSString* const FlickrHTTPStatusKey = @"HTTPStatus";
NSString* const FlickrDescriptionKey = @"description";
NSString* const FlickrTokenKey = @"token";
