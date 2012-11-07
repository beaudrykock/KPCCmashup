//
//  BWCArticleViewController.h
//  KPCCmashup
//
//  Created by Beaudry Kock on 11/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@class WallViewController;
@class UIViewExtention;
@class MessageModel;

@interface BWCArticleViewController : UIViewController<MWFeedParserDelegate>{
    // Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
    
    WallViewController *viewController;
}

// Properties
@property (nonatomic, strong) NSArray *itemsToDisplay;
@property (nonatomic, strong) WallViewController *viewController;

@end
