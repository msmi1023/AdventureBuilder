//
//  JabUIViewController.m
//  AdventureBuilder
//
//  Created by tstone10 on 7/22/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "JabUIViewController.h"

//need these here for dependency logic. can't have in .h, causes circular deps
#import "ListBookingViewController.h"
#import "EnterCustomerInformationViewController.h"
#import "SelectAdventureViewController.h"
#import "SelectBookingOptionsViewController.h"
#import "SelectDepartingFlightViewController.h"
#import "SelectReturningFlightViewController.h"
#import "ReviewBookingDetailsViewController.h"

@implementation JabUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
	self.navigationItem.rightBarButtonItem.target = self;
	self.navigationItem.rightBarButtonItem.action = @selector(nextButtonPressed:);
	
	if([self isKindOfClass:[EnterCustomerInformationViewController class]]) {
		self.navigationItem.leftBarButtonItem.target = self;
		self.navigationItem.leftBarButtonItem.action = @selector(cancelButtonPressed:);
	}
}

- (IBAction)cancelButtonPressed:(id)sender {
	[[JabUIFlowController sharedController] transitionBackFromController:self];
}

- (IBAction)nextButtonPressed:(id)sender {
	if([self isKindOfClass:[ListBookingViewController class]]) {
		[[JabUIFlowController sharedController] presentInitialViewControllerForStoryboardIdentifier:@"AddBooking" fromController:self onWindow:nil ];
	}
	else {
		[[JabUIFlowController sharedController] transitionForwardFromController:self];
	}
}

@end
