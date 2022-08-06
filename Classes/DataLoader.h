//
//  DataLoader.h
//  PioneerHockey
//
//  Created by Ryan Morlok on 4/16/10.
//  Copyright 2010 Morlok Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JSON_URL @"http://services.hmpioneers.net/pioneerhockey/v1/schedule.py"

@interface DataLoader : NSObject {
	NSURLConnection *jsonConnection;
	NSMutableData *jsonData;
	id delegate;
}

- (void)loadDataAsync;

@property (retain, nonatomic) id delegate;

@end
