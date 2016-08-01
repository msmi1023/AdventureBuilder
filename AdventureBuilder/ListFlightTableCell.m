//
//  ListFlightTableCell.m
//  AdventureBuilder
//
//  Created by tstone10 on 8/1/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "ListFlightTableCell.h"

@implementation ListFlightTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	self.flightNumberLabel = [[UILabel alloc] init];
	self.airlineLabel = [[UILabel alloc] init];
	self.timeLabel = [[UILabel alloc] init];
	self.priceLabel = [[UILabel alloc] init];
	
	return self;
}

-(void)setFlightandLabelsFromFlight:(Flight *)flight {
	self.flight = flight;
	
	self.flightNumberLabel.text = self.flight.flightNumber;
	self.airlineLabel.text = self.flight.airline;
	self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", self.flight.departureTime, self.flight.arrivalTime];
	self.priceLabel.text = [NSString stringWithFormat:@"$%.2f", [[self.flight price] floatValue]];
}

- (UIEdgeInsets)layoutMargins {
	return UIEdgeInsetsZero;
}

+(CGFloat)height {
	return 60;
}

@end
