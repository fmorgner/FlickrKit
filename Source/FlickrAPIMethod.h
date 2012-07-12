/*
 *
 * FlickrAPIMethod.h
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

/*!
 * \class FlickrAPIMethod FlickrAPIMethod.h
 * \author Felix Morgner http://www.felixmorgner.ch
 *
 * This class represents API methods. It facilitates all the necessary conformity
 * checks and encapsulates the method very cleanly.
 *
 */

#import <Foundation/Foundation.h>

// The FlickrKitAPIMethodErrorDomain error domain
static NSString* FlickrKitAPIMethodErrorDomain = @"FlickrKitAPIMethodErrorDomain";

@interface FlickrAPIMethod : NSObject

+ (FlickrAPIMethod*)methodWithName:(NSString*)aName andParameters:(NSDictionary*)theParameters error:(NSError**)anError;

@property(strong, readonly) NSString* name;
@property(strong, readonly) NSDictionary* parameters;

@end
