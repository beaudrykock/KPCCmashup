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
    apvc.view.frame = frame;
    
    [self.view addSubview:apvc.view];
    
    [apvc didMoveToParentViewController:self];
    
    // ON-DEMAND COLLECTION VIEW
    BWCOnDemandViewController *bodvc = [[BWCOnDemandViewController alloc] init];
    
    [self addChildViewController:bodvc];
    
    frame = bodvc.view.frame;
    frame.origin.x = 0.0;
    frame.origin.y = self.view.frame.size.height-bodvc.view.frame.size.height;
    bodvc.view.frame = frame;
    
    [self.view addSubview:bodvc.view];
    
    [bodvc didMoveToParentViewController:self];
    
    // ARTICLE VIEW
    BWCArticleViewController *bavc = [[BWCArticleViewController alloc] init];
    
    [self addChildViewController:bavc];
    
    bavc.view.center = self.view.center;
    
    frame = bavc.view.frame;
    frame.origin.y = apvc.view.frame.origin.y + apvc.view.frame.size.height + 25.0;
    bavc.view.frame = frame;
    
    [self.view addSubview:bavc.view];
    
    [bavc didMoveToParentViewController:self];
    
}

@end
