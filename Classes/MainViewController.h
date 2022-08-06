//
//  MainViewController.h
//  PioneerHockey
//
//  Created by Ryan Morlok on 4/12/10.
//  Copyright Morlok Technologies 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MTIBulbView.h"
#import "DataLoader.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	IBOutlet UIActivityIndicatorView *activityView;
	IBOutlet MTIBulbView *usName;
	IBOutlet MTIBulbView *usScore;
	IBOutlet MTIBulbView *themName;
	IBOutlet MTIBulbView *themScore;
	IBOutlet DataLoader *dataLoader;
	IBOutlet UILabel *vsOrAt;
	IBOutlet UILabel *nextLabel;
	IBOutlet UILabel *currentGameDescription;
	TTStyledTextLabel *nextGameDescription;
}

- (IBAction)showInfo;
- (IBAction)loadData;

@end
