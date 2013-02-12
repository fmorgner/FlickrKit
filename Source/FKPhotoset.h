//
//  FlickrSet.h
//  FlickrKit
//
//  Created by Felix Morgner on 23.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FKPerson;
@class FKPhoto;

@interface FKPhotoset : NSObject

- (id)initWithXMLElement:(NSXMLElement*)anElement;
- (id)initWithID:(NSString*)anID title:(NSString*)aTitle;

+ (FKPhotoset*)setWithXMLElement:(NSXMLElement*)anElement;
+ (FKPhotoset*)setWithID:(NSString*)anID title:(NSString*)atitle;

@property(strong) NSString* ID;
@property(strong) NSString* title;
@property(strong) NSString* desc;
	
@property(assign) NSUInteger photoCount;
	
@property(strong) FKPerson* owner;
@property(strong) NSString* primary;

@end
