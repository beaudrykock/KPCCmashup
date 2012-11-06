//
//  BWCOnDemandViewController.m
//  KPCCmashup
//
//  Created by Beaudry Kock on 11/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCOnDemandViewController.h"
#import "Cell.h"

@interface BWCOnDemandViewController ()

@end

@implementation BWCOnDemandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.collectionView addGestureRecognizer:pinchRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    [cell.label setText:[self getTextForIndexPath:indexPath]];
    [cell.image setImage:[self getImageForIndexPath:indexPath]];
    return cell;
}

-(NSString*)getTextForIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row % 2 ==0)
    {
        return @"Take Two";
    }
    if (indexPath.row % 3 ==0)
    {
        return @"Air Talk";
    }
    else
    {
        return @"Off Ramp";
    }
}

-(UIImage*)getImageForIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row % 2 ==0)
    {
        return [UIImage imageNamed:@"item_1.png"];
    }
    if (indexPath.row % 3 ==0)
    {
        return [UIImage imageNamed:@"item_2.png"];
    }
    else
    {
        return [UIImage imageNamed:@"item_3.png"];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
}


#pragma mark - Pinching
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender
{
    PinchLayout* pinchLayout = (PinchLayout*)self.collectionView.collectionViewLayout;
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* pinchedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        pinchLayout.pinchedCellPath = pinchedCellPath;
        
    }
    
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        pinchLayout.pinchedCellScale = sender.scale;
        pinchLayout.pinchedCellCenter = [sender locationInView:self.collectionView];
    }
    
    else
    {
        [self.collectionView performBatchUpdates:^{
            pinchLayout.pinchedCellPath = nil;
            pinchLayout.pinchedCellScale = 1.0;
        } completion:nil];
    }
}

@end
