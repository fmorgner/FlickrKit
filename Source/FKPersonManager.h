//
//  FlickrPersonManager.h
//  FlickrKit
//
//  Created by Felix Morgner on 16.03.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

/*!
 * \class FlickrPersonManager FlickrPersonManager.h FlickrPersonManager
 * \author Felix Morgner http://www.felixmorgner.ch
 *
 * A Class that manages instances of FlickrPerson. You can use this class
 * to manage all the FlickrPerson instances connected to photos (FlickrPhoto),
 * comments (FlickrComment), tags (FlickrTag) and photosets (FlickrPhotoset).
 * Its very simple to use the person manager. You first obtain a reference to
 * the shared singleton instacne of the manager by calling
 * FlickrPersonManager#sharedManager:. Afterwards you can obtain references or
 * arrays of references to specific FlickrPerson instances by simply calling
 * one of the search methods. Please note that the FlickrKit internally uses
 * the manager to most efficiently handle to occurence of duplicate FlickrPerson
 * by not allocating a new FlickrPerson if there already exist an instance of
 * it.
 */

#import <Foundation/Foundation.h>
#import "FKPerson.h"

@interface FKPersonManager : NSObject
	{
	@private
		NSMutableArray* people;
	}

/*! @{ 
 * \name Singleton Instance Access
 */

/*!
 * \since 1.0
 *
 * \brief Obtain the shared FlickrPersonManager
 *
 * This class-method provides you with the singleton instance
 * of the FlickrPersonManager. You can use the returned reference to either
 * aquire the list of all FlickrPerson instances currently alive or a subset
 * of them.
 */
+ (FKPersonManager*)sharedManager;

/*!
 * @}
 */

/*! @{ 
 * \name Person Access & Searching
 */

/*!
 * \return An autoreleased NSArray instance
 *
 * \sa FlickrPersonManager#addPerson:
 * \sa FlickrPersonManager#removePerson:
 * \sa FlickrPersonManager#peopleForName:
 * \sa FlickrPersonManager#peopleForLocation:
 * \sa FlickrPersonManager#peopleForProStatus:
 * \sa FlickrPersonManager#personForID:
 * \sa FlickrPersonManager#personForUsername:
 *
 * \since 1.0
 *
 * \brief Access all FlickrPerson instances currently alive
 *
 * This instance-method provides you with an array of instances of FlickrPerson
 * currently alive. Please note that the FlickrPersonManager retains the
 * FlickrPerson instances that you add to it. So please make sure you remove
 * them when you don't need them anymore.
 */
- (NSArray*)people;

/*!
 * \param anID An ID of a FlickrPerson
 *
 * \return A pointer to an instance of FlickrPerson
 *
 * \sa FlickrPersonManager#peopleForName:
 * \sa FlickrPersonManager#peopleForLocation:
 * \sa FlickrPersonManager#peopleForProStatus:
 * \sa FlickrPersonManager#personForUsername:
 *
 * \since 1.0
 *
 * \brief Search the manager for an instance of FlickrPerson with a specific ID
 *
 * This instance-method lets you search for an instance of FlickrPerson with a
 * specific ID. The ID is unique for every FlickrPerson and thefore uniquely
 * identifies each FlickrPerson.
 */
- (FKPerson*)personForID:(NSString*)anID;

/*!
 * \param anUsername An username of a FlickrPerson
 *
 * \return A pointer to an instance of FlickrPerson
 *
 * \sa FlickrPersonManager#peopleForName:
 * \sa FlickrPersonManager#peopleForLocation:
 * \sa FlickrPersonManager#peopleForProStatus:
 * \sa FlickrPersonManager#personForID:
 *
 * \since 1.0
 *
 * \brief Search the manager for an instance of FlickrPerson with a specific username
 *
 * This instance-method lets you search for an instance of FlickrPerson with a
 * specific username. The username is unique for every FlickrPerson and thefore
 * uniquely identifies each FlickrPerson. Please note that there is _NO_ technical
 * relation between the username and the name of a FlickrPerson.
 * 
 */
