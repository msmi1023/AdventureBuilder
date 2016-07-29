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
@property (strong, nonatomic) NSString *airline;
@property (strong, nonatomic) NSString *arrivalTime;
@property (strong, nonatomic) NSString *departureTime;
@property (strong, nonatomic) NSNumber *price;

-(id)init;
-(id)initWithDictionary:(NSDictionary *)jsonFlight;
-(NSDictionary *)getDictionaryRepresentation;
-(NSString *)serializeToJSON;
-(BOOL)compareTo:(Flight *)anotherFlight;

@end
