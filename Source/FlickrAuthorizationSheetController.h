//
//  FlickrAuthorizationSheetController.h
//  FlickrKit
//
//  Created by Felix Morgner on 09.06.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface FlickrAuthorizationSheetController : NSWindowController
	{
	@protected
		NSURL* authURL;
		IBOutlet NSView* loadingOverlay;
		IBOutlet NSProgressIndicator* loadingIndicator;
	}

- (void)presentSheet;
- (IBAction)closeSheet:(id)sender;

- (id)initWithWindowNibName:(NSString *)windowNibName authURL:(NSURL*)anAuthURL;
+ (FlickrAuthorizationSheetController*)authorizationSheetControllerWithURL:(NSURL*)anAuthorizationURL;

@property (readonly) IBOutlet WebView *flickrWebView;

@end
