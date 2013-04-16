//
//  UIImage+Shadow.m
//  MTZTiltReflectionSlider
//
//  Created by Matt Zanchelli on 3/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "UIImage+Shadow.h"

@implementation UIImage (Shadow)

- (UIImage*)imageWithShadowOfSize:(CGFloat)shadowSize
{
	// Code originally by Laurent Etiemble (http://stackoverflow.com/users/121278/laurent-etiemble)
	// Modified by nhojeod (http://stackoverflow.com/users/473409/nhojeod)
	// Modified by Matt Zanchelli (http://github.com/mdznr)
	// via http://stackoverflow.com/questions/2936443/create-new-uiimage-by-adding-shadow-to-existing-uiimage
	
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef shadowContext = CGBitmapContextCreate(NULL,
													   (self.size.width + (shadowSize * 2)) * scale,
													   (self.size.height + (shadowSize * 2)) * scale,
													   CGImageGetBitsPerComponent(self.CGImage),
													   0,
													   colourSpace,
													   kCGImageAlphaPremultipliedLast);
	
	CGColorSpaceRelease(colourSpace);
	CGContextSetShadowWithColor(shadowContext,
								CGSizeMake( 0 * scale, 0 * scale),
								shadowSize * scale,
								[UIColor blackColor].CGColor);
	
	CGContextDrawImage(shadowContext,
					   CGRectMake(shadowSize * scale, shadowSize * scale, self.size.width * scale, self.size.height * scale),
					   self.CGImage);
	
	CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
	CGContextRelease(shadowContext);
	
	UIImage *shadowedImage = [UIImage imageWithCGImage:shadowedCGImage scale:scale orientation:UIImageOrientationUp];
	CGImageRelease(shadowedCGImage);
	
	return shadowedImage;
}

- (UIImage*)imageWithShadowOfSize:(CGFloat)shadowSize andColor:(UIColor *)color
{
	// Code originally by Laurent Etiemble (http://stackoverflow.com/users/121278/laurent-etiemble)
	// Modified by nhojeod (http://stackoverflow.com/users/473409/nhojeod)
	// Modified by Matt Zanchelli (http://github.com/mdznr)
	// via http://stackoverflow.com/questions/2936443/create-new-uiimage-by-adding-shadow-to-existing-uiimage
	
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef shadowContext = CGBitmapContextCreate(NULL,
													   (self.size.width + (shadowSize * 2)) * scale,
													   (self.size.height + (shadowSize * 2)) * scale,
													   CGImageGetBitsPerComponent(self.CGImage),
													   0,
													   colourSpace,
													   kCGImageAlphaPremultipliedLast);
	
	CGColorSpaceRelease(colourSpace);
	CGContextSetShadowWithColor(shadowContext,
								CGSizeMake( 0 * scale, 0 * scale),
								shadowSize * scale,
								color.CGColor);
	
	CGContextDrawImage(shadowContext,
					   CGRectMake(shadowSize * scale, shadowSize * scale, self.size.width * scale, self.size.height * scale),
					   self.CGImage);
	
	CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
	CGContextRelease(shadowContext);
	
	UIImage *shadowedImage = [UIImage imageWithCGImage:shadowedCGImage scale:scale orientation:UIImageOrientationUp];
	CGImageRelease(shadowedCGImage);
	
	return shadowedImage;
}

@end
