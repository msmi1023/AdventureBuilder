//
//  SelectReturningFlightViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "SelectReturningFlightViewController.h"
#import "ListFlightTableCell.h"

@implementation SelectReturningFlightViewController {
	NSArray *flights;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"ListFlightTableCell" bundle:nil] forCellReuseIdentifier:@"ListFlightTableCell"];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[_flightService getFlightsOfType:@"returning" withCompletionBlock:^(id response){
		flights = response;
		[_tableView reloadData];
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return flights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ListFlightTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListFlightTableCell"];
	
	[cell setFlightandLabelsFromFlight:((Flight *)flights[indexPath.row])];
	
	//stripe even rows with a very light grey background.
	if(indexPath.row % 2) {
		cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
	}
	//cells get reused! reset for odd rows.
	else {
		cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ListFlightTableCell height];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_bookingService.booking.returningFlight = flights[indexPath.row];
	
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

@end
