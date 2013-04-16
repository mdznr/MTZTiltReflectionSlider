//
//  MTZViewController.m
//  MTZTiltReflectionSlider_Example
//
//  Created by Matt on 4/15/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZViewController.h"

@interface MTZViewController ()

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_topSlider = [[MTZTiltReflectionSlider alloc] initWithFrame:CGRectMake(20, 50, 280, 23)];
	_bottomSlider = [[MTZTiltReflectionSlider alloc] initWithFrame:CGRectMake(20, 100, 280, 23)];
	
	[_topSlider setSize:MTZTiltReflectionSliderSizeSmall];
	[_bottomSlider setSize:MTZTiltReflectionSliderSizeRegular];
	
	[self.view addSubview:_topSlider];
	[self.view addSubview:_bottomSlider];
}

- (void)viewWillAppear:(BOOL)animated
{
	[_topSlider startMotionDetection];
	[_bottomSlider startMotionDetection];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[_topSlider stopMotionDetection];
	[_bottomSlider stopMotionDetection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
