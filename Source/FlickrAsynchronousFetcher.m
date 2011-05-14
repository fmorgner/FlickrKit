//
//  FlickrAsynchronousFetcher.m
//  FlickrKit
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrAsynchronousFetcher.h"
#import "FlickrAPIResponse.h"
#import "FlickrKitConstants.h"

@implementation FlickrAsynchronousFetcher

- (id)init
	{
  if ((self = [super init]))
		{
		receivedData = [NSMutableData new];
    }
    
  return self;
	}

- (void)dealloc
	{
	[url release];
	[completionHandler release];
  [super dealloc];
	}

- (void)fetchDataAtURL:(NSURL*)theURL withCompletionHandler:(void (^)(id fetchResult))block
	{
	if(!block)
		{
		NSException* exception = [NSException exceptionWithName:@"FlickrKitCompletionHandlerNilException" reason:@"The completion handler must not be NULL" userInfo:nil];
		[exception raise];
		return;
		}
	if(!theURL)
		{
		NSException* exception = [NSException exceptionWithName:@"FlickrKitURLNilException" reason:@"The URL must not be nil" userInfo:nil];
		[exception raise];
		return;
		}
	
	url = [theURL copy];
	completionHandler = [block copy];
	
	NSURLRequest* request = [NSURLRequest requestWithURL:url];
	[NSURLConnection connectionWithRequest:request delegate:self];
	}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
	{
	if(((NSHTTPURLResponse*)response).statusCode >= 400)
		{
		NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
		
		[userInfo setObject:url forKey:FlickrURLKey];
		[userInfo setObject:[NSNumber numberWithInteger:((NSHTTPURLResponse*)response).statusCode] forKey:FlickrHTTPStatusKey];
		[userInfo setObject:[NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse*)response).statusCode] forKey:FlickrDescriptionKey];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:FlickrAsynchronousFetcherDidFailNotification object:self userInfo:(NSDictionary*)userInfo];
		}
	}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
	{
	[receivedData appendData:data];
	}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
	{
	FlickrAPIResponse* response = [FlickrAPIResponse responseWithData:receivedData];

	if(response.status)
		completionHandler(response);
	else
		completionHandler(receivedData);

	[receivedData setLength:0];
	}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
	{
	NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
	[userInfo setObject:url forKey:FlickrURLKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FlickrAsynchronousFetcherDidFailNotification object:self userInfo:(NSDictionary*)userInfo];

	completionHandler(error);
	}

@end
