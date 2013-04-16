//
//  UISlider+ForAllStates.m
//
//  Created by Matt on 4/10/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "UISlider+ForAllStates.h"

@implementation UISlider (ForAllStates)

- (void)setThumbImageForAllStates:(UIImage *)image
{
	[self setThumbImage:image forState:UIControlStateApplication];
	[self setThumbImage:image forState:UIControlStateDisabled];
	[self setThumbImage:image forState:UIControlStateHighlighted];
	[self setThumbImage:image forState:UIControlStateNormal];
	[self setThumbImage:image forState:UIControlStateReserved];
	[self setThumbImage:image forState:UIControlStateSelected];
}

@end
