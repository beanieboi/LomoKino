//
//  NSImage+Rotate.m
//  EarthSurfer
//
//   Copyright 2009 Google Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

#import "NSImage+Rotate.h"

@implementation NSImage(Rotated)


- (NSImage *)rotate:(NSImage *)image byAngle:(int)degrees
{
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
