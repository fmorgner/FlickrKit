//
//  FlickrPerson.h
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPerson : NSObject
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
	NSMutableData* receivedData;
	}

- (id)initWithXMLElement:(NSXMLElement*)anElement;
+ (FlickrPerson*)personWithXMLElement:(NSXMLElement*)anElement;

- (id)initWithID:(NSString*)anID;
+ (FlickrPerson*)personWithID:(NSString*)anID;

- (void)fetchPersonInformation;
- (void)loadPersonInformationFromXMLElement:(NSXMLElement*)anElement;

@property(nonatomic,retain) NSString* ID;
@property(nonatomic,retain) NSString* username;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* location;
@property(nonatomic,retain) NSDate* firstPhotoTaken;
@property(nonatomic,retain) NSDate* firstPhotoUploaded;
@property(nonatomic,assign) NSUInteger photoCount;
@property(nonatomic,assign,getter = hasProStatus) BOOL proStatus;

@end
