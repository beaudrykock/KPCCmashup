//
//  BWCOnDemandViewController.h
//  KPCCmashup
//
//  Created by Beaudry Kock on 11/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWCOnDemandViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end
