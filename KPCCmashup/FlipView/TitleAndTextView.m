/*
 This module is licensed under the MIT license.
 
 Copyright (C) 2011 by raw engineering
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
//
//  TitleAndTextView.m
//  FlipView
//
//  Created by Reefaq Mohammed on 16/07/11.
 
//

#import "TitleAndTextView.h"
#import "MessageModel.h"
#import "UIImageView+WebCache.h"

@implementation TitleAndTextView

@synthesize messageModel, delegate;

- (id) initWithMessageModel:(MessageModel*)messagemodel andDelegate:(id)delegate_{
	if (self = [super init]) {
        self.delegate=delegate_;
		self.messageModel = messagemodel;
		[self initializeFields];
		
		UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[self addGestureRecognizer:tapRecognizer];
		[tapRecognizer release];

	}
	return self;
}

- (void)reAdjustLayout{

	[contentView setFrame:CGRectMake(1, 1, self.frame.size.width-2, self.frame.size.height - 2)];
	
	CGSize contentViewArea = CGSizeMake((contentView.frame.size.width - 10), (contentView.frame.size.height-15));
	NSLog(@"image height %f width %f", userImageView.image.size.height, userImageView.image.size.width);
    if(userImageView.image.size.height>0){
    float proportion = (userImageView.image.size.height/userImageView.image.size.width);
    
        [userImageView setFrame:CGRectMake(5, 5, contentViewArea.width/2, (contentViewArea.width/2)*proportion)];
    }
    else{
        [userImageView setFrame:CGRectMake(0, 0, contentViewArea.width, 100)];
    }
	[userNameLabel sizeToFit];
	[userNameLabel setFrame:CGRectMake(userImageView.frame.origin.x, userImageView.frame.origin.y+userImageView.frame.size.height+5, (contentViewArea.width - 10), userNameLabel.frame.size.height)];
	[timeStampLabel sizeToFit];
	[timeStampLabel setFrame:CGRectMake(userNameLabel.frame.origin.x, userNameLabel.frame.origin.y + userNameLabel.frame.size.height, timeStampLabel.frame.size.width, timeStampLabel.frame.size.height)];
	
	[messageLabel setFrame:CGRectMake(timeStampLabel.frame.origin.x ,(timeStampLabel.frame.origin.y + timeStampLabel.frame.size.height+10), contentViewArea.width, contentViewArea.height - (timeStampLabel.frame.origin.y + timeStampLabel.frame.size.height))];
		
		
	[messageLabel setText:messageModel.content];
	messageLabel.contentMode = UITextAlignmentLeft;
		
//		float widthOffset = (messageLabel.frame.size.width - textSize.width)/ 2;
//		float heightOffset = (messageLabel.frame.size.height - textSize.height)/2;
		//[messageLabel setContentInset:UIEdgeInsetsMake(heightOffset, widthOffset, heightOffset, widthOffset)];


}

- (void) initializeFields {
	contentView = [[UIView alloc] init];
	[contentView setBackgroundColor:[UIColor whiteColor]];
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	userNameLabel = [[UILabel alloc] init];
	[userNameLabel setText:[NSString stringWithFormat:@"%@",messageModel.title]];
	userNameLabel.font =[UIFont fontWithName:kFontFamily size:15];
	[userNameLabel setTextColor:RGBCOLOR(2,90,177)];
    userNameLabel.numberOfLines=2;
	[userNameLabel setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:userNameLabel];
	
	
	timeStampLabel = [[UILabel alloc] init];
	[timeStampLabel setText:messageModel.createdAt];
	timeStampLabel.font =[UIFont fontWithName:kFontFamily size:12];
	[timeStampLabel setTextColor:RGBCOLOR(111,111,111)];
	[timeStampLabel setBackgroundColor:[UIColor clearColor]];
	[contentView addSubview:timeStampLabel];
	
	messageLabel = [[UILabel alloc] init];
	messageLabel.font = [UIFont fontWithName:kFontFamily size:13];
	messageLabel.textColor =  RGBCOLOR(33,33,33);
	messageLabel.highlightedTextColor = RGBCOLOR(33,33,33);
	messageLabel.contentMode = UIViewContentModeCenter;
	messageLabel.textAlignment = UITextAlignmentLeft;
	[messageLabel setBackgroundColor:[UIColor whiteColor]];
	messageLabel.numberOfLines = 0;
	[contentView addSubview:messageLabel];
	
	[self addSubview:contentView];
    
    userImageView = [[UIImageView alloc] init];
    userImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [userImageView setImageWithURL:[NSURL URLWithString:messageModel.image]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                           success:^(UIImage *image, BOOL cached) {
                               NSLog(@"image height %f width %f", image.size.height, image.size.width);
                               [self reAdjustLayout];
                           }
                           failure:^(NSError *error) {
                               
                           }];
    
	
	[contentView addSubview:userImageView];

	
	//[self reAdjustLayout];
}

-(void)tapped:(UITapGestureRecognizer *)recognizer {
	//Parent controller needs to show in full screen
    //[[FlipViewAppDelegate instance] showViewInFullScreen:self withModel:self.messageModel];
    if([delegate respondsToSelector:@selector(showViewInFullScreen:withModel:)]){
        [delegate performSelector:@selector(showViewInFullScreen:withModel:) withObject:self withObject:self.messageModel];
    }
}


-(void) setFrame:(CGRect)rect {
		self.originalRect = rect;
		[super setFrame:rect];
}

- (void) dealloc{
	[messageModel release];
	[contentView release];
	[userImageView release];
	[userNameLabel release];
	[timeStampLabel release];
	[messageLabel release];
    [delegate release];
    
	[super dealloc];
}


@end
