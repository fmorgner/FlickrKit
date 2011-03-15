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
	
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;
- (FlickrTag*)tagWithXMLElement:(NSXMLElement*)anElement;


@property(nonatomic,copy) NSString* author;
@property(nonatomic,copy) NSString* rawName;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* ID;

@end
