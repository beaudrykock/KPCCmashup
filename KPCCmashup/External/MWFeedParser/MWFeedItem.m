//
//  MWFeedItem.m
//  MWFeedParser
//
//  Copyright (c) 2010 Michael Waterfall
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  1. The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//  
//  2. This Software cannot be used to archive or collect data such as (but not
//     limited to) that of events, news, experiences and activities, for the 
//     purpose of any concept relating to diary/journal keeping.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MWFeedItem.h"

#define EXCERPT(str, len) (([str length] > len) ? [[str substringToIndex:len-1] stringByAppendingString:@"…"] : str)

@implementation MWFeedItem

@synthesize identifier, title, link, date, updated, summary, content, enclosures, imgURL;

#pragma mark NSObject

- (NSString *)description {
	NSMutableString *string = [[NSMutableString alloc] initWithString:@"MWFeedItem: "];
	if (title)   [string appendFormat:@"“%@”", EXCERPT(title, 50)];
	if (date)    [string appendFormat:@" - %@", date];
	//if (link)    [string appendFormat:@" (%@)", link];
	//if (summary) [string appendFormat:@", %@", EXCERPT(summary, 50)];
	return [string autorelease];
}

- (void)dealloc {
	[identifier release];
	[title release];
	[link release];
	[date release];
	[updated release];
	[summary release];
	[content release];
	[enclosures release];
    [imgURL release];
	[super dealloc];
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
		identifier = [[decoder decodeObjectForKey:@"identifier"] retain];
		title = [[decoder decodeObjectForKey:@"title"] retain];
		link = [[decoder decodeObjectForKey:@"link"] retain];
		date = [[decoder decodeObjectForKey:@"date"] retain];
		updated = [[decoder decodeObjectForKey:@"updated"] retain];
		summary = [[decoder decodeObjectForKey:@"summary"] retain];
		content = [[decoder decodeObjectForKey:@"content"] retain];
		enclosures = [[decoder decodeObjectForKey:@"enclosures"] retain];
        imgURL = [[decoder decodeObjectForKey:@"imgURL"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	if (identifier) [encoder encodeObject:identifier forKey:@"identifier"];
	if (title) [encoder encodeObject:title forKey:@"title"];
	if (link) [encoder encodeObject:link forKey:@"link"];
	if (date) [encoder encodeObject:date forKey:@"date"];
	if (updated) [encoder encodeObject:updated forKey:@"updated"];
	if (summary) [encoder encodeObject:summary forKey:@"summary"];
	if (content) [encoder encodeObject:content forKey:@"content"];
	if (enclosures) [encoder encodeObject:enclosures forKey:@"enclosures"];
    if (imgURL) [encoder encodeObject:summary forKey:@"imgURL"];
}

@end
