//
//  Customer.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/18/16.

#import <Foundation/Foundation.h>

@interface Customer : NSObject

@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phone;

-(id)init;
-(id)initWithDictionary:(NSDictionary *)jsonCustomer;
-(NSDictionary *)getDictionaryRepresentation;
-(NSString *)serializeToJSON;
-(BOOL)compareTo:(Customer *)anotherCustomer;

@end