/*
 *
 * FKAPIMethod.h
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
 * \class FKAPIMethod FKAPIMethod.h
 * \author Felix Morgner http://www.felixmorgner.ch
 *
 * This class represents API methods. It facilitates all the necessary conformity
 * checks and encapsulates the method very cleanly. It also implements the means
 * necessary to call itself.
 *
 */

#import <Foundation/Foundation.h>

@class FKAuthorizationContext;

@interface FKAPIMethod : NSObject
  {
  }

+ (FKAPIMethod*)methodWithName:(NSString*)aName parameters:(NSDictionary*)theParameters authorizationContext:(FKAuthorizationContext*)anAuthorizationContext error:(NSError**)anError;

- (void)callWithCompletionHandler:(void(^)(id result))aCompletionHandler;

@property(readonly) NSString* name;
@property(readonly) NSArray* oauthParameters;
@property(readonly) FKAuthorizationContext* authorizationContext;
@property(readonly) void (^completionHandler)(id methodCallResult);

@end
