//
//  iPhoneStreamingPlayerViewController.h
//  iPhoneStreamingPlayer
//
//  Created by Matt Gallagher on 28/10/08.
//  Copyright Matt Gallagher 2008. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"

@class AudioStreamer, LevelMeterView;

@interface AudioPlayerViewController : UIViewController
{
	IBOutlet UIButton *button;
	IBOutlet UILabel *elapsedLabel;
    IBOutlet UILabel *remainingLabel;
	IBOutlet UISlider *progressSlider;
	AudioStreamer *streamer;
	NSTimer *progressUpdateTimer;
    IBOutlet UILabel *metadataArtist;
	IBOutlet UILabel *metadataTitle;
	IBOutlet UILabel *metadataAlbum;
    double playDuration;
    BOOL playing;
}

@property (nonatomic, retain) UIView *tooltipAnchor;
@property (nonatomic, retain) CMPopTipView *programTooltip;
@property (nonatomic, copy) NSString *downloadSourceURL;
@property (retain) NSString* currentArtist;
@property (retain) NSString* currentTitle;

- (IBAction)buttonPressed:(id)sender;
- (void)spinButton;
- (void)forceUIUpdate;
- (void)createTimers:(BOOL)create;
- (void)playbackStateChanged:(NSNotification *)aNotification;
- (void)updateProgress:(NSTimer *)updatedTimer;
- (IBAction)sliderMoved:(UISlider *)aSlider;
- (void)destroyStreamer;
-(void)closeAudioViewContainer;
- (void)metadataChanged:(NSNotification *)aNotification;

@end

