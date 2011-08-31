//
//  FlickrPerson.h
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

/*!
 * \class FlickrPerson FlickrPerson.h FlickrPerson
 * \author Felix Morgner http://www.felixmorgner.ch
 *
 * A class that represents a person on the flickr.com website. A person is basically a user
 * with attributes like username, name and ID. A FlickrPerson also contains information about
 * the location and the dates the first photo was uploaded and the first photo was taken aswell
 * as the absoloute count of photos this person has updloaded to flickr.com.
 */

#import <Foundation/Foundation.h>

@interface FlickrPerson : NSObject <NSCoding>
	{
/*! @{ 
 * \name Person Information
 */

	NSString* ID; /*!< The ID of a FlickrPerson. This ID uniquely identifies a FlickrPerson. */
	NSString* username; /*!< The username of a FlickrPerson. The username uniquely identifies a FlickrPerson. */
	NSString* name; /*!< The name of a FlickrPerson. The name does _NOT_ uniquely identify a FlickrPerson since multiple people can have the same name.*/
	NSString* location; /*!< The location of a FlickrPerson. The location does _NOT_ uniquely identify a FlickrPerson since multiple people can have the same location.*/
	
	NSDate* firstPhotoTaken; /*!< The date of the oldest photo of a FlickrPerson. Note that this is the oldest in the way that it was taken as the earliest. */
	NSDate* firstPhotoUploaded; /*!< The date of the first uploaded photo of a FlickrPerson. */
	
	NSUInteger photoCount; /*!< The count of photos of a FlickrPerson.*/
	
	BOOL proStatus; /*!< The pro status of a FlickrPerson.*/

/*! @} */
	
	@protected
	short iconServerID;
	short iconFarmID;
	}
	
/*! @{ 
 * \name Object creation
 */

/*!
 * \param anElement A NSXMLElement representing a FlickrPerson
 *
 * \return An initialized FlickrPerson instance with a retaincount of 1
 *
 * \sa FlickrPerson#personWithXMLElement:
 * \sa FlickrPerson#initWithID:
 * \sa FlickrPerson#personWithID:
 *
 * \since 1.0
 *
 * \brief Initialize an instance of FlickrPerson using an NSXMLElement
 *
 * This instance-method initializes a prior allocated instance of FlickrPerson
 * using an XML Element. You can retrieve the required XML data from flickr.com
 * via an API call. Alternatively you can use FlickrPerson#initWithID: if you
 * know the ID of the FlickrPerson you'd like to initialize. FlickrKit internally
 * uses the convenience allocator FlickrPerson#personWithID: to retrieve a
 * FlickrPerson object.
 *
 * Returns nil if the object could not be initialized.
 */
- (id)initWithXMLElement:(NSXMLElement*)anElement;

/*!
 * \param anElement A NSXMLElement representing a FlickrPerson
 *
 * \return An autoreleased FlickrPerson instance
 *
 * \sa FlickrPerson#initWithXMLElement:
 * \sa FlickrPerson#initWithID:
 * \sa FlickrPerson#personWithID:
 *
 * \since 1.0
 *
 * \brief Allocated & Initialize an instance of FlickrPerson using an XML element
 *
 * This class-method returns an autoreleased instance of FlickrPerson
 * using an XML Element. You can retrieve the required XML data from flickr.com
 * via an API call. Alternatively you can use FlickrPerson#personWithID: if you
 * know the ID of the FlickrPerson you'd like to retreive. FlickrKit internally
 * uses the convenience allocator FlickrPerson#personWithID: to retrieve a
 * FlickrPerson object.
 *
 * Returns nil if the object could not be instanciated.
 */
+ (FlickrPerson*)personWithXMLElement:(NSXMLElement*)anElement;

/*!
 * \param anID An ID of a FlickrPerson
 *
 * \return An initialized FlickrPerson instance with a retaincount of 1
 *
 * \sa FlickrPerson#initWithXMLElement:
 * \sa FlickrPerson#personXMLElement:
 * \sa FlickrPerson#personWithID:
 *
 * \since 1.0
 *
 * \brief Initialize an instance of FlickrPerson using an ID
 *
 * This instance-method returns an initialized instance of FlickrPerson
 * using a unique ID. You can retrieve the required ID from flickr.com
 * by for example fetching a comment and using the included author ID.
 * FlickrKit internally uses the convenience allocator FlickrPerson#personWithID:
 * to retrieve a FlickrPerson object.
 *
 * Returns nil if the object could not be initialized.
 */
- (id)initWithID:(NSString*)anID;

/*!
 * \param anID An ID of a FlickrPerson
 *
 * \return An autoreleased FlickrPerson instance
 *
 * \sa FlickrPerson#initWithXMLElement:
 * \sa FlickrPerson#personWitXMLElement:
 * \sa FlickrPerson#initWithID:
 *
 * \since 1.0
 *
 * \brief Allocate & Initialize an instance of FlickrPerson using an XML ID
 *
 * This class-method returns an autoreleased instance of FlickrPerson
 * using a unique ID. You can retrieve the required ID from flickr.com
 * by for example fetching a comment and using the included author ID.
 * FlickrKit internally uses the convenience allocator FlickrPerson#personWithID:
 * to retrieve a FlickrPerson object.
 *
 * Returns nil if the object could not be initialized.
 */
+ (FlickrPerson*)personWithID:(NSString*)anID;

/*! @} */

/*! @{ 
 * \name Information Fetching
 */

/*!
 * \return nothing
 *
 * \sa FlickrPerson#loadPersonInformationFromXMLElement:
 *
 * \since 1.0
 *
 * \brief Fetch the required FlickrPerson information and populate the FlickrPerson instance
 *
 * This instance-method fetches the required information to populate the instance
 * with basic Information like username, name, location, firstPhotoTaken, firstPhotoUploaded
 * and photoCount. This method works in an asynchronous manner using GCD to not block
 * the main loop. This method internally uses FlickrPerson#loadPersonInformationFromXMLElement:
 * to populate the instance.
 */
- (void)fetchPersonInformation;

/*!
 * \param anElement A NSXMLElement containing the FlickrPerson information
 *
 * \return nothing
 *
 * \sa FlickrPerson#fetchPersonInformation:
 * \sa FlickrPerson#personWithID:
 *
 * \since 1.0
 *
 * \brief Populate a FlickrPerson instance with information
 *
 * This instance-method populates the information of a FlickrPerson (username, name
 * location, firstPhotoTaken, firstPhotoUploaded and photoCount) usin the contents of
 * the supplied NSXMLElement. You can fetch the XML data from flickr.com using an API
 * request.
 *
 * Please note that you don't need to call this method. You can call
 * FlickrPerson#personWithID: instead.
 */
- (void)loadPersonInformationFromXMLElement:(NSXMLElement*)anElement;

/*! @} */

@property(nonatomic,copy) NSString* ID;
@property(nonatomic,copy) NSString* username;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* location;
@property(nonatomic,copy) NSDate* firstPhotoTaken;
@property(nonatomic,copy) NSDate* firstPhotoUploaded;
@property(nonatomic,assign) NSUInteger photoCount;
@property(nonatomic,assign,getter = hasProStatus) BOOL proStatus;

@end
