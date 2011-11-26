//
//  LomoKinoMovie.m
//  LomoKino
//
//  Created by Benjamin Fritsch on 11.11.11.
//  Copyright 2011. All rights reserved.
//

#import "LomoKinoMovie.h"
#import "QTKit/QTKit.h"
#import "NSImage+Rotate.h"

@implementation LomoKinoMovie

// returns a array with pixels where to cut the original image
- (NSArray *)parseImage:(NSImage *)source
{

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

            if (false) {
                // just for coloring the found pixels red, only if you want make them visible
                [rawImg setColor:[NSColor redColor] atX:col y:horizontalMiddle-1];
                [rawImg setColor:[NSColor redColor] atX:col y:horizontalMiddle];
                [rawImg setColor:[NSColor redColor] atX:col y:horizontalMiddle+1];

            }
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
    return columnsToCut;
}

// returns a array with pixels where to cut the original image
- (NSArray *)cutImage:(NSImage *)source at:(NSArray *)columnsToCut rotate:(BOOL)rotate
{
    NSMutableArray *cuttedImages = [NSMutableArray array];

    NSBitmapImageRep* rawImg = [NSBitmapImageRep imageRepWithData:[source TIFFRepresentation]];

    for (int idx = 0; idx < [columnsToCut count]; idx++) {
        if (idx+1 < [columnsToCut count]-1) {
            NSNumber *current = [columnsToCut objectAtIndex:idx];
            NSNumber *next = [columnsToCut objectAtIndex:idx+1];
            int width = [next intValue] - [current intValue];

            if (false) {
                NSLog(@"TARGET CURRENT:%d DIFF:%d", [current intValue], width);
                NSLog(@"SOURCE CURRENT:%f DIFF:%f", [current intValue]/16.7, width/16.7);
            }

            NSRect targetRect = NSMakeRect(0, 0, width, [rawImg pixelsHigh]);
            NSRect sourceRect = NSMakeRect([current intValue]/16.7, 0, width/16.7, [rawImg pixelsHigh]/16.7);

            //0,0,485,
            NSImage *target = [[NSImage alloc]initWithSize:targetRect.size];

            [target lockFocus];
            //draw the portion of the source image on target image
            [source drawInRect:targetRect
                      fromRect:sourceRect
                     operation:NSCompositeCopy
                      fraction:1.0];
            //end drawing

            [target unlockFocus];

            if (rotate == TRUE) {
                NSImage *rotatedImage = [target rotate:-90];
                [cuttedImages addObject:rotatedImage];
            } else {
                [cuttedImages addObject:target];
            }
            [target release];
        }
    }

    return cuttedImages;
}

- (void)addToMovie:(NSArray *)images to:(QTMovie *)movie
{
    for (int i = 0; i < [images count]; i++) {
        NSImage *image = [images objectAtIndex:i];
        QTTime time = QTMakeTime(2, 10);
        NSDictionary *attrs = [NSDictionary dictionaryWithObject:@"jpeg" forKey:QTAddImageCodecType];

        [movie addImage:image forDuration:time withAttributes:attrs];
        [movie updateMovieFile];
    }
}

- (void)createMovie:(NSArray *)image_urls toDirectory:(NSURL *)directoy
{
    NSString *movie_path = [[directoy path] stringByAppendingString:@"/movie.mp4"];

    NSFileManager* fm = [[[NSFileManager alloc] init] autorelease];
    [fm removeItemAtPath:movie_path error:NULL];

    QTMovie *movie = [[QTMovie alloc] initToWritableFile:movie_path error:NULL];

    for (int i = 0; i < [image_urls count]; i++) {
        NSURL *url = [image_urls objectAtIndex:i];

        NSImage *source = [[NSImage alloc] initWithContentsOfURL:url];
        NSArray *columnsToCut = [self parseImage:source];
        NSArray *cuttedImages = [self cutImage:source at:columnsToCut rotate:TRUE];

        if (true) {
            // Writing file to disk
            for (int idx = 0; idx < [cuttedImages count]; idx++) {
                NSImage *image = [cuttedImages objectAtIndex:idx];
                NSData *imageData = [image  TIFFRepresentation];
                NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
                imageData = [imageRep representationUsingType:NSJPEGFileType properties:nil];

                NSString *filePath = [[directoy path] stringByAppendingString:
                                                        [NSString stringWithFormat:@"/frame_%d_%d.jpg", i, idx]];
                [imageData writeToFile: filePath atomically: NO];
            }
        }

        [self addToMovie:cuttedImages to:movie];

        [source release];
        #ifdef DEBUG
        NSLog(@"url: %@", url);
        NSLog(@"done...");
        #endif
    }

    [movie release];
}
@end
