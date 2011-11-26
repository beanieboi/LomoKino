//
//  LomoKinoMovie.h
//  LomoKino
//
//  Created by Benjamin Fritsch on 11.11.11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LomoKinoMovie : NSObject {
    NSArray *image_paths;
}

@property (nonatomic, retain) NSArray *image_paths;

- (void)createMovie:(NSArray *)image_paths;

@end
