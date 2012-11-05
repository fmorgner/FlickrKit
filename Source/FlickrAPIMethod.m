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


#import "FlickrAPIMethod.h"
#import <OAuthKit/OAuthKit.h>

@interface FlickrAPIMethod()

- (id)initWithName:(NSString*)aName andParameters:(NSDictionary*)theParameters;
+ (BOOL)methodIsValidWithName:(NSString*)aName andParameters:(NSDictionary*) theParameters error:(NSError**)theError;

@property(strong) NSDictionary* rawParameters;

@end


@implementation FlickrAPIMethod

static NSDictionary* methodParameterTable;

+ (void)initialize
	{
	if(self == [FlickrAPIMethod class])
		{
		NSData* flickrAPIMethodDefinitionsData = [NSData dataWithContentsOfFile:[KitBundle pathForResource:@"FlickrAPIMethodDefinitions" ofType:@"plist"]];
		methodParameterTable = [NSPropertyListSerialization propertyListFromData:flickrAPIMethodDefinitionsData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:nil];
		}
	}

#pragma mark - Public methods

+ (FlickrAPIMethod *)methodWithName:(NSString *)aName andParameters:(NSDictionary *)theParameters error:(NSError**)anError
	{
	FlickrAPIMethod* theMethod = nil;
	__autoreleasing NSError* validityError = nil;
	
	if([FlickrAPIMethod methodIsValidWithName:aName andParameters:theParameters error:&validityError])
		{
		theMethod = [[FlickrAPIMethod alloc] initWithName:aName andParameters:theParameters];
		}
	else
		{
		anError = &validityError;
		}

	return theMethod;
	}

- (NSURL*)methodURL
	{
	NSMutableString* urlString = [NSMutableString stringWithFormat:FlickrAPIBaseURLFormat, _name];
	
	for (NSString* parameter in _rawParameters)
		{
		[urlString appendFormat:@"&%@=%@", parameter, _rawParameters[parameter]];
		}
	
	return [NSURL URLWithString:urlString];
	}

#pragma mark - Private methods

- (id)initWithName:(NSString *)aName andParameters:(NSDictionary *)theParameters
	{
	if((self = [super init]))
		{
		_name = aName;
		_rawParameters = theParameters;
		_oauthParameters = [NSMutableArray arrayWithCapacity:[_rawParameters count]];
		
		for(NSString* parameter in _rawParameters)
			{
			[(NSMutableArray*)_oauthParameters addObject:[OAuthParameter parameterWithKey:parameter andValue:_rawParameters[parameter]]];
			}
		
		}
		
	return self;
	}

+ (BOOL)methodIsValidWithName:(NSString*)aName andParameters:(NSDictionary*) theParameters error:(NSError**)theError
	{
	NSArray* methodParameterSpecification = methodParameterTable[aName];

	if(methodParameterSpecification == nil)
		{
		if(theError != NULL)
			{
			NSDictionary* userInfo = @{NSLocalizedDescriptionKey : NSLocalizedStringFromTableInBundle(@"FlickrAPIMethodErrorUnknownMethodDescription", @"FlickrAPIMethodErrors", KitBundle, @"Unknown method"),
																 NSLocalizedFailureReasonErrorKey : NSLocalizedStringFromTableInBundle(@"FlickrAPIMethodErrorUnknownMethodReason", @"FlickrAPIMethodErrors", KitBundle, @"Unknown method reason"),
																 @"method" : aName
																};
			*theError = [NSError errorWithDomain:FlickrKitAPIMethodErrorDomain code:-1 userInfo:userInfo];
			}
		return NO;
		}

	NSMutableArray* requiredParameters = [NSMutableArray arrayWithCapacity:[methodParameterSpecification count]];
	NSMutableArray* optionalParameters = [NSMutableArray arrayWithCapacity:[methodParameterSpecification count]];
	NSMutableArray* combinedParameters = [NSMutableArray arrayWithCapacity:[methodParameterSpecification count]];
	
	for(NSString* parameter in methodParameterSpecification)
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
	
	for(NSString* parameter in requiredParameters)
		{
		if(!theParameters[parameter])
			{
			if(theError != NULL)
				{
				NSDictionary* userInfo = @{NSLocalizedDescriptionKey : NSLocalizedStringFromTableInBundle(@"FlickrAPIMethodErrorParamterMissingDescription", @"FlickrAPIMethodErrors", KitBundle, @"Missing parameter"),
																	 NSLocalizedFailureReasonErrorKey : NSLocalizedStringFromTableInBundle(@"FlickrAPIMethodErrorParamterMissingReason", @"FlickrAPIMethodErrors", KitBundle, @"Missing parameter reason"),
																	 @"parameter" : parameter
																	};
				*theError = [NSError errorWithDomain:FlickrKitAPIMethodErrorDomain code:-2 userInfo:userInfo];
				return NO;
				}
			}
		}
		
	for(NSString* parameter in theParameters)
		{
		if(![combinedParameters containsObject:parameter])
			{
			if(theError != NULL)
				{
				NSDictionary* userInfo = @{NSLocalizedDescriptionKey : NSLocalizedStringFromTableInBundle(@"FlickrAPIMethodErrorIllegalParameterDescription", @"FlickrAPIMethodErrors", KitBundle, @"Illegal parameter"),
																	 NSLocalizedFailureReasonErrorKey : NSLocalizedStringFromTableInBundle(@"FlickrAPIMethodErrorIllegalParameterReason", @"FlickrAPIMethodErrors", KitBundle, @"Illegal parameter reason"),
																	 @"parameter" : parameter
																	};
				*theError = [NSError errorWithDomain:FlickrKitAPIMethodErrorDomain code:-2 userInfo:userInfo];
			return NO;
				}
			}
		}
	
	return YES;
	}

@end
