//
//  FlickrUser.m
//  FlickrKit
//
//  Created by Felix Morgner on 14.05.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrUser.h"


@implementation FlickrUser

@synthesize token;

- (id)init
	{
  if ((self = [super init]))
		{
    }
    
	return self;
	}

- (void)dealloc
	{
  [super dealloc];
	}

@end
