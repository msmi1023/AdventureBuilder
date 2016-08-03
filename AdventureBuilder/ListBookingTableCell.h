//
//  ListBookingTableCell.h
//  AdventureBuilder
//
//  Created by msmi1023 on 8/1/16.

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
