//
//  FlipsideViewController.m
//  PioneerHockey
//
//  Created by Ryan Morlok on 4/12/10.
//  Copyright Morlok Technologies 2010. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)done {
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (IBAction)launchHmPioneersNet
{
	NSURL *url = [NSURL URLWithString:@"http://www.hmpioneers.net"];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


@end
