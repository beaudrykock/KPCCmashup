//
//  BWCViewController.m
//  KPCCmashup
//
//  Created by Beaudry Kock on 10/28/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCViewController.h"

@interface BWCViewController ()

@end

@implementation BWCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KPCC_logo.png"]];
    image.frame = CGRectMake(20.0, 20.0, 193, 51);
    [self.view addSubview:image];
    
    [self addViewControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// adding new view controllers
- (void)addViewControllers
{
    // AUDIO PLAYER
    
    AudioPlayerViewController *apvc = [[AudioPlayerViewController alloc] init];
    
    [self addChildViewController:apvc];
    
    apvc.view.center = self.view.center;
    
    CGRect frame = apvc.view.frame;
    frame.origin.y = 20.0;
    frame.origin.x = 20+193.0+10.0;
    apvc.view.frame = frame;
    
    [self.view addSubview:apvc.view];
    
    [apvc didMoveToParentViewController:self];
    
    // ARTICLE VIEW
    BWCArticleViewController *bavc = [[BWCArticleViewController alloc] init];
    
    [self addChildViewController:bavc];
    
    bavc.view.center = self.view.center;
    
    frame = bavc.view.frame;
    frame.origin.y = apvc.view.frame.origin.y + apvc.view.frame.size.height;
    bavc.view.frame = frame;
    
    [self.view addSubview:bavc.view];
    
    [bavc didMoveToParentViewController:self];
    
    // ON-DEMAND COLLECTION VIEW
    
    PinchLayout* pinchLayout = [[PinchLayout alloc] init];
    pinchLayout.itemSize = CGSizeMake(150.0, 150.0);
    BWCOnDemandViewController *bodvc = [[BWCOnDemandViewController alloc] initWithCollectionViewLayout:pinchLayout];
    
    [self addChildViewController:bodvc];
    
    frame = bodvc.view.frame;
    frame.origin.x = 0.0;
    frame.size.height = 300.0;
    frame.origin.y = self.view.frame.size.height-frame.size.height;
    bodvc.view.frame = frame;
    
    [self.view addSubview:bodvc.view];
    
    [bodvc didMoveToParentViewController:self];
    
    UILabel *onDemandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, bodvc.view.frame.origin.y-50.0, self.view.frame.size.width, 50.0)];
    [onDemandLabel setFont:[UIFont fontWithName:@"Futura" size:25.0]];
    [onDemandLabel setTextColor:[UIColor whiteColor]];
    [onDemandLabel setText:@"  On Demand Content"];
    onDemandLabel.backgroundColor = [UIColor colorWithRed:154.0/255.0 green:70.0/255.0 blue:24.0/255.0 alpha:1.0];
    [self.view addSubview:onDemandLabel];
}

@end
