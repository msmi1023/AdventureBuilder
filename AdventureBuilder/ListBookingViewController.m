//
//  ListBookingViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "ListBookingViewController.h"
#import "BookingService.h"
#import "JabApiManager.h"

@implementation ListBookingViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	
	
	NSLog(@"%@", _bookingService);
}

- (void)viewWillAppear:(BOOL)animated {
	[self retrieveBookingData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _bookingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	}
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@", ((Booking *)_bookingList[indexPath.row]).confirmationNumber];
	
	return cell;
}

-(void)retrieveBookingData {
	[_bookingService getBookingsWithCompletionBlock:^(id response) {
		if(![response isKindOfClass:[NSError class]]) {
			_bookingList = response;
			[_tableView reloadData];
		}
	}];
}

-(IBAction)unwindToListBooking:(UIStoryboardSegue *)segue {
	
}

@end