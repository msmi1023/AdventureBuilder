//
//  SelectDepartingFlightViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "SelectDepartingFlightViewController.h"
#import "JabUIFlowController.h"

@implementation SelectDepartingFlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	NSLog(@"%@", _bookingService);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	}
	
	//cell.textLabel.text = [NSString stringWithFormat:@"%@", ((Booking *)_bookingList[indexPath.row]).confirmationNumber];
	
	return cell;
}

- (IBAction)nextButtonPressed:(id)sender {
	[[JabUIFlowController sharedController] transitionForwardFromController:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
