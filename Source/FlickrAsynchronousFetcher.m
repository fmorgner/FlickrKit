//
//  FlickrAsynchronousFetcher.m
//  FlickrKit
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrAsynchronousFetcher.h"
#import "FlickrAPIResponse.h"

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
	[receivedData setLength:0];
	
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
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
	{
	[receivedData appendData:data];
	}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
	{
	FlickrAPIResponse* response = [[FlickrAPIResponse alloc] initWithData:receivedData];
	
	if(response.status)
		completionHandler(response);
	else
		completionHandler(receivedData);
	}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
	{
	completionHandler(error);
	}

@end
