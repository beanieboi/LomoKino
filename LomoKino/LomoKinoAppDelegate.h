//
//  LomoKinoAppDelegate.h
//  LomoKino
//
//  Created by Benjamin Fritsch on 11.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LomoKinoAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
