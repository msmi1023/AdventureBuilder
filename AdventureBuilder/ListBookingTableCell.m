//
//  ListBookingTableCell.m
//  AdventureBuilder
//
//  Created by tstone10 on 8/1/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "ListBookingTableCell.h"
#import "JabUIFlowController.h"
#import "ListBookingViewController.h"

@implementation ListBookingTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	self.confirmationNumberLabel = [[UILabel alloc] init];
	self.emailLabel = [[UILabel alloc] init];
	self.dateLabel = [[UILabel alloc] init];
	self.priceLabel = [[UILabel alloc] init];
	
	return self;
}

-(void)setBookingAndLabelsFromBooking:(Booking *)booking {
	self.booking = booking;
	
	self.confirmationNumberLabel.text = [NSString stringWithFormat:@"%@", self.booking.confirmationNumber];
	self.emailLabel.text = [NSString stringWithFormat:@"%@", self.booking.customer.emailAddress];
	self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", [self.booking startDateStringForCell], [self.booking endDateStringForCell]];
	self.priceLabel.text = [NSString stringWithFormat:@"$%.2f", [[self.booking totalPrice] floatValue]];
}

- (UIEdgeInsets)layoutMargins {
	return UIEdgeInsetsZero;
}

-(IBAction)detailIconPressed:(id)sender {
	[[JabUIFlowController sharedController] transitionForwardFromController:((ListBookingViewController *)((UITableView *)self.superview.superview).delegate) fromSender:self];
}

+(CGFloat)height {
	return 60;
}

@end
