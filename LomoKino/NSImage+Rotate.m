//
//  NSImage+Rotate.m
//  LomoKino
//
//  Created by Benjamin Fritsch on 11.11.11.
//  Copyright 2011. All rights reserved.
//

#import "NSImage+Rotate.h"

@implementation NSImage(Rotated)


- (NSImage *)rotate:(int)degrees
{
    NSImage *image = self;

    if (degrees == 0) {
        return image;
    } else {
        NSSize beforeSize = [image size];
        NSSize afterSize = degrees == 90 || degrees == -90 ? NSMakeSize(beforeSize.height, beforeSize.width) : beforeSize;
        NSImage* newImage = [[[NSImage alloc] initWithSize:afterSize] autorelease];
        NSAffineTransform* trans = [NSAffineTransform transform];
        
        [newImage lockFocus];
        [trans translateXBy:afterSize.width * 0.5 yBy:afterSize.height * 0.5];
        [trans rotateByDegrees:degrees];
        [trans translateXBy:-beforeSize.width * 0.5 yBy:-beforeSize.height * 0.5];
        [trans set];
        [image drawAtPoint:NSZeroPoint
                  fromRect:NSMakeRect(0, 0, beforeSize.width, beforeSize.height)
                 operation:NSCompositeCopy
                  fraction:1.0];
        [newImage unlockFocus];
        return newImage;
    }
}

@end
