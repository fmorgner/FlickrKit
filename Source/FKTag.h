//
//  FlickrTag.h
//  FlickrKit
//
//  Created by Felix Morgner on 15.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKPerson.h"
#import "FKPersonManager.h"

@interface FKTag : NSObject

- (id)initWithXMLElement:(NSXMLElement*)anElement;
+ (FKTag*)tagWithXMLElement:(NSXMLElement*)anElement;


@property(strong) FKPerson* author;
@property(strong) NSString* rawName;
@property(strong) NSString* name;
@property(strong) NSString* ID;

@end
