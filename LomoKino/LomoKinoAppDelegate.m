//
//  LomoKinoAppDelegate.m
//  LomoKino
//
//  Created by Benjamin Fritsch on 11.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LomoKinoAppDelegate.h"
#import "QTKit/QTKit.h"

@implementation LomoKinoAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //Get the source image from file
    NSImage *source = [[NSImage alloc]initWithContentsOfFile:
                       @"/Users/ben/Desktop/lomokino-samples/flatbed_with-sprockets_ben/2769_02.jpg"];
    
    // Convert to Bitmap, to iterate over the pixels
    NSBitmapImageRep* rawImg = [NSBitmapImageRep imageRepWithData:[source TIFFRepresentation]];
    
    // calculate the horizontal middle
    NSInteger horizontalMiddle = [rawImg pixelsHigh] / (long) 2.0;
    
    
    NSMutableArray *possiblePixelsToCut = [NSMutableArray array];
    
    // iterate of the middle row of the image, because on top and on the buttom are sprockets
    for (int col = 0; col < [rawImg pixelsWide]; col++) {
        NSColor *color = [rawImg colorAtX:col y:horizontalMiddle];
        
        // if the brightness is very very dark, we can asume its not part of the frame
        // the average lightness of the image is mostly 0.3, so the threshold is like 1/3 of the average
        if ([color brightnessComponent] < 0.1) {
            [possiblePixelsToCut addObject:[NSNumber numberWithInt:col]];
            
            // just for coloring the found pixels red, only if you want make them visible
            //[rawImg setColor:[NSColor redColor] atX:col y:horizontalMiddle-1];
            //[rawImg setColor:[NSColor redColor] atX:col y:horizontalMiddle];
            //[rawImg setColor:[NSColor redColor] atX:col y:horizontalMiddle+1];
        }
    }

    // iterate of the found gap-pixels
    NSMutableArray *lastColumnInSpacing = [NSMutableArray array];
    NSMutableArray *columnsToCut = [NSMutableArray array];

    for (int idx = 0; idx < [possiblePixelsToCut count]; idx++) {
        if (idx+1 < [possiblePixelsToCut count]-1) {
            // calc the difference between the column and the following column
            NSNumber *currentColumn = [possiblePixelsToCut objectAtIndex:idx];
            NSNumber *nextColumn = [possiblePixelsToCut objectAtIndex:idx+1];
            int column_spacing = [nextColumn intValue] - [currentColumn intValue];

            // if the gap between two pixel is larger than 10, the next pixel must be a pixel of the new frame
            // so we gather all the pixel right before a new frame starts
            if (column_spacing > 10){
                //NSLog(@"spacing %d", column_spacing);

                // just go 20 pixels back, so we have the middle between two frames
                // and we now know exactly where to cut our image
                NSNumber *columnToCut = [NSNumber numberWithInt:[currentColumn intValue] -20];

                [columnsToCut addObject:columnToCut];
                [lastColumnInSpacing addObject:currentColumn];
            }
        }
    }

    //for (int idx = 0; idx < [possiblePixelsToCut count]; idx++) {
        //NSNumber *column = [columnsToCut objectAtIndex:idx];

        NSRect targetRect = NSMakeRect(0, 0, 485, [rawImg pixelsHigh]);
        NSRect sourceRect = NSMakeRect(0, 0, 485/16.7, [rawImg pixelsHigh]/16.7);

        NSImage *target = [[NSImage alloc]initWithSize:targetRect.size];

        [target lockFocus];
        //draw the portion of the source image on target image
        [source drawInRect:targetRect 
                  fromRect:sourceRect
                 operation:NSCompositeCopy
                  fraction:1.0];
        //end drawing
        [target unlockFocus];

        NSData *imageData = [target  TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];

        imageData = [imageRep representationUsingType:NSJPEGFileType properties:nil];

        // Writing file to disk
        [imageData writeToFile: @"/Users/ben/Desktop/lomokino-samples/flatbed_with-sprockets_ben/2769_02_border.jpg" atomically: NO];
        [target release];
    //}
    
    
    QTMovie *originalMovie = [QTMovie movie];
    [originalMovie addImage:target forDuration:QTMakeTime(2, 2) withAttributes:nil];
    NSLog(@"added frame");
    [originalMovie writeToFile:@"/Users/ben/Desktop/lomokino-samples/flatbed_with-sprockets_ben/movie.mp4" withAttributes:nil];

    [source release];
}

@end
