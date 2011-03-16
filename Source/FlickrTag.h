//
//  FlickrTag.h
//  FlickrKit
//
//  Created by Felix Morgner on 15.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrTag : NSObject
	{
	NSString* author;
	NSString* rawName;
	NSString* name;
	NSString* ID;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;
+ (FlickrTag*)tagWithXMLElement:(NSXMLElement*)anElement;


@property(nonatomic,retain) NSString* author;
@property(nonatomic,retain) NSString* rawName;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* ID;

@end
