//
//  JabUIStoryboard.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/21/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingService.h"

@interface JabUIStoryboard : UIStoryboard

@property(strong, nonatomic) BookingService *bookingServiceInstance;

+ (instancetype)storyboardWithName:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil;
- (id)instantiateViewControllerWithIdentifier:(NSString *)identifier;

@end
