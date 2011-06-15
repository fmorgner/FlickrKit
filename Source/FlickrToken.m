//
//  FlickrToken.m
//  FlickrKit
//
//  Created by Felix Morgner on 10.06.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrToken.h"
#import "FlickrPerson.h"
#import "FlickrPersonManager.h"

@implementation FlickrToken

@synthesize tokenString, user, permissions;

- (id)initWithXMLElement:(NSXMLElement*)anElement
	{
  if ((self = [super init]))
		{
		self.tokenString = [[[anElement elementsForName:@"token"] lastObject] stringValue];
		self.permissions = [[[anElement elementsForName:@"perms"]	lastObject] stringValue];
		self.user = [[FlickrPersonManager sharedManager] personForID:[[[[anElement elementsForName:@"user"] lastObject] attributeForName:@"nsid"] stringValue]];
    }
    
  return self;
	}

- (id)copyWithZone:(NSZone *)zone
	{
	FlickrToken* copy = nil;
	if((copy = [[FlickrToken allocWithZone:zone] init]))
		{
		copy.tokenString = self.tokenString;
		copy.permissions = self.permissions;
		copy.user = self.user;
		}
	
	return copy;
	}

@end
