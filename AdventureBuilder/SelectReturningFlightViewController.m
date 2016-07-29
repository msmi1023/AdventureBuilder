//
//  SelectReturningFlightViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "SelectReturningFlightViewController.h"

@implementation SelectReturningFlightViewController {
	NSArray *flights;
}

- (void)viewDidLoad {
	[super viewDidLoad];
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

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return flights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	}
	
	cell.textLabel.text = ((Flight *)flights[indexPath.row]).flightNumber;
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_bookingService.booking.returningFlight = flights[indexPath.row];
}

@end
