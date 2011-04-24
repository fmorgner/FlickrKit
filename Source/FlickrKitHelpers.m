//
//  FlickrKitHelpers.c
//  FlickrKit
//
//  Created by Felix Morgner on 23.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrKitConstants.h"

NSString* flickrImageSizeString(FlickrImageSize size)
	{
	NSString* returnString = nil;

	switch (size)
		{
  case FlickrImageSizeSquare:
		returnString = @"Square";    
    break;
  case FlickrImageSizeThumbnail:
		returnString = @"Thumbnail";    
    break;
  case FlickrImageSizeSmall:
		returnString = @"Small";    
    break;
  case FlickrImageSizeMedium:
		returnString = @"Medium";    
    break;
  case FlickrImageSizeMedium640:
		returnString = @"Medium 640";    
    break;
  case FlickrImageSizeLarge:
		returnString = @"Large";    
    break;
  case FlickrImageSizeOriginal:
		returnString = @"Original";    
    break;
  default:
    break;
		}
	
	return returnString;
	}

extern NSString* flickrImageSizeLocalizedString(FlickrImageSize size)
	{
	return nil;
	}
