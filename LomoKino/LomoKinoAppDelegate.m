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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSArray *images = [NSArray arrayWithObjects:@"/Users/ben/Desktop/lomokino-samples/flatbed_with-sprockets_ben/2769_02.jpg",
                                                @"/Users/ben/Desktop/lomokino-samples/flatbed_with-sprockets_ben/2769_03.jpg",
                                                @"/Users/ben/Desktop/lomokino-samples/flatbed_with-sprockets_ben/2769_02.jpg",
                                                nil];
    //[[LomoKinoMovie alloc] createMovie:images];
}

@end
