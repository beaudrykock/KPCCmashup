//
//  iPhoneStreamingPlayerViewController.m
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

#import "AudioPlayerViewController.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

@implementation AudioPlayerViewController

@synthesize currentArtist, currentTitle;

//
// setButtonImage:
//
// Used to change the image on the playbutton. This method exists for
// the purpose of inter-thread invocation because
// the observeValueForKeyPath:ofObject:change:context: method is invoked
// from secondary threads and UI updates are only permitted on the main thread.
//
// Parameters:
//    image - the image to set on the play button.
//
- (void)setButtonImage:(UIImage *)image
{
	[button.layer removeAllAnimations];
	if (!image)
	{
		[button setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
	}
	else
	{
		[button setImage:image forState:0];
	
		if ([button.currentImage isEqual:[UIImage imageNamed:@"loadingbutton.png"]])
		{
			[self spinButton];
		}
	}
}

-(void)closeAudioViewContainer
{
    [self.view removeFromSuperview];
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
			removeObserver:self
			name:ASStatusChangedNotification
			object:streamer];
		[self createTimers:NO];
		
		[streamer stop];
		[streamer release];
		streamer = nil;
        playing = NO;
        playDuration = 0.0;
        [metadataAlbum setText:@""];
	}
}

//
// forceUIUpdate
//
// When foregrounded force UI update since we didn't update in the background
//
-(void)forceUIUpdate {
	if (!streamer) {
		[self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
	}
	else 
		[self playbackStateChanged:NULL];
}

//
// createTimers
//
// Creates or destoys the timers
//
-(void)createTimers:(BOOL)create {
    
    // TESTING
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonPressed:) name:@"play" object:nil];
    
	if (create) {
		if (streamer) {
				[self createTimers:NO];
				progressUpdateTimer =
				[NSTimer
				 scheduledTimerWithTimeInterval:0.1
				 target:self
				 selector:@selector(updateProgress:)
				 userInfo:nil
				 repeats:YES];
		}
	}
	else {
		if (progressUpdateTimer)
		{
			[progressUpdateTimer invalidate];
			progressUpdateTimer = nil;
		}
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
    if (streamer)
	{
		return;
	}

	[self destroyStreamer];

	self.downloadSourceURL = @"http://kpcc.streamguys.com/";
    
	NSString *escapedValue =
		[(NSString *)CFURLCreateStringByAddingPercentEscapes(
			nil,
			(CFStringRef)self.downloadSourceURL,
			NULL,
			NULL,
			kCFStringEncodingUTF8)
		autorelease];

	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	[self createTimers:YES];

	[[NSNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(playbackStateChanged:)
		name:ASStatusChangedNotification
		object:streamer];
#ifdef SHOUTCAST_METADATA
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(metadataChanged:)
	 name:ASUpdateMetadataNotification
	 object:streamer];
#endif
}

//
// viewDidLoad
//
// Creates the volume slider, sets the default path for the local file and
// creates the streamer immediately if we already have a file at the local
// location.
//
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
	//[volumeSlider addSubview:volumeView];
	//[volumeView sizeToFit];
	
	[self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
    self.view.layer.cornerRadius = 8.0;
    [metadataArtist setText:@"KPCC.org"];
    [progressSlider setValue:100.0];
    [progressSlider setEnabled:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	UIApplication *application = [UIApplication sharedApplication];
	if([application respondsToSelector:@selector(beginReceivingRemoteControlEvents)])
		[application beginReceivingRemoteControlEvents];
	[self becomeFirstResponder]; // this enables listening for events
	// update the UI in case we were in the background
	NSNotification *notification =
	[NSNotification
	 notificationWithName:ASStatusChangedNotification
	 object:self];
	[[NSNotificationCenter defaultCenter]
	 postNotification:notification];
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

//
// spinButton
//
// Shows the spin button when the audio is loading. This is largely irrelevant
// now that the audio is loaded from a local file.
//
- (void)spinButton
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [button frame];
	button.layer.anchorPoint = CGPointMake(0.5, 0.5);
	button.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];

	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[button.layer addAnimation:animation forKey:@"rotationAnimation"];

	[CATransaction commit];
}

