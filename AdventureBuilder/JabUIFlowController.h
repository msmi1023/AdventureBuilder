//
//  JabUIFlowController.h
//  AdventureBuilder
//
//  Created by tstone10 on 7/22/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BookingService.h"

@interface JabUIFlowController : NSObject

@property(strong, nonatomic) BookingService *bookingServiceInstance;
@property(strong, nonatomic) UIStoryboard *mainStoryboard;
@property(strong, nonatomic) UIStoryboard *addBookingStoryboard;

-(void)transitionBackFromController:(UIViewController *)vc;
-(id)transitionForwardFromController:(UIViewController *)vc;

-(UIViewController *)presentInitialViewControllerForStoryboardIdentifier:(NSString *)identifier fromController:(UIViewController *)currentVc onWindow:(UIWindow *)window;

+(instancetype)sharedController;

@end
