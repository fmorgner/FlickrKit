//
//  FlickrTag.h
//  FlickrKit
//
//  Created by Felix Morgner on 15.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrPerson.h"
#import "FlickrPersonManager.h"

@interface FlickrTag : NSObject
	{
	FlickrPerson* author;
	NSString* rawName;
	NSString* name;
	NSString* ID;
	
	@protected
	FlickrPersonManager* personManager;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;
+ (FlickrTag*)tagWithXMLElement:(NSXMLElement*)anElement;


@property(nonatomic,strong) FlickrPerson* author;
@property(nonatomic,strong) NSString* rawName;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* ID;

@end