//
// animationDidStop:finished:
//
// Restarts the spin animation on the button when it ends. Again, this is
// largely irrelevant now that the audio is loaded from a local file.
//
// Parameters:
//    theAnimation - the animation that rotated the button.
//    finished - is the animation finised?
//
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self spinButton];
	}
}

//
// buttonPressed:
//
// Handles the play/stop button. Creates, observes and starts the
// audio streamer when it is a play button. Stops the audio streamer when
// it isn't.
//
// Parameters:
//    sender - normally, the play/pause button.
//
- (IBAction)buttonPressed:(id)sender
{
	if ([button.currentImage isEqual:[UIImage imageNamed:@"playbutton.png"]])
	{
        [metadataAlbum setText:@"All Things Considered"];
        playing = YES;
		[self createStreamer];
		[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
		[streamer start];
	}
	else if ([button.currentImage isEqual:[UIImage imageNamed:@"pausebutton.png"]])
	{
        [self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
        playing = NO;
		[streamer pause];
        [metadataAlbum setText:@"All Things Considered"];
        
	}
}

//
// sliderMoved:
//
// Invoked when the user moves the slider
//
// Parameters:
//    aSlider - the slider (assumed to be the progress slider)
//
- (IBAction)sliderMoved:(UISlider *)aSlider
{
    if (!self.programTooltip)
    {
        CMPopTipView* poptip = [[CMPopTipView alloc] initWithMessage:[self getProgramForPos:aSlider.value]];
        poptip.backgroundColor = [UIColor colorWithRed:239/255 green:142/255 blue:73/255 alpha:1.0];
        self.programTooltip = poptip;
        float x = aSlider.frame.origin.x + ((aSlider.value/100.0)*aSlider.frame.size.width);
        float y = aSlider.frame.origin.y+15.0;
        UIView *anchor = [[UIView alloc] initWithFrame:CGRectMake(x, y, 0.1, 0.1)];
        [anchor setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:anchor];
        self.tooltipAnchor = anchor;
        [poptip presentPointingAtView:self.tooltipAnchor inView:self.view animated:YES];
    }
    
    if (streamer.duration)
	{
		double newSeekTime = (aSlider.value / 100.0) * streamer.duration;
		[streamer seekToTime:newSeekTime];
    }
}

-(IBAction)clearTooltip:(id)sender
{
    [self.programTooltip dismissAnimated:YES];
    self.programTooltip = nil;
    self.tooltipAnchor = nil;
}

-(NSString*)getProgramForPos:(float)pos
{
    if (pos<10.0)
    {
        return @"Morning Edition";
    }
    else if (pos<30.0)
    {
        return @"Talk of the Nation";
    }
    else if (pos<50.0)
    {
        return @"Here and Now";
    }
    else return @"All Things Considered";
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
	}
	else if ([streamer isPlaying])
	{
		[self setButtonImage:[UIImage imageNamed:@"pausebutton.png"]];
	}
	else if ([streamer isPaused]) {
		[self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
	}
	else if ([streamer isIdle])
	{
        [self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
		[self destroyStreamer];
	}
}

//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateProgress:(NSTimer *)updatedTimer
{
    
	if (streamer.bitRate != 0.0)
	{
        if (playing)
        {
            playDuration += updatedTimer.timeInterval;
            
            NSUInteger h, m, s;
            h = ((NSUInteger)(playDuration / 60)) / 60;
            m = ((NSUInteger)(playDuration / 60)) % 60;
            s = ((NSUInteger)(playDuration)) % 60;
            [elapsedLabel setText:[NSString stringWithFormat:@"%d:%02d:%02d", h, m, s]];
        }
        /*
		double progress = streamer.progress;
		double duration = streamer.duration;
		
		if (duration > 0)
		{
            NSUInteger h, m, s;
            h = (progress / 3600);
            m = ((NSUInteger)(progress / 60)) % 60;
            s = ((NSUInteger) progress) % 60;
            NSString *strElapsed = [NSString stringWithFormat:@"%d:%02d:%02d", h, m, s];

            h = ((duration-progress) / 3600);
            m = ((NSUInteger)((duration-progress) / 60)) % 60;
            s = ((NSUInteger) (duration-progress)) % 60;
            NSString *strRemain = [NSString stringWithFormat:@"%d:%02d:%02d", h, m, s];
            
            
			[elapsedLabel setText:
				[NSString stringWithFormat:@"%@",
					strElapsed]];
            [remainingLabel setText:
             [NSString stringWithFormat:@"%@",
              strRemain]];
			[progressSlider setEnabled:YES];
			[progressSlider setValue:100 * progress / duration];
		}
		else
		{
			[progressSlider setEnabled:NO];
		}
         */
	}
	else
	{
		elapsedLabel.text = @"00:00:00";
        remainingLabel.text = @"00:00:00";
	}
}

#ifdef SHOUTCAST_METADATA
/** Example metadata
 *
 StreamTitle='Kim Sozzi / Amuka / Livvi Franc - Secret Love / It's Over / Automatik',
 StreamUrl='&artist=Kim%20Sozzi%20%2F%20Amuka%20%2F%20Livvi%20Franc&title=Secret%20Love%20%2F%20It%27s%20Over%20%2F%20Automatik&album=&duration=1133453&songtype=S&overlay=no&buycd=&website=&picture=',
 
 Format is generally "Artist hypen Title" although servers may deliver only one. This code assumes 1 field is artist.
 */
- (void)metadataChanged:(NSNotification *)aNotification
{
	NSString *streamArtist;
	NSString *streamTitle;
	NSString *streamAlbum;
    //NSLog(@"Raw meta data = %@", [[aNotification userInfo] objectForKey:@"metadata"]);
    
	NSArray *metaParts = [[[aNotification userInfo] objectForKey:@"metadata"] componentsSeparatedByString:@";"];
	NSString *item;
	NSMutableDictionary *hash = [[NSMutableDictionary alloc] init];
	for (item in metaParts) {
		// split the key/value pair
		NSArray *pair = [item componentsSeparatedByString:@"="];
		// don't bother with bad metadata
		if ([pair count] == 2)
			[hash setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
	}
    
	// do something with the StreamTitle
	NSString *streamString = [[hash objectForKey:@"StreamTitle"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
	
	NSArray *streamParts = [streamString componentsSeparatedByString:@" - "];
	if ([streamParts count] > 0) {
		streamArtist = [streamParts objectAtIndex:0];
	} else {
		streamArtist = @"";
	}
	// this looks odd but not every server will have all artist hyphen title
	if ([streamParts count] >= 2) {
		streamTitle = [streamParts objectAtIndex:1];
		if ([streamParts count] >= 3) {
			streamAlbum = [streamParts objectAtIndex:2];
		} else {
			streamAlbum = @"N/A";
		}
	} else {
		streamTitle = @"";
		streamAlbum = @"";
	}
	NSLog(@"%@ by %@ from %@", streamTitle, streamArtist, streamAlbum);
    
	// only update the UI if in foreground
	metadataArtist.text = streamArtist;
    
	self.currentArtist = streamArtist;
	self.currentTitle = streamTitle;
}
#endif

//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
	[self destroyStreamer];
	[self createTimers:NO];
	[super dealloc];
}

#pragma mark Remote Control Events
/* The iPod controls will send these events when the app is in the background */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlPlay:
			[streamer start];
			break;
		case UIEventSubtypeRemoteControlPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlStop:
			[streamer stop];
			break;
		default:
			break;
	}
}

@end
