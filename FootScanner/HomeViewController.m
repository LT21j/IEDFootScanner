//
//  FirstViewController.m
//  FootScanner
//
//  Created by John Sayour on 3/27/15.
//  Copyright (c) 2015 Rehab. All rights reserved.
//

#import "HomeViewController.h"
#import "ScanViewController.h"
#import "Step.h"

@interface HomeViewController ()
{
    Record_Session *curSession;
    Step *curStep;
}
//method to send a byte of data to RFduino
-(void) sendByte:(uint8_t)byte;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"Initialize the first Tab");
    
    if (self) {
        //set the title for the tab
        self.recordingSessions = [[NSMutableArray alloc] init];
        self.title = @"Home";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _disconnectButton.layer.cornerRadius = 10;
    _StartButton.layer.cornerRadius = 30;
    _stopButton.layer.cornerRadius = 20;
    _stopButton.hidden = YES;
    _StartButton.hidden = NO;
    curSession = [[Record_Session alloc]init];
    curSession.dateTaken = [NSDate date];
    [_recordingSessions addObject:curSession];
    [_rfduino setDelegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendByte:(uint8_t)byte
{
    uint8_t tx[1] = { byte };
    NSData *data = [NSData dataWithBytes:(void*)&tx length:1];
    [_rfduino send:data];
}

- (void)didReceive:(NSData *)data
{
    NSLog(@"RecievedRX");
    
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    
    NSLog(@"Data length: %lu bytes", (unsigned long)len);
    
    unsigned short int c;
    for(int i=0; i<2; i++)
    {
        c=0;
        c = (((short)byteData[i*10+1]) << 8) | byteData[i*10];
        NSLog(@" FIRST BYTE: %i",c);
        if(c != 0 && c != 1)
        {
            for (int j=0; j<5; j++)
            {
                c=0;
                c = (((short)byteData[i*10+j*2+1]) << 8) | byteData[i*10+j*2];
                NSLog(@"%i",c);
                if(curSession != nil)
                {
                    switch(j)
                    {
                        case 0:
                            [curStep.sensor1 addObject:[NSNumber numberWithInt:c]];
                            break;
                        case 1:
                            [curStep.sensor2 addObject:[NSNumber numberWithInt:c]];
                            break;
                        case 2:
                            [curStep.sensor3 addObject:[NSNumber numberWithInt:c]];
                            break;
                        case 3:
                            [curStep.sensor4 addObject:[NSNumber numberWithInt:c]];
                            break;
                        case 4:
                            [curStep.sensor5 addObject:[NSNumber numberWithInt:c]];
                            break;
                    }
                    
                }
            }
        }else if (c == 1)
        {
            //new step
            Step *tempStep = [[Step alloc] init];
            curStep = tempStep;
            [curSession.steps addObject:tempStep];
            
            /* Record_Session *recordObj = [[Record_Session alloc]init];
            curSession = recordObj;
            NSDate* curDate = [NSDate date];
            recordObj.dateTaken = curDate;
            [_recordingSessions addObject: recordObj];
            break;*/
            break;
        }
    }
    //float  = data(data);
    //float fahrenheit = (celsius * 9 / 5) + 32;
    
    //NSLog(@"c=%.2f, f=%.2f", celsius, fahrenheit);
    
    //NSString* string1 = [NSString stringWithFormat:@"%.2f ºC", celsius];
    //NSString* string2 = [NSString stringWithFormat:@"%.2f ºF", fahrenheit];
    
    //[label1 setText:string1];
    //[label2 setText:string2];
}

-(NSArray *) getInfo
{
    NSArray *temp = [[NSArray alloc] initWithArray:_recordingSessions];
    return temp;
}


- (IBAction)disconnectButtonPressed:(id)sender
{
    [_rfduino disconnect];
    ScanViewController *scanVC = [[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
    [self addChildViewController:scanVC];
    scanVC.homeVC = self;
    [scanVC showInView: self.view animated: YES];
}

- (IBAction)startButtonPressed:(id)sender
{
    //start bluetooth transfer
    [self sendByte:1];
    _stopButton.hidden = NO;
    _StartButton.hidden = YES;
}

- (IBAction)stopButtonPressed:(id)sender
{
    _stopButton.hidden = YES;
    _StartButton.hidden = NO;
}
@end
