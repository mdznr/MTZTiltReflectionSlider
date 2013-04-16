//
//  MTZTiltReflectionSlider.h
//  MTZTiltReflectionSlider
//
//  Created by Matt Zanchelli on 3/20/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTZTiltReflectionSlider : UISlider

typedef enum {
	MTZTiltReflectionSliderSizeRegular,
	MTZTiltReflectionSliderSizeSmall
} MTZTiltReflectionSliderSize;

// Size of the slider (Small or Regular). Regular by default
@property (nonatomic) MTZTiltReflectionSliderSize size;

- (id)initWithSliderSize:(MTZTiltReflectionSliderSize)sliderSize;

- (void)stopMotionDetection;
- (void)startMotionDetection;

@end
