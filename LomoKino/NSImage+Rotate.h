//
//  NSImage+Rotate.h
//  LomoKino
//
//  Created by Benjamin Fritsch on 11.11.11.
//  Copyright 2011. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage(Rotated)

- (NSImage *)rotate:(NSImage *)image byAngle:(int)degrees;

@end

