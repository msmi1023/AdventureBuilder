//
//  Adventure.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/18/16.

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