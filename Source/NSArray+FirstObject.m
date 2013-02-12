//
//  NSArray+FirstObject.m
//  FlickrKit
//
//  Created by Felix Morgner on 09.02.13.
//  Copyright (c) 2013 Felix Morgner. All rights reserved.
//

#import "NSArray+FirstObject.h"

@implementation NSArray (FirstObject)

- (id) firstObject
  {
  return (self.count > 0) ? self[0] : nil;
  }

@end
