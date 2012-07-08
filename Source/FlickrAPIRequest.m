/*
 *
 * FlickrAPIRequest.m
 * -------------------------------------------------------------------------
 * begin                 : 2012-07-08
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

#import "FlickrAPIRequest.h"
#import <OAuthKit/OAuthKit.h>

@interface FlickrAPIRequest ()

- (void)prepareWithError:(NSError**)theError;

@property(strong) FlickrAuthorizationContext* authorizationContext;
@property(strong) NSString* APIMethod;
@property(strong) NSDictionary* methodParameters;

@end

@implementation FlickrAPIRequest

static NSDictionary* methodParameterTable;

+ (void)initialize
	{
	if(self == [FlickrAPIRequest class])
		{
		methodParameterTable = @{ FlickrAPIMethodPhotosGetInfo : @[@"required:photo_id", @"optional:secret"],
															FlickrAPIMethodPhotosGetAllContexts : @[@"required:photo_id"],
															FlickrAPIMethodPhotosGetEXIF : @[@"required:photo_id", @"optional:secret"],
															FlickrAPIMethodPhotosGetFavorites : @[@"required:photo_id", @"optional:page", @"optional:per_page"],
															FlickrAPIMethodPhotosCommentsGetList : @[@"required:photo_id", @"optional:min_comment_date", @"optional:max_comment_date"]
														};
		}
	}

- (id)initWithAuthorizationContext:(FlickrAuthorizationContext*)anAuthContext method:(NSString*)aMethod parameters:(NSDictionary*)theParameters
	{
	if((self = [super init]))
		{
		_authorizationContext = anAuthContext;
		_APIMethod = aMethod;
		_methodParameters = theParameters;
		}

	return self;
	}

+ (FlickrAPIRequest*)requestWithAuthorizationContext:(FlickrAuthorizationContext*)anAuthContext method:(NSString*)aMethod parameters:(NSDictionary*)theParameters
	{
	return [[FlickrAPIRequest alloc] initWithAuthorizationContext:anAuthContext method:aMethod parameters:theParameters];
	}

- (void)fetch
  {
	NSError* preparationError = nil;
	[self prepareWithError:&preparationError];
	}

- (void)prepareWithError:(NSError **)theError
	{
	// Check wether the supplied paramters meet the specification
	NSArray* methodParameterSpecification = methodParameterTable[_APIMethod];

	if(methodParameterSpecification == nil)
		{
		#warning Handle error
		return;
		}

	NSMutableArray* requiredParameters = [NSMutableArray arrayWithCapacity:[methodParameterSpecification count]];
	NSMutableArray* optionalParameters = [NSMutableArray arrayWithCapacity:[methodParameterSpecification count]];

	for(NSString* paramter in methodParameterSpecification)
		{
		if([[[paramter componentsSeparatedByString:@":"] objectAtIndex:0]  isEqualToString:@"required"])
			{
			[requiredParameters addObject:[[paramter componentsSeparatedByString:@":"] objectAtIndex:1]];
			}
		else
			{
			[optionalParameters addObject:[[paramter componentsSeparatedByString:@":"] objectAtIndex:1]];
			}
		}
	
	for(NSString* parameter in requiredParameters)
		{
		if(!_methodParameters[parameter])
			{
			#warning Handle error
			return;
			}
		}
	
	}

@end
