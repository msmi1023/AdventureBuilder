//
//  ReviewBookingDetailsViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "ReviewBookingDetailsViewController.h"
#import "JabUIStoryboard.h"

@interface ReviewBookingDetailsViewController ()

@end

@implementation ReviewBookingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	NSLog(@"%@", _bookingService);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(id)sender {
	//[[self navigationController] popToRootViewControllerAnimated:YES];
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
//	JabUIStoryboard *storyboard = [JabUIStoryboard storyboardWithName:@"Main" bundle:nil];
//	UIViewController *vc = [storyboard instantiateInitialViewController];
//	self.view.window.rootViewController = vc;
//	
//	[self.view.window makeKeyAndVisible];

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
