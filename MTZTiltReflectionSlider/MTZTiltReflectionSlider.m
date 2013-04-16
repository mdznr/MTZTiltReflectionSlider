//
//  MTZTiltReflectionSlider.m
//  MTZTiltReflectionSlider
//
//  Created by Matt Zanchelli on 3/20/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>

#import "MTZTiltReflectionSlider.h"
#import "GZCoreGraphicsAdditions.h"
#import "UIImage+Shadow.h"
#import "UIImage+Rotate.h"
#import "UISlider+ForAllStates.h"

// Private properties.
@interface MTZTiltReflectionSlider ()

// Our motion manager.
@property (nonatomic, strong) CMMotionManager *motionManager;

@property (atomic) double previousRoll;
@property (atomic) double previousPitch;

@property (nonatomic, strong) UIImageView *shine1;
@property (nonatomic, strong) UIImageView *shine2;

@end

@implementation MTZTiltReflectionSlider

#pragma mark - Public Initializers

// Allows support for using instances loaded from nibs or storyboards.
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if ( self ) {
        [self setup];
		[self setSize:MTZTiltReflectionSliderSizeRegular];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self setup];
		[self setSize:MTZTiltReflectionSliderSizeRegular];
    }
    return self;
}

- (id)initWithSliderSize:(MTZTiltReflectionSliderSize)sliderSize
{
	self = [super init];
	if ( self ) {
		[self setup];
		[self setSize:sliderSize];
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
}

// We need to stop our motionManager from continuing to update once our instance is deallocated.
- (void)dealloc
{
	[self stopMotionDetection];
	@try {
		[(UIImageView *)[self valueForKey:@"_thumbView"] removeObserver:self
															 forKeyPath:@"frame"
																context:nil];
	} @catch (NSException *exception) {
	}
}

#pragma mark - Private methods

// Sets up the initial state of the view.
- (void)setup
{	
	// Set the slider track images
	[self setMinimumTrackImage:[[UIImage imageNamed:@"MTZTiltReflectionSliderTrackFill"]
								resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 0)]
					  forState:UIControlStateNormal];
	
	[self setMaximumTrackImage:[[UIImage imageNamed:@"MTZTiltReflectionSliderTrackEmpty"]
								resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 6)]
					  forState:UIControlStateNormal];
	
	_shine1 = [[UIImageView alloc] init];
	_shine2 = [[UIImageView alloc] init];
	[self addSubview:_shine1];
	[self addSubview:_shine2];
	
	// Set up our motion updates
	[self getReadyForMotionDetection];
}

- (void)setSize:(MTZTiltReflectionSliderSize)size
{
//	if ( _size == size ) return;
	
	_size = size;
	
	CGSize oldSize = CGSizeZero;
	CGSize newSize = CGSizeZero;
	
	// Set the base image
	switch ( size ) {
		case MTZTiltReflectionSliderSizeRegular:
			oldSize = self.shine1.image.size;
			newSize = [UIImage imageNamed:@"MTZTiltReflectionSliderShineClear"].size;
			[self.shine1 setImage:[UIImage imageNamed:@"MTZTiltReflectionSliderShineClear"]];
			[self.shine2 setImage:[UIImage imageNamed:@"MTZTiltReflectionSliderShineClear"]];
			[self.shine1 setBounds:(CGRect){0,0,newSize.width,newSize.height}];
			[self.shine2 setBounds:(CGRect){0,0,newSize.width,newSize.height}];
			[self setThumbImageForAllStates:[[UIImage imageNamed:@"MTZTiltReflectionSliderKnobBase"] imageWithShadowOfSize:2.0f]];
			break;
		case MTZTiltReflectionSliderSizeSmall:
			oldSize = self.shine1.image.size;
			newSize = [UIImage imageNamed:@"MTZTiltReflectionSliderShineClear-Small"].size;
			[self.shine1 setImage:[UIImage imageNamed:@"MTZTiltReflectionSliderShineClear-Small"]];
			[self.shine2 setImage:[UIImage imageNamed:@"MTZTiltReflectionSliderShineClear-Small"]];
			[self.shine1 setBounds:(CGRect){0,0,newSize.width,newSize.height}];
			[self.shine2 setBounds:(CGRect){0,0,newSize.width,newSize.height}];
			[self setThumbImageForAllStates:[[UIImage imageNamed:@"MTZTiltReflectionSliderKnobBase-Small"] imageWithShadowOfSize:2.0f]];
			break;
		default:
			break;
	}
	
	[self updateButtonImageForRoll:_previousRoll pitch:_previousPitch];
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
	// Set the correct bounds for the track.
	return (CGRect){0, 0, bounds.size.width, 10};
}

