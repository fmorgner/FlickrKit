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

@property(strong) FlickrAuthorizationContext* authorizationContext;
@property(strong) FlickrAPIMethod* APIMethod;

@end

@implementation FlickrAPIRequest

- (id)initWithAuthorizationContext:(FlickrAuthorizationContext*)anAuthContext method:(FlickrAPIMethod*)aMethod;
	{
	if((self = [super init]))
		{
		_authorizationContext = anAuthContext;
		_APIMethod = aMethod;
		}

	return self;
	}

+ (FlickrAPIRequest*)requestWithAuthorizationContext:(FlickrAuthorizationContext*)anAuthContext method:(FlickrAPIMethod*)aMethod;
	{
	return [[FlickrAPIRequest alloc] initWithAuthorizationContext:anAuthContext method:aMethod];
	}

- (void)fetch
  {
	}

@end
