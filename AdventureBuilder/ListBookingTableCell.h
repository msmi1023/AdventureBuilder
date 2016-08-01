//
//  ListBookingTableCell.h
//  AdventureBuilder
//
//  Created by tstone10 on 8/1/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Booking.h"

@interface ListBookingTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *confirmationNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) Booking *booking;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;
-(UIEdgeInsets)layoutMargins;
-(IBAction)detailIconPressed:(id)sender;
-(void)setBookingAndLabelsFromBooking:(Booking *)booking;
+(CGFloat)height;

@end
