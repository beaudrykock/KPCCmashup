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
//  TitleAndTextView.h
//  FlipView
//
//  Created by Reefaq Mohammed on 16/07/11.
 
//

#import <Foundation/Foundation.h>
#import "UIViewExtention.h"
@class MessageModel;

@interface TitleAndTextView : UIViewExtention {
	UIView* contentView;
	UIImageView* userImageView;
	UILabel* userNameLabel;
	UILabel* timeStampLabel;
	UILabel* messageLabel;
}

- (id) initWithMessageModel:(MessageModel*)messagemodel andDelegate:(id)delegate;
- (void) initializeFields;
	
@property (nonatomic,retain) MessageModel* messageModel;
@property (nonatomic, retain) id delegate;

@end
