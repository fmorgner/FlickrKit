//
//  FlickrComment.h
//  FlickrKit
//
//  Created by Felix Morgner on 27.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKPerson.h"

@interface FKComment : NSObject

- (id)initWithXMLElement:(NSXMLElement*)anElement;

+ (FKComment*)commentWithXMLElement:(NSXMLElement*)anElement;


@property(copy) NSString* ID;
@property(copy) NSString* rawText;
@property(copy) NSString* strippedText;
@property(copy) NSDate* dateCreated;
@property(copy) NSURL* url;

@property(strong) FKPerson* author;

@end
