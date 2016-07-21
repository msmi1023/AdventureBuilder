//
//  EnterCustomerInformationViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "EnterCustomerInformationViewController.h"
#import "JabUIStoryboard.h"

@implementation EnterCustomerInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	NSLog(@"%@", _bookingService);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
//	JabUIStoryboard *storyboard = [JabUIStoryboard storyboardWithName:@"Main" bundle:nil];
//	UIViewController *vc = [storyboard instantiateInitialViewController];
//	self.view.window.rootViewController = vc;
//	
//	[self.view.window makeKeyAndVisible];
	//[[self navigationController] popToRootViewControllerAnimated:YES];
	
	[self dismissViewControllerAnimated:YES completion:nil];
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
