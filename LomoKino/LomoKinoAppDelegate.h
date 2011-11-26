//
//  LomoKinoAppDelegate.h
//  LomoKino
//
//  Created by Benjamin Fritsch on 11.11.11.
//  Copyright 2011. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LomoKinoAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSArray *image_urls;
    NSURL *directory;
}

- (IBAction)process:(id)pId;
- (IBAction)selectImages:(id)pId;

@property (nonatomic, retain) NSURL *directory;
@property (nonatomic, retain) NSArray *image_urls;
@property (assign) IBOutlet NSWindow *window;

@end