- (FKPerson*)personForUsername:(NSString*)anUsername;

/*!
 * \param aName A name of a FlickrPerson
 *
 * \return An instance of NSArray containing instaces of FlickrPerson
 *
 * \sa FlickrPersonManager#peopleForLocation:
 * \sa FlickrPersonManager#peopleForProStatus:
 * \sa FlickrPersonManager#personForID:
 * \sa FlickrPersonManager#personForUsername:
 *
 * \since 1.0
 *
 * \brief Search the manager for all FlickPerson instances with a given name
 *
 * This instance-method lets you search the manager for all FlickrPerson instances
 * with a given name. Please note that the name does _NOT_ uniquely identify a
 * FlickrPerson.
 */
- (NSArray*)peopleForName:(NSString*)aName;

/*!
 * \param aLocation A location of a FlickrPerson
 *
 * \return An instance of NSArray containing instaces of FlickrPerson
 *
 * \sa FlickrPersonManager#peopleForName:
 * \sa FlickrPersonManager#peopleForProStatus:
 * \sa FlickrPersonManager#personForID:
 * \sa FlickrPersonManager#personForUsername:
 *
 * \since 1.0
 *
 * \brief Search the manager for all FlickPerson instances at a given location
 *
 * This instance-method lets you search the manager for all FlickrPerson instances
 * at a given location. Please note that the location does _NOT_ uniquely identify a
 * FlickrPerson.
 */
- (NSArray*)peopleForLocation:(NSString*)aLocation;

/*!
 * \param theStatus The pro status of a FlickrPerson
 *
 * \return An instance of NSArray containing instaces of FlickrPerson
 *
 * \sa FlickrPersonManager#peopleForName:
 * \sa FlickrPersonManager#peopleForLocation:
 * \sa FlickrPersonManager#personForID:
 * \sa FlickrPersonManager#personForUsername:
 *
 * \since 1.0
 *
 * \brief Search the manager for all FlickPerson instances with a given pro status
 *
 * This instance-method lets you search the manager for all FlickrPerson instances
 * with a given pro status. Please note that the pro status does _NOT_ uniquely
 * identify a FlickrPerso.
 */
- (NSArray*)peopleForProStatus:(BOOL)theStatus;

/*!
 * @}
 */

/*! @{ 
 * \name Person Management
 */

/*!
 * \param aPerson The FlickrPerson instance you'd like to add to the manager
 *
 * \return A BOOL indicating success or error
 *
 * \sa FlickrPersonManager#removePerson:
 *
 * \since 1.0
 *
 * \brief Add a specified FlickrPerson instance to the manager
 *
 * This instance-method lets you add an instance of FlickrPerson to the manager.
 * Please note that the manager retains the supplied FlickrPerson instance. Therefore
 * each added instance must be removed using the -(BOOL)removePerson: instance-method.
 *
 * Returns NO if the supplied instance could not be added from the manager.
 */
- (BOOL)addPerson:(FKPerson*)aPerson;

/*!
 * \param aPerson The FlickrPerson instance you'd like to remove from the manager
 *
 * \return A BOOL indicating success or error
 *
 * \sa FlickrPersonManager#addPerson:
 *
 * \since 1.0
 *
 * \brief Remove a specified FlickrPerson instance from the manager
 *
 * This instance-method lets you remove an instance of FlickrPerson from the manager.
 * Please note that the manager releases the supplied FlickrPerson instance. Therefore
 * you need to make sure to retain it in advance if you'd like to hold on to it.
 *
 * Returns NO if the supplied instance could not be removed from the manager. This
 * could happen if the supplied instance could not be found in the manager.
 */
- (BOOL)removePerson:(FKPerson*)aPerson;

/*!
 * @}
 */

@end
