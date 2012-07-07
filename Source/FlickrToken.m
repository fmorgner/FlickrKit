//
//  FlickrToken.m
//  FlickrKit
//
//  Created by Felix Morgner on 10.06.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrToken.h"
#import "FlickrPerson.h"

@implementation FlickrToken

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
  if ((self = [super init]))
		{
		_tokenString = [[[anElement elementsForName:@"token"] lastObject] stringValue];
		_permissions = [[[anElement elementsForName:@"perms"]	lastObject] stringValue];
		_user = [FlickrPerson personWithID:[[[[anElement elementsForName:@"user"] lastObject] attributeForName:@"nsid"] stringValue]];
    }
    
  return self;
	}

- (id)copyWithZone:(NSZone *)zone
	{
	FlickrToken* copy = nil;
	if((copy = [[FlickrToken allocWithZone:zone] init]))
		{
		copy.tokenString = _tokenString;
		copy.permissions = _permissions;
		copy.user = _user;
		}
	
	return copy;
	}

- (void)encodeWithCoder:(NSCoder *)aCoder
	{
	if([aCoder allowsKeyedCoding])
		{
		[aCoder encodeObject:_tokenString forKey:@"tokenString"];
		[aCoder encodeObject:_permissions forKey:@"permissions"];
		[aCoder encodeObject:_user.ID forKey:@"user.ID"];
		}
	else
		{
		[aCoder encodeObject:_tokenString];
		[aCoder encodeObject:_permissions];
		[aCoder encodeObject:_user.ID];
		}
	}

-(id)initWithCoder:(NSCoder *)aDecoder
	{
  if ((self = [super init]))
		{
		if([aDecoder allowsKeyedCoding])
			{
			_tokenString = [aDecoder decodeObjectForKey:@"tokenString"];
			_permissions = [aDecoder decodeObjectForKey:@"permissions"];
			_user = [FlickrPerson personWithID:[aDecoder decodeObjectForKey:@"user.ID"]];
			}
		else
			{
			_tokenString = [aDecoder decodeObject];
			_permissions = [aDecoder decodeObject];
			_user = [FlickrPerson personWithID:[aDecoder decodeObject]];
			}
		}
		
	return self;
	}

@end
