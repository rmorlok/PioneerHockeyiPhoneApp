//
//  DataLoader.m
//  PioneerHockey
//
//  Created by Ryan Morlok on 4/16/10.
//  Copyright 2010 Morlok Technologies. All rights reserved.
//

#import "DataLoader.h"
#import "SBJSON.h"

@implementation DataLoader

@synthesize delegate;

- (id)init
{
	self = [super init];
	
	if(self) {

	}
	
	return self;
}

- (void)loadDataAsync
{
	NSLog(@"Starting data load.");
	
	NSURL *jsonUrl = [NSURL URLWithString:JSON_URL];
	NSMutableURLRequest *jsonRequest = [NSMutableURLRequest requestWithURL:jsonUrl];
	[jsonRequest addValue:@"text/json" forHTTPHeaderField:@"Content-type"];
	[jsonRequest setHTTPMethod:@"GET"];	
	
	if( jsonConnection = [[NSURLConnection alloc] initWithRequest:jsonRequest delegate:self] ) {
		// Connection opened
		jsonData = [[NSMutableData data] retain];
	} else {
		// Failed to create the connection.
	}
}

-(void) dealloc
{
	[jsonConnection release];
	[jsonData release];
	
	jsonConnection = nil;
	jsonData = nil;
	
	[super dealloc];
}

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection 
didReceiveResponse:(NSURLResponse *)response
{
	[jsonData setLength:0];
}

- (void)connection:(NSURLConnection *)connection 
	didReceiveData:(NSData *)data
{
	NSLog(@"Received data");
	[jsonData appendData:data];
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
	[jsonConnection release];
	[jsonData release];
	
	if( delegate && [delegate respondsToSelector:@selector(jsonFailWithError:)] ) {
		[delegate performSelector:@selector(jsonFailWithError:) withObject:error];
	}
	
	NSLog(@"Connection failed.");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Finished loading data");
	
	NSString *jsonString = [[NSString alloc] initWithBytes:[jsonData mutableBytes] 
													length:[jsonData length] 
												  encoding:NSUTF8StringEncoding];
	
	NSError *error;
	SBJSON *jsonParser = [[SBJSON alloc] init];
	
	id jsonObject = [jsonParser objectWithString:jsonString error:&error];
	
	if( !jsonObject 
	   && delegate 
	   && [delegate respondsToSelector:@selector(jsonFailWithError:)] ) 
	{
		[delegate performSelector:@selector(jsonFailWithError:) withObject:error];
	} else if( delegate && [delegate respondsToSelector:@selector(jsonResponse:)] ) {
		[delegate performSelector:@selector(jsonResponse:) withObject:jsonObject];
	}
	
	[jsonString release];
	[jsonConnection release];
	[jsonData release];
}
@end
