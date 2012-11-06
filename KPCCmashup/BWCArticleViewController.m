//
//  BWCArticleViewController.m
//  KPCCmashup
//
//  Created by Beaudry Kock on 11/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "BWCArticleViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"

@interface BWCArticleViewController ()

@end

@implementation BWCArticleViewController

@synthesize itemsToDisplay;

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
    formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [[NSMutableArray alloc] init];
	self.itemsToDisplay = [NSArray array];
    
    // Parse
	NSURL *feedURL = [NSURL URLWithString:@"http://feeds.scpr.org/893KpccSouthernCaliforniaNews"];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
}

// Reset and reparse
- (void)refresh {
	self.title = @"Refreshing...";
	[parsedItems removeAllObjects];
	[feedParser stopParsing];
	[feedParser parse];
	
    //repaint ***
}

- (void)updateTableWithParsedItems {
	self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
						   [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
																				 ascending:NO]]];
	//reload data
    
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
	self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                         message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                        delegate:nil
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
