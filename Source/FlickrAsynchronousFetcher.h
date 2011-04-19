//
//  FlickrAsynchronousFetcher.h
//  FlickrKit
//
//  Created by Felix Morgner on 19.04.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrAsynchronousFetcher : NSObject
	{
	@private
    void (^completionHandler)(id);
		NSURL* url;
		NSMutableData* receivedData;
	}

- (void)fetchDataAtURL:(NSURL*)theURL withCompletionHandler:(void (^)(NSData* fetchedData))block;

@end
