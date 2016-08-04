//
//  ListBookingViewController.m
//  AdventureBuilder
//
//  Created by msmi1023 on 7/14/16.

#import "ListBookingViewController.h"
#import "ListBookingTableCell.h"

@implementation ListBookingViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"ListBookingTableCell" bundle:nil] forCellReuseIdentifier:@"ListBookingTableCell"];
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
	[self retrieveBookingData];
	
	[refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self retrieveBookingData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(_bookingList.count) {
		tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		return 1;
	}
	else {
		UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
		
		messageLabel.text = @"Booking data could not be retreived. Please pull down to attempt a refresh.";
		messageLabel.numberOfLines = 0;
		messageLabel.textAlignment = NSTextAlignmentCenter;
		[messageLabel sizeToFit];
		
		tableView.backgroundView = messageLabel;
		
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		return 0;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _bookingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ListBookingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListBookingTableCell"];
	
	//don't need to do this here - we can register the nib early to save on loading it each time.
	//if(!cell) {
		//cell = [[ListBookingTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ListBookingTableCell"];
		
		//NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListBookingTableCell" owner:self options:nil];
		//cell = [nib objectAtIndex:0];
	//}
	
	[cell setBookingAndLabelsFromBooking:((Booking *)_bookingList[indexPath.row])];
	
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
	return [ListBookingTableCell height];
}

-(void)retrieveBookingData {
	[_bookingService getBookingsWithCompletionBlock:^(id response) {
		//only update if we successfully got something.
		//this allows the previously-retrieved list to be used if a subsequent request fails.
		if(![response isKindOfClass:[NSError class]]) {
			_bookingList = response;
			[_tableView reloadData];
		}
	}];
}

@end