// Gets ready for the Motion Detection
- (void)getReadyForMotionDetection
{
	// Need to call once for the initial load
    [self updateButtonImageForRoll:0 pitch:0];
}

- (void)stopMotionDetection
{
	if ( self.motionManager ) {
		[self.motionManager stopDeviceMotionUpdates];
		self.motionManager = nil;
	}
}

- (void)startMotionDetection
{
	if ( self.motionManager != nil ) {
		NSLog(@"Motion is already active.");
		return;
	}
	
	// Set up a motion manager and start motion updates, calling deviceMotionDidUpdate: when updated.
	self.motionManager = [[CMMotionManager alloc] init];
	self.motionManager.deviceMotionUpdateInterval = 1.0/60.0;
	
	if ( self.motionManager.deviceMotionAvailable ) {
		NSOperationQueue *queue = [NSOperationQueue currentQueue];
		[self.motionManager startDeviceMotionUpdatesToQueue:queue
												withHandler:^(CMDeviceMotion *motionData, NSError *error) {
													[self deviceMotionDidUpdate:motionData];
												}];
	}
	
	[(UIImageView *)[self valueForKeyPath:@"_thumbView"] addObserver:self
														  forKeyPath:@"frame"
															 options:NSKeyValueObservingOptionNew
															 context:nil];
	[self updateShinePositions];
	[self bringSubviewToFront:_shine1];
	[self bringSubviewToFront:_shine2];
}

#pragma mark CoreMotion Methods

- (void)deviceMotionDidUpdate:(CMDeviceMotion *)deviceMotion
{	
	// Don't redraw if the change in motion wasn't enough.
	if ( ABS(deviceMotion.attitude.roll - _previousRoll) < 0.002210f ||
		 ABS(deviceMotion.attitude.pitch - _previousPitch) < 0.002210f ) {
		return;
	}
	
	self.previousRoll = deviceMotion.attitude.roll;
	self.previousPitch = deviceMotion.attitude.pitch;
    
    // We need to account for the interface's orientation when calculating the relative roll.
    CGFloat roll = 0.0f;
    CGFloat pitch = 0.0f;
    switch ( [[UIApplication sharedApplication] statusBarOrientation] ) {
        case UIInterfaceOrientationPortrait:
            roll = deviceMotion.attitude.roll;
            pitch = deviceMotion.attitude.pitch;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            roll = -deviceMotion.attitude.roll;
            pitch = -deviceMotion.attitude.pitch;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            roll = -deviceMotion.attitude.pitch;
            pitch = -deviceMotion.attitude.roll;
            break;
        case UIInterfaceOrientationLandscapeRight:
            roll = deviceMotion.attitude.pitch;
            pitch = deviceMotion.attitude.roll;
            break;
    }
	
    // Update the image with the calculated values.
    [self updateButtonImageForRoll:roll pitch:pitch];
}

// Uppdates the Thumb (knob) image for the given roll and pitch
-(void)updateButtonImageForRoll:(CGFloat)roll pitch:(CGFloat)pitch
{	
	// Get the x and y motions
	// x and y vary from -1 to 1
	CGFloat x = roll;
	CGFloat y = pitch;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:1.0f/120.0f];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[_shine1 setTransform:CGAffineTransformMakeRotation(-x+y)];
	[_shine1 setAlpha:(1.0f + x)];
	[_shine2 setTransform:CGAffineTransformMakeRotation(-x-y)];
	[_shine2 setAlpha:(1.0f - x)];
	[UIView commitAnimations];
}

- (void)updateShinePositions
{
	[_shine1 setCenter:[(UIImageView *)[self valueForKeyPath:@"_thumbView"] center]];
	[_shine2 setCenter:[(UIImageView *)[self valueForKeyPath:@"_thumbView"] center]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
//	NSLog(@"%@ \n %@ \n %@ \n ", keyPath, object, change);
	[self updateShinePositions];
}

@end

