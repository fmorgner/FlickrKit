//
//  FlickrKitHelpers.c
//  FlickrKit
//
//  Created by Felix Morgner on 23.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrKitConstants.h"
#import "FlickrKitResourceManager.h"
#import "NSString+MD5Hash.h"

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

NSString* flickrImageSizeLocalizedString(FlickrImageSize size)
	{
	NSString* returnString = nil;
	NSBundle* kitBundle = [NSBundle bundleWithIdentifier:@"ch.felixmorgner.FlickrKit"];
	
	switch (size)
		{
  case FlickrImageSizeSquare:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeSquare", @"FlickrImageSize", kitBundle, @"The square size");
    break;
  case FlickrImageSizeThumbnail:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeThumbnail", @"FlickrImageSize", kitBundle, @"The thumbnail size");    
    break;
  case FlickrImageSizeSmall:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeSmall", @"FlickrImageSize", kitBundle, @"The small size");    
    break;
  case FlickrImageSizeMedium:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeMedium", @"FlickrImageSize", kitBundle, @"The medium size");    
    break;
  case FlickrImageSizeMedium640:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeMedium640", @"FlickrImageSize", kitBundle, @"The medium 640 size");    
    break;
  case FlickrImageSizeLarge:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeLarge", @"FlickrImageSize", kitBundle, @"The large size");    
    break;
  case FlickrImageSizeOriginal:
		returnString = NSLocalizedStringFromTableInBundle(@"FlickrImageSizeOriginal", @"FlickrImageSize", kitBundle, @"The original size");    
    break;
  default:
    break;
		}
	
	return returnString;
	}

NSURL* flickrMethodURL(NSString* method, NSDictionary* arguments, BOOL sign)
	{
	NSMutableString* argumentString = [NSMutableString string];
	NSMutableString* urlString = [NSMutableString stringWithFormat:FlickrAPIBaseURL, method, APIKey];

	NSArray* sortedKeys = [[arguments allKeys] sortedArrayUsingSelector:@selector(compare:)];

	for(NSString* key in sortedKeys)
		{
		NSString* appendString = [NSString stringWithFormat:@"&%@=%@", key, [arguments valueForKey:key]];
		[argumentString appendString:appendString];
		}
	[urlString appendString:argumentString];
	
	NSMutableDictionary* signatureArgumentSet = [NSMutableDictionary dictionaryWithDictionary:arguments];
	[signatureArgumentSet setObject:method forKey:@"method"];
	[signatureArgumentSet setObject:APIKey forKey:@"api_key"];

	sortedKeys = [[signatureArgumentSet allKeys] sortedArrayUsingSelector:@selector(compare:)];
	NSMutableString* signatureBaseString = [NSMutableString stringWithFormat:@"%@", APISecret];

	for(NSString* key in sortedKeys)
		{
		NSString* appendString = [NSString stringWithFormat:@"%@%@", key, [signatureArgumentSet valueForKey:key]];
		[signatureBaseString appendString:appendString];
		}
	
	NSString* signature = [[signatureBaseString MD5Hash] lowercaseString];
	
	[urlString appendFormat:@"&api_sig=%@", signature];
	
	return [NSURL URLWithString:urlString];
	}
