//
//  FirstViewController.h
//  FootScanner
//
//  Created by John Sayour on 3/27/15.
//  Copyright (c) 2015 Rehab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFduino.h"
#import "Record Session.h"
#import "SendingViewController.h"

@interface HomeViewController : UIViewController <RFduinoDelegate, SendingViewControllerDelegate>

@property(strong, nonatomic) RFduino *rfduino;
@property(strong, nonatomic) NSMutableArray *recordingSessions;
@property (strong, nonatomic) IBOutlet UIButton *StartButton;
@property (strong, nonatomic) IBOutlet UIButton *disconnectButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;

- (IBAction)disconnectButtonPressed:(id)sender;

- (IBAction)startButtonPressed:(id)sender;
- (IBAction)stopButtonPressed:(id)sender;


@end
