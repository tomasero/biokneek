//
//  FeedbackViewController.m
//  SmartAss
//
//  Created by Tomas Vega on 9/13/15.
//  Copyright (c) 2015 Tomas Vega. All rights reserved.
//

#import "FeedbackViewController.h"


@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUI];
    
//    [NSTimer scheduledTimerWithTimeInterval:.25
//                                     target:self
//                                   selector:@selector(getPressure)
//                                   userInfo:nil
//                                    repeats:YES];
    
}

- (void) setUI {
    int space_between = 15;
    int label_height = 30;
    
    self.btConnectionIndicator = [[UIView alloc] initWithFrame:
                                  CGRectMake(
                                             self.view.frame.size.width - 50, 30,
                                             30, 30
                                             )
                                  ];
    self.btConnectionIndicator.layer.cornerRadius = 15;
    self.btConnectionIndicator.layer.masksToBounds = YES;
    self.btConnectionIndicator.layer.borderColor = [UIColor blueColor].CGColor;
    self.btConnectionIndicator.backgroundColor = [UIColor blueColor];
    self.btConnectionIndicator.alpha = 0.1f;
    [self.view addSubview:self.btConnectionIndicator];
    
    self.grid = [[UIView alloc] initWithFrame:
                 CGRectMake(
                            0,
                            (self.view.frame.size.height - self.view.frame.size.width)/2,
                            self.view.frame.size.width,
                            self.view.frame.size.width
                            )
                 ];
    
    int height =  (self.grid.frame.size.height-space_between*2)/2;
    int width = (self.grid.frame.size.width-space_between*3)/2;
    UILabel *label;
    
    [self.grid setBackgroundColor: [UIColor whiteColor]];
    
    self.cell1 = [[CellView alloc] initWithFrame:
                  CGRectMake(
                             space_between,
                             self.view.frame.origin.y,
                             width,
                             height
                             )
                  ];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.cell1.frame.origin.x, self.cell1.frame.origin.y - label_height, width, label_height)];
    label.text = @"Front-left";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [self.grid addSubview:label];
    
    self.cell2 = [[CellView alloc] initWithFrame:
                  CGRectMake(
                             space_between*2 + (self.grid.frame.size.width-space_between*3)/2,
                             self.view.frame.origin.y,
                             width,
                             height
                             )
                  ];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.cell2.frame.origin.x, self.cell2.frame.origin.y - label_height, width, label_height)];
    label.text = @"Front-right";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [self.grid addSubview:label];
    
    self.cell3 = [[CellView alloc] initWithFrame:
                  CGRectMake(
                             space_between,
                             self.view.frame.origin.y + self.grid.frame.size.height/2,
                             width,
                             height
                             )
                  ];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.cell3.frame.origin.x, self.cell3.frame.origin.y + height, width, label_height)];
    label.text = @"Bottom-left";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [self.grid addSubview:label];
    
    
    self.cell4 = [[CellView alloc] initWithFrame:
                  CGRectMake(
                             space_between*2 + (self.grid.frame.size.width-space_between*3)/2,
                             self.view.frame.origin.y + self.grid.frame.size.height/2,
                             width, height
                             )
                  ];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.cell4.frame.origin.x, self.cell4.frame.origin.y + height, width, label_height)];
    label.text = @"Bottom-right";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [self.grid addSubview:label];
    
    
    [self.grid addSubview: self.cell1];
    [self.grid addSubview: self.cell2];
    [self.grid addSubview: self.cell3];
    [self.grid addSubview: self.cell4];
    [self.view addSubview: self.grid];
}


- (void) updatePressure: (NSDictionary*) pressureDict {
    
    NSLog(@"dict: %@", pressureDict);
    
    float flex1 = [[pressureDict objectForKey: @"flex1"] floatValue];
    float flex2 = [[pressureDict objectForKey: @"flex2"] floatValue];
    float flex3 = [[pressureDict objectForKey: @"flex3"] floatValue];
    float flex4 = [[pressureDict objectForKey: @"flex4"] floatValue];
    
    //        float min = MIN(MIN(flex1, flex2), MIN(flex3, flex4));
    float min = 945;
//    float total = flex1 + flex2 + flex3 + flex4 - min*4;
    float total = 1024.0 - min;
    if(total < 0) {
        total = 1;
    }
    
    flex1 = MAX(flex1-min, 0);
    flex2 = MAX(flex2-min, 0);
    flex3 = MAX(flex3-min, 0);
    flex4 = MAX(flex4-min, 0);
    
    //        NSLog(@"%.1f %.1f %.1f %.1f", flex1, flex2, flex3, flex4);
    
    [self.cell1 updatePressure: flex1/total];
    [self.cell2 updatePressure: flex2/total];
    [self.cell3 updatePressure: flex3/total];
    [self.cell4 updatePressure: flex4/total];
}



- (void) calibrateButtonClick: (id) sender {
    UIButton *calibrateButton = (UIButton *)sender;
    calibrateButton.alpha = 0.5;
}

- (void) calibrateButtonRelease: (id) sender {
    UIButton *calibrateButton = (UIButton *)sender;
    calibrateButton.alpha = 1;
}

- (void) btConnectionChanged: (BOOL) state {
    self.btConnectionIndicator.alpha = state ? 1.0f : 0.1f;
}

@end
