//
//  NSColor+CGColor.m
//  FlickrKit
//
//  Created by Felix Morgner on 27.08.11.
//
//  Code by Bill Dudney
//	http://bill.dudney.net/roller/objc/entry/nscolor_cgcolorref
//

//  This Category isn't needed anymore since 10.8

#if (MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_8)

#import "NSColor+CGColor.h"

@implementation NSColor(CGColor)

- (CGColorRef)CGColor
	{
	CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
  NSInteger componentCount = [self numberOfComponents];
  CGFloat *components = (CGFloat *)calloc(componentCount, sizeof(CGFloat));
  [self getComponents:components];
  CGColorRef color = CGColorCreate(colorSpace, components);
  free((void*)components);
  return (CGColorRef)color;
	}

@end

#endif
