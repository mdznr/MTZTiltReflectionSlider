//
//  MTZViewController.h
//  MTZTiltReflectionSlider_Example
//
//  Created by Matt on 4/15/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTZTiltReflectionSlider.h"

@interface MTZViewController : UIViewController

@property (strong, nonatomic) IBOutlet MTZTiltReflectionSlider *topSlider;
@property (strong, nonatomic) IBOutlet MTZTiltReflectionSlider *bottomSlider;

@end
