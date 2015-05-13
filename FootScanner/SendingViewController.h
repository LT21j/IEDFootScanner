//
//  SendingTableViewController.h
//  FootScanner
//
//  Created by John Sayour on 3/30/15.
//  Copyright (c) 2015 Rehab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <MessageUI/MessageUI.h>
@protocol SendingViewControllerDelegate <NSObject>

@required
-(NSArray *)getInfo;

@end

@interface SendingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate ,UITextFieldDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UITextField *doctorName;
@property (strong, nonatomic) UITextField *doctorEmail;
@property (strong, nonatomic) UITextField *emailSubject;
@property (assign, nonatomic) id<SendingViewControllerDelegate> delegate;

- (IBAction) submitButtonPressed:(id)sender;


@end
