//
//  ListFlightTableCell.h
//  AdventureBuilder
//
//  Created by msmi1023 on 8/1/16.

#import <UIKit/UIKit.h>
#import "Flight.h"

@interface ListFlightTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *flightNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *airlineLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) Flight *flight;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;
-(UIEdgeInsets)layoutMargins;
-(void)setFlightandLabelsFromFlight:(Flight *)flight;
+(CGFloat)height;

@end
