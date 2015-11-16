//
//  SettingsCellView.m
//  SmartAss
//
//  Created by Tomas Vega on 9/13/15.
//  Copyright (c) 2015 Tomas Vega. All rights reserved.
//

#import "SettingsCellView.h"

@implementation SettingsCellView


-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        [self setUI];
    }
    return self;
}

- (void) setUI {
    int labelHeight = 30;
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                      self.frame.origin.x,
                                                      (self.frame.origin.y - labelHeight)/2,
                                                      self.frame.size.width/2,
                                                      labelHeight
                                                      )];
    self.label.textAlignment = NSTextAlignmentRight;
    self.label.textColor = [UIColor grayColor];
    
    self.cellSwitch = [[UISwitch alloc] init];
    self.cellSwitch.frame = CGRectMake(
                                       self.frame.size.width - (self.frame.size.width/2 - self.cellSwitch.frame.size.width)/2,
                                        (self.frame.origin.y - self.cellSwitch.frame.size.height)/2,
                                       self.cellSwitch.frame.size.width,
                                       self.cellSwitch.frame.size.height);

    self.cellSwitch.onTintColor = [UIColor purpleColor];
//    UIView *switchView = [[UIView alloc] initWithFrame:CGRectMake(
//        self.frame.origin.x + (self.frame.size.width/2) + (self.frame.size.width/2 - self.cellSwitch.frame.size.width)/2,
//        (self.frame.origin.y - self.cellSwitch.frame.size.height)/2,
//        self.frame.size.width/2,
//        self.cellSwitch.frame.size.height
//        )];
    [self bringSubviewToFront:self.cellSwitch];
//    self.label.userInteractionEnabled = YES;
//    self.cellSwitch.userInteractionEnabled = YES;
    
    [self addSubview:self.label];
    [self addSubview:self.cellSwitch];
//    [switchView addSubview:self.cellSwitch];
//    [self addSubview:switchView];
}

- (void) setCellName: (NSString *) name {
    self.label.text = name;
}



@end
