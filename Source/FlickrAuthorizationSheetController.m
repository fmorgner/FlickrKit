//
//  FlickrAuthorizationSheetController.m
//  FlickrKit
//
//  Created by Felix Morgner on 09.06.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "FlickrAuthorizationSheetController.h"
#import "FlickrKitConstants.h"

@implementation FlickrAuthorizationSheetController
@synthesize flickrWebView;

- (id)initWithWindowNibName:(NSString *)windowNibName authURL:(NSURL*)anAuthURL
	{
	if((self = [super initWithWindowNibName:windowNibName]))
		{
		authURL = [anAuthURL retain];
		}
	
	return self;
	}

- (void)awakeFromNib
	{
	[flickrWebView setMainFrameURL:[authURL absoluteString]];
	[flickrWebView setMaintainsBackForwardList:NO];
	}

- (void)windowDidLoad
	{
	[super windowDidLoad];
	}

- (void)presentSheet
	{
	NSWindow* keyWindow = [NSApp keyWindow];
	[NSApp beginSheet:self.window modalForWindow:keyWindow modalDelegate:self didEndSelector:@selector(sheetDidEnd: returnCode: contextInfo:) contextInfo:NULL];
	}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
	{
	[[NSNotificationCenter defaultCenter] postNotificationName:FlickrAuthorizationSheetDidClose object:self];
	[sheet orderOut:self];
	}

- (IBAction)closeSheet:(id)sender
	{
	[NSApp endSheet:self.window];
	}
@end
