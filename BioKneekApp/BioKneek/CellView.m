//
//  CellView.m
//  SmartAss
//
//  Created by Tomas Vega on 9/12/15.
//  Copyright (c) 2015 Tomas Vega. All rights reserved.
//

#import "CellView.h"
#import <QuartzCore/QuartzCore.h>


@implementation CellView

-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        self.layer.cornerRadius = 30;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void) updatePressure: (float) alpha {
//    float alpha = [percentage floatValue]/100;
    UIColor *pressureColor = [UIColor colorWithRed:1.0*alpha
                                             green:0.0
                                              blue:1.0*(1-alpha)
                                             alpha:1.0];
    self.backgroundColor = pressureColor;
    [self setNeedsDisplay];
}

@end
