//
//  FlickrAPIResponse.m
//  FlickrLinks
//
//  Created by Felix Morgner on 03.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrAPIResponse.h"

@implementation FlickrAPIResponse

@synthesize status;
@synthesize rawContent;
@synthesize xmlContent;
@synthesize error;

- (id)init
	{
	if ((self = [super init]))
		{
		}
	return self;
	}

- (id)initWithData:(NSData*)theData
	{
	if ((self = [super init]))
		{
		NSError* xmlError = nil;

		rawContent = theData;
		xmlContent = [[NSXMLDocument alloc] initWithData:theData options:0 error:&xmlError];

		if(xmlError != nil)
			return nil;
				
		status = [[[[xmlContent nodesForXPath:@"rsp" error:&xmlError] lastObject] attributeForName:@"stat"] stringValue];
		
		if([status isEqualToString:@"fail"])
			{
			NSString* errorDescription = [[[[xmlContent nodesForXPath:@"rsp/err" error:&xmlError] objectAtIndex:0] attributeForName:@"msg"] stringValue];
			NSInteger errorCode = [[[[[xmlContent nodesForXPath:@"rsp/err" error:&xmlError] objectAtIndex:0] attributeForName:@"code"] stringValue] intValue];
			error = [NSError errorWithDomain:kFlickrErrorDomain code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
			}
		}
	return self;
	}

+ (FlickrAPIResponse*)responseWithData:(NSData*)theData;
	{
	return [[[FlickrAPIResponse alloc] initWithData:theData] autorelease];
	}

- (void)dealloc
	{
	[status release];
	[rawContent release];
	[xmlContent release];
	[error release];
	[super dealloc];
	}

@end
