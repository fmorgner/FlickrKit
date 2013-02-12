/*
 *
 * FlickrAPIMethod.m
 * -------------------------------------------------------------------------
 * begin                 : 2012-07-12
 * copyright             : Copyright (C) 2012 by Felix Morgner
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

#import "FKAPIMethod.h"
#import "FKAuthorizationContext.h"
#import "FKAPIResponse.h"

#import <OAuthKit/OAuthKit.h>

@interface FKAPIMethod()

- (id)initWithName:(NSString*)aName parameters:(NSDictionary*)theParameters authorizationContext:(FKAuthorizationContext*)anAuthorizationContext;
+ (BOOL)methodIsValidWithName:(NSString*)aName andParameters:(NSDictionary*) theParameters error:(NSError**)theError;
- (NSURL*)methodURL;

@property(strong) NSDictionary* rawParameters;
@property(strong) NSString* name;
@property(strong) NSArray* oauthParameters;
@property(strong) FKAuthorizationContext* authorizationContext;
@property(strong) void (^completionHandler)(id methodCallResult);

@end

@implementation FKAPIMethod

static NSDictionary* methodParameterAssociationDictionary;

+ (void)initialize
	{
	if(self == [FKAPIMethod class])
		{
		NSData* flickrAPIMethodDefinitionsData = [NSData dataWithContentsOfFile:[KitBundle pathForResource:@"FlickrAPIMethodDefinitions" ofType:@"plist"]];
		methodParameterAssociationDictionary = [NSPropertyListSerialization propertyListFromData:flickrAPIMethodDefinitionsData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:nil];
		}
	}

#pragma mark - Public methods

+ (FKAPIMethod*)methodWithName:(NSString *)aName parameters:(NSDictionary *)theParameters authorizationContext:(FKAuthorizationContext*)anAuthorizationContext error:(NSError**)anError
	{
	FKAPIMethod* theMethod = nil;
  NSError* validityError;
	
	if([FKAPIMethod methodIsValidWithName:aName andParameters:theParameters error:&validityError])
		{
		theMethod = [[FKAPIMethod alloc] initWithName:aName parameters:theParameters authorizationContext:anAuthorizationContext];
		}
	else
		{
    if(anError != NULL)
      {
      *anError = validityError;
      }
		}

	return theMethod;
	}

- (void)callWithCompletionHandler:(void (^)(id))aCompletionHandler
  {
  self.completionHandler = aCompletionHandler;
  
	OAuthRequest* theRequest = [OAuthRequest requestWithURL:[self methodURL] consumer:[_authorizationContext consumer] token:[_authorizationContext token] realm:@"" signerClass:[OAuthSignerHMAC class]];
	[theRequest addParameters:self.oauthParameters];
	[theRequest prepare];
	
	if(theRequest.isPrepared)
		{
		OAuthRequestFetcher* theFetcher = [[OAuthRequestFetcher alloc] init];
    
		[theFetcher fetchRequest:theRequest completionHandler:^(id fetchResult) {
			
      dispatch_retain(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
			
			if([fetchResult isKindOfClass:[NSData class]])
				{
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				_completionHandler([FKAPIResponse responseWithData:(NSData*)fetchResult error:nil]);
				dispatch_release(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
				});
				}
			else
				{
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				_completionHandler((NSError*)fetchResult);
				dispatch_release(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
				});
				}

      self.completionHandler = NULL;
		}];
		}
  }

#pragma mark - Private methods

- (id)initWithName:(NSString *)aName parameters:(NSDictionary *)theParameters authorizationContext:(FKAuthorizationContext*)anAuthorizationContext
	{
	if((self = [super init]))
		{
		self.name = aName;
		self.rawParameters = theParameters;
		self.oauthParameters = [NSMutableArray arrayWithCapacity:[_rawParameters count]];
    self.authorizationContext = anAuthorizationContext;
		
		for(NSString* parameter in _rawParameters)
			{
			[(NSMutableArray*)_oauthParameters addObject:[OAuthParameter parameterWithKey:parameter andValue:_rawParameters[parameter]]];
			}
		}
		
	return self;
	}

- (NSURL*)methodURL
	{
	NSMutableString* urlString = [NSMutableString stringWithFormat:@"http://api.flickr.com/services/rest/?method=%@", _name];
	
	for (NSString* parameter in _rawParameters)
		{
		[urlString appendFormat:@"&%@=%@", parameter, _rawParameters[parameter]];
		}
	
	return [NSURL URLWithString:urlString];
	}

+ (BOOL)methodIsValidWithName:(NSString*)aName andParameters:(NSDictionary*)theParameters error:(NSError**)theError
	{
	NSArray* methodParameterAssociation = methodParameterAssociationDictionary[aName];

	if(methodParameterAssociation == nil)
		{
		if(theError != NULL)
			{
			NSDictionary* userInfo = @{NSLocalizedDescriptionKey        : NSLocalizedStringFromTableInBundle(@"FKErrorDescriptionUnknownMethod", @"FKErrorsAPIMethod", KitBundle, @"Unknown method"),
																 NSLocalizedFailureReasonErrorKey : NSLocalizedStringFromTableInBundle(@"FKErrorReasonUnknownMethod",      @"FKErrorsAPIMethod", KitBundle, @"Unknown method reason"),
																 @"method"                        : aName
																};
			*theError = [NSError errorWithDomain:FKErrorDomainAPIMethod code:FKErrorCodeAPIUnknownMethod userInfo:userInfo];
			}
		return NO;
		}

	NSMutableArray* requiredParameters = [NSMutableArray arrayWithCapacity:[methodParameterAssociation count]];
	NSMutableArray* optionalParameters = [NSMutableArray arrayWithCapacity:[methodParameterAssociation count]];
	NSMutableArray* combinedParameters = [NSMutableArray arrayWithCapacity:[methodParameterAssociation count]];
	
	for(NSString* parameter in methodParameterAssociation)
		{
		if([[[parameter componentsSeparatedByString:@":"] objectAtIndex:0]  isEqualToString:@"required"])
			{
			[requiredParameters addObject:[[parameter componentsSeparatedByString:@":"] objectAtIndex:1]];
			}
		else if([[[parameter componentsSeparatedByString:@":"] objectAtIndex:0]  isEqualToString:@"optional"])
			{
			[optionalParameters addObject:[[parameter componentsSeparatedByString:@":"] objectAtIndex:1]];
			}
		
		[combinedParameters addObject:[[parameter componentsSeparatedByString:@":"] objectAtIndex:1]];
		}
	
	for(NSString* aParameter in requiredParameters)
		{
		if(!theParameters[aParameter])
			{
			if(theError != NULL)
				{
				NSDictionary* userInfo = @{NSLocalizedDescriptionKey        : NSLocalizedStringFromTableInBundle(@"FKErrorDescriptionMissingParameter", @"FKErrorsAPIMethod", KitBundle, @"Missing parameter"),
																	 NSLocalizedFailureReasonErrorKey : NSLocalizedStringFromTableInBundle(@"FKErrorReasonMissingParameter",      @"FKErrorsAPIMethod", KitBundle, @"Missing parameter reason"),
																	 @"parameter"                     : aParameter
																	};
				*theError = [NSError errorWithDomain:FKErrorDomainAPIMethod code:FKErrorCodeAPIMethodMissingParameter userInfo:userInfo];
				}
      return NO;
			}
		}
		
	for(NSString* aParameter in theParameters)
		{
		if(![combinedParameters containsObject:aParameter])
			{
			if(theError != NULL)
				{
				NSDictionary* userInfo = @{NSLocalizedDescriptionKey        : NSLocalizedStringFromTableInBundle(@"FKErrorDescriptionIllegalParameter", @"FKErrorsAPIMethod", KitBundle, @"Illegal parameter"),
																	 NSLocalizedFailureReasonErrorKey : NSLocalizedStringFromTableInBundle(@"FKErrorReasonIllegalParameter",      @"FKErrorsAPIMethod", KitBundle, @"Illegal parameter reason"),
																	 @"parameter"                     : aParameter
																	};
				*theError = [NSError errorWithDomain:FKErrorDomainAPIMethod code:FKErrorCodeAPIMethodIllegalParameter userInfo:userInfo];
				}
      return NO;
			}
		}
	
	return YES;
	}

@end
