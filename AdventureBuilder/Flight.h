//
//  Flight.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flight : NSObject

@property (strong, nonatomic) NSString *flightNumber;
@property (strong, nonatomic) NSNumber *price;

-(id)initWithDictionary:(NSDictionary *)jsonFlight;

@end
