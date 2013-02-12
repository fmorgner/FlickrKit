//
//  FlickrAPIResponse.m
//  FlickrLinks
//
//  Created by Felix Morgner on 03.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FKAPIResponse.h"
#import "NSArray+FirstObject.h"
#import "NSXMLNode+IntegerValue.h"

@interface FKAPIResponse ()

- (id)initWithData:(NSData*)theData error:(NSError**)anError;

@end

@implementation FKAPIResponse

@synthesize status;
@synthesize raw;
@synthesize xml;
@synthesize error;

- (id)initWithData:(NSData*)theData error:(NSError**)anError
	{
	if ((self = [super init]))
		{
		NSError* xmlError;

		raw = [theData copy];
		xml = [[NSXMLDocument alloc] initWithData:theData options:0 error:&xmlError];

		if(xml == nil)
      {
      if(anError != NULL)
        {
        *anError = xmlError;
        }
			return nil;
      }
    
    NSXMLElement* responseNode = (NSXMLElement*)[[xml nodesForXPath:@"rsp" error:&xmlError] lastObject];

		if(xml == nil)
      {
      if(anError != NULL)
        {
        *anError = xmlError;
        }
			return nil;
      }

		status = [[responseNode attributeForName:@"stat"] stringValue];

		if([status isEqualToString:@"fail"])
			{
      NSXMLElement* errorNode = (NSXMLElement*)[[xml nodesForXPath:@"err" error:&xmlError] firstObject];
      
      if(xml == nil)
        {
        if(anError != NULL)
          {
          *anError = xmlError;
          }
        return nil;
        }

			NSString* errorDescription = [[errorNode attributeForName:@"msg"] stringValue];
			NSInteger errorCode        = [[errorNode attributeForName:@"code"] integerValue];

			error = [NSError errorWithDomain:FKErrorDomainAPIResponse code:errorCode userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
			}
		}
	return self;
	}

+ (FKAPIResponse*)responseWithData:(NSData*)theData error:(NSError**)anError
	{
  id response = [[FKAPIResponse alloc] initWithData:theData error:anError];
  
  if(response == nil && anError != NULL)
    {
    *anError = (NSError*)response;
    }

  return response;
	}

@end
