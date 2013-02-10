//
//  NSXMLNode+IntValue.m
//  FlickrKit
//
//  Created by Felix Morgner on 09.02.13.
//  Copyright (c) 2013 Felix Morgner. All rights reserved.
//

#import "NSXMLNode+IntegerValue.h"

@implementation NSXMLNode (IntegerValue)

- (NSInteger)integerValue
  {
  return [self.stringValue integerValue];
  }

@end
