//
//  FlickrKitHelpers.c
//  FlickrKit
//
//  Created by Felix Morgner on 23.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrKitConstants.h"
#import "FlickrPhoto.h"
#import "NSString+MD5Hash.h"

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
