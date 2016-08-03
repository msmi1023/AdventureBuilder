//
//  AppDelegate.m
//  AdventureBuilder
//
//  Created by msmi1023 on 7/11/16.

#import "AppDelegate.h"
#import "JabUIFlowController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	//this has to happen here!
	//_window is a null pointer before doing this. that means that if we pass it through
	//and init in the flow controller, we don't effectively change it out here.
	//if we init before passing, any changes we make in the flow controller will apply out here.
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	[[JabUIFlowController sharedController] presentInitialViewControllerForStoryboardIdentifier:@"Main" fromController:nil onWindow:_window];
	
	return YES;
}

@end
