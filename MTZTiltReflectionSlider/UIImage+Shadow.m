/*
Copyright (c) 2013, Matt Zanchelli
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
	* Redistributions of source code must retain the above copyright
	  notice, this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright
	  notice, this list of conditions and the following disclaimer in the
	  documentation and/or other materials provided with the distribution.
	* Neither the name of the <organization> nor the
	  names of its contributors may be used to endorse or promote products
	  derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
													   (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	
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
													   (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	
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
