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

@interface FlickrPhotoset : NSObject
	{
	NSString* ID;
	NSString* title;
	NSString* desc;
	NSString* primary;
	
	NSUInteger photoCount;
	
	FlickrPerson* owner;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;
- (id)initWithID:(NSString*)anID title:(NSString*)aTitle;

+ (FlickrPhotoset*)setWithXMLElement:(NSXMLElement*)anElement;
+ (FlickrPhotoset*)setWithID:(NSString*)anID title:(NSString*)atitle;

@property(nonatomic, retain) NSString* ID;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* desc;
	
@property(nonatomic, assign) NSUInteger photoCount;
	
@property(nonatomic, retain) FlickrPerson* owner;
@property(nonatomic, retain) NSString* primary;


@end
