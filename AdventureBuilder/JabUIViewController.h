//
//  JabUIViewController.h
//  AdventureBuilder
//
//  Created by msmi1023 on 7/22/16.

#import <UIKit/UIKit.h>
#import "JabUIFlowController.h"

@interface JabUIViewController : UIViewController

-(void)viewWillAppear:(BOOL)animated;
-(BOOL)phoneValidation:(id)sender;
-(BOOL)emailValidation:(id)sender;

@end
