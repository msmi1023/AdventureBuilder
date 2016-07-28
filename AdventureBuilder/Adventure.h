//
//  Adventure.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/18/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Adventure : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *dailyPrice;
@property (strong, nonatomic) NSArray *activities;

-(id)init;
-(id)initWithDictionary:(NSDictionary *)jsonAdventure;
-(NSDictionary *)getDictionaryRepresentation;
-(NSString *)serializeToJSON;
-(BOOL)compareTo:(Adventure *)anotherAdventure;

@end