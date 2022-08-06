//
//  MainViewController.m
//  PioneerHockey
//
//  Created by Ryan Morlok on 4/12/10.
//  Copyright Morlok Technologies 2010. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
    }
    return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	const CGFloat green[] = {0.0, 0.75, 0.0, 1.0};
	const CGFloat clearGreen[] = {0.0, 0.75, 0.0, 0.15};
	usName.litColor	= CGColorCreate(rgb, green);
	usName.dimColor	= CGColorCreate(rgb, clearGreen);
	usScore.litColor	= CGColorCreate(rgb, green);
	usScore.dimColor	= CGColorCreate(rgb, clearGreen);
	themName.litColor	= CGColorCreate(rgb, green);
	themName.dimColor	= CGColorCreate(rgb, clearGreen);
	themScore.litColor	= CGColorCreate(rgb, green);
	themScore.dimColor	= CGColorCreate(rgb, clearGreen);
	
	usName.alignment = MTIBulbViewAlignCenter;
	usScore.alignment = MTIBulbViewAlignCenter;
	themName.alignment = MTIBulbViewAlignCenter;
	themScore.alignment = MTIBulbViewAlignCenter;
	
	usName.text = @" ";
	usScore.text = @"--";
	themName.text = @" ";
	themScore.text = @"--";

	nextLabel.hidden = TRUE;
	
	nextGameDescription = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(80.0f, 275.0f, 220.0f, 61.0f)];
	nextGameDescription.font = [UIFont systemFontOfSize:14];
	nextGameDescription.contentInset = UIEdgeInsetsMake(0, 3, 0, 3);
	nextGameDescription.backgroundColor = [UIColor blackColor];
	const CGFloat lightGray[] = {0.624, 0.624, 0.624, 1.000};
	nextGameDescription.textColor = [UIColor colorWithCGColor:CGColorCreate(rgb, lightGray)];
	nextGameDescription.text = [TTStyledText textFromXHTML:@""];
	[self.view addSubview:nextGameDescription];
	
	dataLoader = [[DataLoader alloc] init];
	dataLoader.delegate = self;
	[self loadData];
	
	CGColorSpaceRelease(rgb);
}

- (void)awakeFromNib {
}


- (void)loadData
{
	// Use the loading circle as a guard agains double loads (this totally not thread safe)
	if( activityView.hidden ) {
		activityView.hidden = FALSE;
		[activityView startAnimating];
		[dataLoader loadDataAsync];
	}
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self loadData];
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
	TT_RELEASE_SAFELY(dataLoader);
	TT_RELEASE_SAFELY(currentGameDescription);
	TT_RELEASE_SAFELY(nextGameDescription);
	
	dataLoader = nil;
	
    [super dealloc];
}

#pragma mark Data loading delegate methods

- (void) jsonFailWithError:(NSError *)error
{
	NSLog(@"JSON FAIL.");
	
	[activityView stopAnimating];
	activityView.hidden = TRUE;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Connect to Server" message:@"Could not connect to server, please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    [alertView release];
}

- (NSString*) gameDescriptionFromJSONObject:(id)jsonObject
								returnXHTML:(BOOL)html
{
	NSString *homeAway = (NSString*)[jsonObject valueForKey:@"homeAway"];
	NSString *opponent = (NSString*)[jsonObject valueForKey:@"opponent"];
	NSString *location = (NSString*)[jsonObject valueForKey:@"location"];
	NSString *locationLink = (NSString*)[jsonObject valueForKey:@"locationLink"];
	NSString *dateString = (NSString*)[jsonObject valueForKey:@"date"];
	NSString *time = (NSString*)[jsonObject valueForKey:@"time"];
	
	NSDate *date = [NSDate dateWithNaturalLanguageString:dateString];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatter.dateStyle = NSDateFormatterLongStyle;
	
	NSString *descriptionText;
	
	if( html) {
		descriptionText = [NSString stringWithFormat:@"Hill-Murray %@ %@\n%@%@\n<a href=\"%@\">%@</a>",
						   ([homeAway isEqualToString:@"H"] ? @"vs." : @"@"),
						   opponent,
						   [dateFormatter stringFromDate:date],
						   (time ? [NSString stringWithFormat:@", %@", time] : @""),
						   [locationLink stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"],
						   location];
		
	} else {
		descriptionText = [NSString stringWithFormat:@"Hill-Murray %@ %@\n%@%@\n%@",
						   ([homeAway isEqualToString:@"H"] ? @"vs." : @"@"),
						   opponent,
						   [dateFormatter stringFromDate:date],
						   (time ? [NSString stringWithFormat:@", %@", time] : @""),
						   location];
		
	}
	
	return descriptionText;
}

- (void) jsonResponse:(id)jsonObject
{
	id lastGame = [jsonObject valueForKey:@"lastGame"];
	id nextGame = [jsonObject valueForKey:@"nextGame"];
	NSString *homeAway = (NSString*)[lastGame valueForKey:@"homeAway"];
	NSString *opponent = (NSString*)[lastGame valueForKey:@"opponent"];
	NSString *opponentAbbr = (NSString*)[lastGame valueForKey:@"opponentAbbr"];
	NSNumber *scoreUs = (NSNumber*)[lastGame valueForKey:@"scoreUs"];
	NSNumber *scoreThem = (NSNumber*)[lastGame valueForKey:@"scoreThem"];
	
    NSNumberFormatter *numberFormatter 
	= [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setFormatWidth:2];
	[numberFormatter setPaddingCharacter:@"0"];
	
	usName.text = @"PIONEERS";
	
	if( nil != opponentAbbr && [opponent length] > 7) {
		themName.text = opponentAbbr;
	} else {
		themName.text = opponent;
	}
	
	usScore.text = [numberFormatter stringFromNumber:scoreUs];
	themScore.text = [numberFormatter stringFromNumber:scoreThem];
	
	currentGameDescription.text = [self gameDescriptionFromJSONObject:lastGame  returnXHTML:NO];
	
	if( [homeAway isEqualToString:@"H"] ) {
		vsOrAt.text = @"vs";
	} else {
		vsOrAt.text = @"@";
	}
	
	if( nextGame ) {
		nextLabel.hidden = FALSE;
		nextGameDescription.text = [TTStyledText textFromXHTML:[self gameDescriptionFromJSONObject:nextGame returnXHTML:YES]
													lineBreaks:YES
														  URLs:YES];
	}
	
	[activityView stopAnimating];
	activityView.hidden = TRUE;
}
@end
