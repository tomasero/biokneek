#import <QuartzCore/QuartzCore.h>

#import "AppViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioServices.h>

@implementation AppViewController


@synthesize rfduino;

+ (void)load
{
    // customUUID = @"c97433f0-be8f-4dc8-b6f0-5343e6100eb4";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self addTabBarControllers];
//        // Custom initialization
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        UIButton *backButton = [UIButton buttonWithType:101];  // left-pointing shape
//        [backButton setTitle:@"Disconnect" forState:UIControlStateNormal];
//        [backButton addTarget:self action:@selector(disconnect:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        [[self navigationItem] setLeftBarButtonItem:backItem];
//        
//        [[self navigationItem] setTitle:@"BioKneek"];
    }
    return self;
}

-(void)addTabBarControllers {
    self.feedbackVC = [[FeedbackViewController alloc] init];
    self.settingsVC = [[SettingsViewController alloc] init];
    
    UIImage* feedbackImage = [UIImage imageNamed:@"pressure.png"];
    UITabBarItem* feedbackTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feedback" image:feedbackImage tag:0];
    self.feedbackVC.tabBarItem = feedbackTabBarItem;
    
    UIImage* settingsImage = [UIImage imageNamed:@"settings.png"];
    UITabBarItem* settingsTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:settingsImage tag:0];
    self.settingsVC.tabBarItem = settingsTabBarItem;
    
    
    NSArray* controllers = [NSArray arrayWithObjects:self.feedbackVC, self.settingsVC, nil];
    self.tabBarController = [[UITabBarController alloc] init];
    [[UITabBar appearance] setTintColor:[UIColor purpleColor]];
    [[UITabBar appearance] setBarTintColor: [UIColor whiteColor]];
    self.tabBarController.viewControllers = controllers;
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.traininigData = [NSMutableArray array];
    //    [self setUI];
    [rfduino setDelegate:self];

//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    [appDelegate addTabBarControllers];
    // Do any additional setup after loading the view from its nib.


    int labelHeight = 30;
    //FS
    UILabel *FSR1Label = [[UILabel alloc] initWithFrame:CGRectMake(
                                              50,100,
                                              self.view.frame.size.width/2,
                                              labelHeight
                                              )];
    FSR1Label.text = @"FSR1";
    
    self.FSR1Value = [[UILabel alloc] initWithFrame:CGRectMake(50,
                                                               150,
                                                                self.view.frame.size.width/2,
                                                                labelHeight
                                                               )];

    UILabel *FSR2Label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   50,
                                                                   200,
                                                                   self.view.frame.size.width/2,
                                                                   labelHeight
                                                                   )];
    FSR2Label.text = @"FSR2";
    
    self.FSR2Value = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               50,
                                                               250,
                                                               self.view.frame.size.width/2,
                                                               labelHeight
                                                               )];
    
    _FSR2Value.text = @"0";

    UILabel *FSR3Label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   50,
                                                                   300,
                                                                   self.view.frame.size.width/2,
                                                                   labelHeight
                                                                   )];
    FSR3Label.text = @"FSR3";
    
    self.FSR3Value = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               50,
                                                               350,
                                                               self.view.frame.size.width/2,
                                                               labelHeight
                                                               )];
    
    _FSR3Value.text = @"0";

    UILabel *FSR4Label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   50,
                                                                   400,
                                                                   self.view.frame.size.width/2,
                                                                   labelHeight
                                                                   )];
    FSR4Label.text = @"FSR4";
    
    self.FSR4Value = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               50,
                                                               450,
                                                               self.view.frame.size.width/2,
                                                               labelHeight
                                                               )];
    
    _FSR4Value.text = @"0";

    UILabel *FSR5Label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   50,
                                                                   500,
                                                                   self.view.frame.size.width/2,
                                                                   labelHeight
                                                                   )];
    FSR5Label.text = @"FSR5";
    
    self.FSR5Value = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               50,
                                                               550,
                                                               self.view.frame.size.width/2,
                                                               labelHeight
                                                               )];
    
    _FSR5Value.text = @"0";
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect viewRect = CGRectMake(0, 0, 200, 200);
    UIView *subview = [[UIView alloc] initWithFrame : viewRect];
    [subview addSubview:self.FSR1Value];
    [subview addSubview:self.FSR2Value];
    [subview addSubview:self.FSR3Value];
    [subview addSubview:self.FSR4Value];
    [subview addSubview:self.FSR5Value];
    [subview addSubview:FSR1Label];
    [subview addSubview:FSR2Label];
    [subview addSubview:FSR3Label];
    [subview addSubview:FSR4Label];
    [subview addSubview:FSR5Label];
    [window.rootViewController.view addSubview: subview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disconnect:(id)sender
{
    NSLog(@"disconnect pressed");

    [rfduino disconnect];
}

- (void)didReceive:(NSData *)data
{
    char *p = (char *)[data bytes];
    int vals[5];
    
    for (int _i=0; _i<5; _i++)
        memcpy(&vals[_i], &p[_i*sizeof(int)], sizeof(int));
    
//    uint8_t *p = (uint8_t*)[data bytes];
//    NSUInteger len = [data length];
//    int FSR1 = dataInt(data);
    NSLog(@"DATA");
    
    NSLog(@"%d", vals[0]);
    NSLog(@"%d", vals[1]);
    NSLog(@"%d", vals[2]);
    NSLog(@"%d", vals[3]);
    NSLog(@"%d", vals[4]);
    self.FSR1Value.text = [NSString stringWithFormat:@"%d",vals[0]];
    self.FSR2Value.text = [NSString stringWithFormat:@"%d",vals[1]];
    self.FSR3Value.text = [NSString stringWithFormat:@"%d",vals[2]];
    self.FSR4Value.text = [NSString stringWithFormat:@"%d",vals[3]];
    self.FSR5Value.text = [NSString stringWithFormat:@"%d",vals[4]];

    int totalValue = 0;
    for (int i = 0; i < 5; ++ i) {
        totalValue += vals[i];
    }
    int bodyWeight = 68;
    NSLog(@"%d", totalValue);
    if ( totalValue != 0 && totalValue < (bodyWeight * 0.4) ) {
        NSLog(@"+");
        self.unbalanceCounter += 1;
        if (self.unbalanceCounter == 3) {
            NSLog(@"Unbalance");
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            self.unbalanceCounter = 0;
        }
    } else {
        NSLog(@"-");
    }
    
//    if (totalValue > )
    
    
//        [abc addObject:[NSNumber numberWithInt:i]];
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
