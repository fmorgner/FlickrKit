/*
 *
 * FKConstants.h
 * -------------------------------------------------------------------------
 * begin                 : 2011-03-24
 * copyright             : Copyright (C) 2011 by Felix Morgner
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

#import <Cocoa/Cocoa.h>

// ---- BEGIN ---- Error domains ---- //

FOUNDATION_EXPORT NSString* const FKErrorDomainAPIMethod;
FOUNDATION_EXPORT NSString* const FKErrorDomainAPIResponse;

// ----  END  ---- Error domains ---- //



// ---- BEGIN ---- Flickr API method names ---- //

FOUNDATION_EXPORT NSString* const FKMethodNamePhotosGetInfo;            // This method is used to gather some basic information about a photo.
FOUNDATION_EXPORT NSString* const FKMethodNamePhotosGetAllContexts;     // This method is used to gather all visible pools and sets a photo belongs to.
FOUNDATION_EXPORT NSString* const FKMethodNamePhotosGetContext;         // This method is used to gather the surrounding photos of a photo
FOUNDATION_EXPORT NSString* const FKMethodNamePhotosCommentsGetList;    // This method is used to gather all comments on a photo.
FOUNDATION_EXPORT NSString* const FKMethodNamePhotosGetFavorites;       // This method is used to gather a list of people who favorited a photo.
FOUNDATION_EXPORT NSString* const FKMethodNamePhotosGetSizes;           // This method is used to gather a list of URLs for available sizes of a photo.
FOUNDATION_EXPORT NSString* const FKMethodNamePhotosGetEXIF;            // This method is used to gather the EXIF information of a photo.

FOUNDATION_EXPORT NSString* const FKMethodNameGalleriesGetListForPhoto; // This method is used to gather a list of galleries a photo appears in.

FOUNDATION_EXPORT NSString* const FKMethodNamePeopleGetInfo;            // This method is used to gather some information about a person.

FOUNDATION_EXPORT NSString* const FKMethodNamePhotosetGetInfo;          // This method is used to gather some information about a photoset

// ----  END  ---- Flickr API method names ---- //



// ---- BEGIN ---- Notifications ---- //

FOUNDATION_EXPORT NSString* const FKNotificationAsynchronousFetcherDidFail;
FOUNDATION_EXPORT NSString* const FKNotificationPhotoDidChange;
FOUNDATION_EXPORT NSString* const FKNotificationAuthorizationURLDidChange;
FOUNDATION_EXPORT NSString* const FKNotificationAuthorizationSheetDidClose;
FOUNDATION_EXPORT NSString* const FKNotificationAuthorizationControllerDidReceiveToken;
FOUNDATION_EXPORT NSString* const FKNotificationPersonDidChange;

// ----  END  ---- Notifications ---- //



// ---- BEGIN ---- Notification userInfo keys ---- //

FOUNDATION_EXPORT NSString* const FKNotificationKeyURL;
FOUNDATION_EXPORT NSString* const FKNotificationKeyHTTPStatus;
FOUNDATION_EXPORT NSString* const FKNotificationKeyDescription;
FOUNDATION_EXPORT NSString* const FKNotificationKeyToken;

// ----  END  ---- Notification userInfo keys ---- //



// ---- BEGIN ---- Error code enumerations ---- //

typedef NS_ENUM(NSUInteger, FKErrorCodesAPIMethod)
  {
  FKErrorCodeAPIUnknownMethod = 1,
  FKErrorCodeAPIMethodMissingParameter = 2,
  FKErrorCodeAPIMethodIllegalParameter = 4
  };

// ----  END  ---- Error code enumerations ---- //



// ---- BEGIN ---- Enumerations ---- //

typedef NS_ENUM(NSUInteger, FKLicenseCode)
	{
  kFlickrLicenseAllRightsReserved = 0,
  kFlickrLicenseCCByNcSa = 1,
	kFlickrLicenseCCByNc = 2,
	kFlickrLicenseCCByNcNd = 3,
	kFlickrLicenseCCBy = 4,
	kFlickrLicenseCCBySa = 5,
	kFlickrLicenseCCByNd = 6,
	kFlickrLicenseNoKnownRestrictions = 7,
	kFlickrLicenseUSGovernmentWork = 8
	};

typedef NS_ENUM(NSUInteger, FKPhotoInformationType)
	{
	kFlickrPhotoInformationEXIF = 1,
	kFlickrPhotoInformationContexts = 2,
	kFlickrPhotoInformationComments = 4,
	kFlickrPhotoInformationFavorites = 8,
	kFlickrPhotoInformationGeneral = 16,
	kFlickrPhotoInformationAll = 31
	};

typedef NS_ENUM(NSUInteger, FKImageSize)
	{
  kFlickrImageSizeSquare = 1,
	kFlickrImageSizeThumbnail = 2,
	kFlickrImageSizeSmall = 4,
	kFlickrImageSizeMedium = 8,
	kFlickrImageSizeMedium640 = 16,
	kFlickrImageSizeLarge = 32,
	kFlickrImageSizeOriginal = 64,
	};

// ----  END  ---- Enumerations ---- //
