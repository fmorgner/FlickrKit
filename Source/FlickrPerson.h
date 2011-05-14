//
//  FlickrPerson.h
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPerson : NSObject <NSCoding>
	{
	NSString* ID;
	NSString* username;
	NSString* name;
	NSString* location;
	NSDate* firstPhotoTaken;
	NSDate* firstPhotoUploaded;
	NSUInteger photoCount;
	BOOL proStatus;
	
	@protected
	short iconServerID;
	short iconFarmID;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;
+ (FlickrPerson*)personWithXMLElement:(NSXMLElement*)anElement;

- (id)initWithID:(NSString*)anID;
+ (FlickrPerson*)personWithID:(NSString*)anID;

- (void)fetchPersonInformation;
- (void)loadPersonInformationFromXMLElement:(NSXMLElement*)anElement;

@property(nonatomic,copy) NSString* ID;
@property(nonatomic,copy) NSString* username;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* location;
@property(nonatomic,copy) NSDate* firstPhotoTaken;
@property(nonatomic,copy) NSDate* firstPhotoUploaded;
@property(nonatomic,assign) NSUInteger photoCount;
@property(nonatomic,assign,getter = hasProStatus) BOOL proStatus;

@end
