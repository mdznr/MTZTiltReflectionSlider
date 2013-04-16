//
//  UIImage+Shadow.h
//  MTZTiltReflectionSlider
//
//  Created by Matt Zanchelli on 3/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Shadow)

- (UIImage*)imageWithShadowOfSize:(CGFloat)shadowSize;
- (UIImage*)imageWithShadowOfSize:(CGFloat)shadowSize andColor:(UIColor *)color;

@end
