//
//  FlickrSet.h
//  FlickrKit
//
//  Created by Felix Morgner on 23.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrPerson;
@class FlickrPhoto;

@interface FlickrSet : NSObject
	{
	NSString* ID;
	NSString* title;
	NSString* desc;
	
	NSUInteger photoCount;
	
	FlickrPerson* owner;
	FlickrPhoto* primary;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;
- (id)initWithID:(NSString*)anID title:(NSString*)aTitle;

+ (FlickrSet*)setWithXMLElement:(NSXMLElement*)anElement;
+ (FlickrSet*)setWithID:(NSString*)anID title:(NSString*)atitle;

@property(nonatomic, retain) NSString* ID;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* desc;
	
@property(nonatomic, assign) NSUInteger photoCount;
	
@property(nonatomic, retain) FlickrPerson* owner;
@property(nonatomic, retain) FlickrPhoto* primary;


@end
