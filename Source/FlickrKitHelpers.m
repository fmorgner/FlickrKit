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

// Prototypes for 'private' functions

NSString* generateArgumentString(NSDictionary* arguments);

NSString* generateArgumentString(NSDictionary* arguments)
	{
	NSMutableString* argumentString = [NSMutableString string];
	NSArray* sortedKeys = [[arguments allKeys] sortedArrayUsingSelector:@selector(compare:)];

	for(NSString* key in sortedKeys)
		{
		NSString* appendString = [NSString stringWithFormat:@"&%@=%@", key, [arguments valueForKey:key]];
		[argumentString appendString:appendString];
		}
		
	return argumentString;
	}

NSURL* flickrMethodURL(NSString* method, NSDictionary* arguments, BOOL sign)
	{
	NSMutableString* urlString = [NSMutableString stringWithFormat:FlickrAPIBaseURL, method, APIKey];
	NSMutableString* signatureBaseString = [NSMutableString stringWithFormat:@"%@", APISecret];

	NSMutableDictionary* signatureArgumentSet = [NSMutableDictionary dictionaryWithDictionary:arguments];
	[signatureArgumentSet setObject:method forKey:@"method"];
	[signatureArgumentSet setObject:APIKey forKey:@"api_key"];

	[urlString appendString:generateArgumentString(arguments)];

	[signatureBaseString appendFormat:generateArgumentString(signatureArgumentSet)];
	[signatureBaseString replaceOccurrencesOfString:@"&" withString:@"" options:0 range:NSMakeRange(0, [signatureBaseString length])];	
	[signatureBaseString replaceOccurrencesOfString:@"=" withString:@"" options:0 range:NSMakeRange(0, [signatureBaseString length])];	

	NSString* signature = [[signatureBaseString MD5Hash] lowercaseString];
	
	[urlString appendFormat:@"&api_sig=%@", signature];
	
	return [NSURL URLWithString:urlString];
	}
