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

    [rfduino setDelegate:self];
    UIImageView *imgview = [[UIImageView alloc]
                            initWithFrame:CGRectMake(90, 70, 200, 600)];
    [imgview setImage:[UIImage imageNamed:@"biokneek_bottom.jpg"]];
    [imgview setContentMode:UIViewContentModeScaleAspectFit];
    imgview.layer.zPosition = 1;
    [self.view addSubview: imgview];
    [self setUI];
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
    [self.cell1 updatePressure:(float)vals[4]/10.0];
    [self.cell2 updatePressure:(float)vals[3]/10.0];
    [self.cell3 updatePressure:(float)vals[2]/10.0];
    [self.cell4 updatePressure:(float)vals[1]/10.0];
    [self.cell5 updatePressure:(float)vals[0]/10.0];

    int totalValue = 0;
    for (int i = 0; i < 5; ++ i) {
        totalValue += vals[i];
    }
    int bodyWeight = 68;
    NSLog(@"Total: %d", totalValue);
    int upperThresh = ((float)bodyWeight * 0.4);
    int lowerThresh = 8;
    
    if ( totalValue != 0 && totalValue < upperThresh && totalValue > lowerThresh) {
        NSLog(@"+");
        self.unbalanceCounter += 1;
        if (self.unbalanceCounter == 3) {
            NSLog(@"Unbalance");
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            
//            NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"tap"
//                                                        withExtension: @"aif"];
//            SystemSoundID soundID;
//            
//            // Create a system sound object representing the sound file.
//            AudioServicesCreateSystemSoundID (
//                                              (__bridge CFURLRef)tapSound,
//                                              &soundID
//                                              );
            self.unbalanceCounter = 0;
        }
    } else {
        NSLog(@"-");
    }
    
//    if (totalValue > )
    
    
//        [abc addObject:[NSNumber numberWithInt:i]];
}

- (void) setUI {
//    
//    self.btConnectionIndicator = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
//    self.btConnectionIndicator.layer.cornerRadius = 15;
//    self.btConnectionIndicator.layer.masksToBounds = YES;
//    self.btConnectionIndicator.layer.borderColor = [UIColor blueColor].CGColor;
//    self.btConnectionIndicator.backgroundColor = [UIColor blueColor];
//    self.btConnectionIndicator.alpha = 0.1f;
//    [self.view addSubview:self.btConnectionIndicator];
    
    int height =  60;
    int width = 60;
    
    self.cell1 = [[CellView alloc] initWithFrame:
                  CGRectMake(
                             120,
                             90,
                             width,
                             height
                             )];
    self.cell1.layer.zPosition = MAXFLOAT;
    
    self.cell2 = [[CellView alloc] initWithFrame:
                  CGRectMake(
                             202,
                             175,
                             width,
                             height
                             )
                  ];
    self.cell2.layer.zPosition = MAXFLOAT;
    
    self.cell3 = [[CellView alloc] initWithFrame:
                  CGRectMake(
                             120,
                             366,
                             width,
                             height
                             )
                  ];
    self.cell3.layer.zPosition = MAXFLOAT;
    
    self.cell4 = [[CellView alloc] initWithFrame:
                  CGRectMake(
                             202,
                             499,
                             width, height
                             )
                  ];
    self.cell4.layer.zPosition = MAXFLOAT;
    
    self.cell5 = [[CellView alloc] initWithFrame:
                  CGRectMake(
                             120,
                             584,
                             width, height
                             )
                  ];
    self.cell5.layer.zPosition = MAXFLOAT;
    
    [self.view addSubview: self.cell1];
    [self.view addSubview: self.cell2];
    [self.view addSubview: self.cell3];
    [self.view addSubview: self.cell4];
    [self.view addSubview: self.cell5];
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
