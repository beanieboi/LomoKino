//
//  LomoKinoAppDelegate.m
//  LomoKino
//
//  Created by Benjamin Fritsch on 11.11.11.
//  Copyright 2011. All rights reserved.
//

#import "LomoKinoAppDelegate.h"
#import "LomoKinoMovie.h"

@implementation LomoKinoAppDelegate

@synthesize window;
@synthesize image_urls;
@synthesize directory;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (IBAction)process:(id)pId {
    if (image_urls == nil) {
        return;
    } else {
        LomoKinoMovie *kino = [LomoKinoMovie alloc];
        [kino createMovie:image_urls toDirectory:directory];
        [kino release];
    }
}

- (IBAction)selectImages:(id)pId {

    NSOpenPanel *PanelObject = [NSOpenPanel openPanel];
	[PanelObject setCanCreateDirectories:NO];
	[PanelObject setCanChooseDirectories:NO];
	[PanelObject setCanChooseFiles:YES];
	[PanelObject setAllowsMultipleSelection:YES];

	NSInteger PanelObjectResult = [PanelObject runModal];
	if(PanelObjectResult)
	{
        self.image_urls = [PanelObject URLs];
        self.directory = [PanelObject directoryURL];
	}
}

@end
