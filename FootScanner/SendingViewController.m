//
//  SendingTableViewController.m
//  FootScanner
//
//  Created by John Sayour on 3/30/15.
//  Copyright (c) 2015 Rehab. All rights reserved.
//

#import "SendingViewController.h"
#import "Record Session.h"
#import "Step.h"

@interface SendingViewController ()
{
    NSArray *recordingSessions;
}

-(BOOL) createTXT;
@end

@implementation SendingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"Initialize the second Tab");
    
    if (self) {
        //set the title for the tab
        //self.title = @"Send Info";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Submit"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(submitPressed:)];
    //self.navigationItem.rightBarButtonItem = submitButton;
*/
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submitButtonPressed:(id)sender
{
    if([self.delegate respondsToSelector:@selector(getInfo)])
    {
        recordingSessions= [[NSArray alloc] initWithArray:[self.delegate getInfo]];
    }

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    NSArray *recipent = [NSArray arrayWithObject:_doctorEmail.text];
    [mc setSubject:_emailSubject.text];
    [mc setMessageBody:_doctorName.text isHTML:NO];
    [mc setToRecipients:recipent];
    
    if(self.createTXT)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *txtFilePath = [documentsDirectory stringByAppendingPathComponent:@"FootScanResults.txt"];
        NSData *noteData = [NSData dataWithContentsOfFile:txtFilePath];
        [mc addAttachmentData:noteData mimeType:@"text/plain" fileName:@"FootScanResults.txt"];
    }
    
    
   // [myAppDelegate *mDelegate = (myAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self presentViewController:mc animated:YES completion:NULL];
    //[[[[[UIApplication sharedApplication]delegate] window] rootViewController] presentViewController:mc animated:YES completion:NULL];
    
     // Present mail view controller on screen
    //[self presentViewController:mc animated:YES completion:NULL];
    
}

-(BOOL) createTXT
{
    if(recordingSessions == nil)
        return NO;
    NSError *error;
    NSMutableString *stringToWrite = [[NSMutableString alloc]init];
    [stringToWrite appendString: @"TEST RESULTS:\n"];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"FootScanResults.txt"];
    
    Record_Session *session;
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    Step *tempStep;
    for(int i=0; i<recordingSessions.count; i++)
    {
        session = recordingSessions[i];
        [stringToWrite appendString:[DateFormatter stringFromDate:session.dateTaken]];
        [stringToWrite appendString:@"\n"];
        for(int j=0; j<session.steps.count; j++)
        {
            tempStep = session.steps[j];
            [stringToWrite appendFormat:@"Step: %i /n Sensor 1: ", j];
            for(int k=0; k<tempStep.sensor1.count; k++)
                [stringToWrite appendFormat:@"%i, ", [[tempStep.sensor1 objectAtIndex:k] intValue]];
            [stringToWrite appendString:@"\n "];
            [stringToWrite appendFormat:@"Step: %i /n Sensor 2: ", j];
            for(int k=0; k<tempStep.sensor1.count; k++)
                [stringToWrite appendFormat:@"%i, ", [[tempStep.sensor2 objectAtIndex:k] intValue]];
            [stringToWrite appendString:@"\n "];
            [stringToWrite appendFormat:@"Step: %i /n Sensor 3: ", j];
            for(int k=0; k<tempStep.sensor1.count; k++)
                [stringToWrite appendFormat:@"%i, ", [[tempStep.sensor3 objectAtIndex:k] intValue]];
            [stringToWrite appendString:@"\n "];
            [stringToWrite appendFormat:@"Step: %i /n Sensor 4: ", j];
            for(int k=0; k<tempStep.sensor1.count; k++)
                [stringToWrite appendFormat:@"%i, ", [[tempStep.sensor4 objectAtIndex:k] intValue]];
            [stringToWrite appendString:@"\n "];
            [stringToWrite appendFormat:@"Step: %i /n Sensor 5: ", j];
            for(int k=0; k<tempStep.sensor1.count; k++)
                [stringToWrite appendFormat:@"%i, ", [[tempStep.sensor5 objectAtIndex:k] intValue]];
            [stringToWrite appendString:@"\n "];
        }
        [stringToWrite appendString:@"\n"];
    }
    
    [stringToWrite writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];

    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

//sets each sections title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [[NSString alloc] init];
    switch(section)
    {
        case 0:
            title = @"Doctor's Name";
            break;
        case 1:
            title = @"Doctor's Email";
            break;
        case 2:
            title = @"Subject";
            break;
        //case 3:
        //    title = @"";
        //    break;
        default:
            NSLog(@"ERROR: SendingTableViewController/tableView -> section asked for is not available \n");
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sendingDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if(indexPath.section < 3)
    {

        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 185, 30)];
        field.delegate = self;
        field.adjustsFontSizeToFitWidth = YES;
        field.textColor = [UIColor blackColor];
        field.returnKeyType = UIReturnKeyDone;
        field.keyboardType = UIKeyboardTypeDefault;
        field.autocorrectionType = UITextAutocorrectionTypeNo;
        field.autocapitalizationType = UITextAutocapitalizationTypeNone;
        switch(indexPath.section)
        {
            case 0:
                field.placeholder = @"Dr. Jones";
                field.autocapitalizationType = UITextAutocapitalizationTypeWords;
                _doctorName = field;
                break;
            case 1:
                field.placeholder = @"example@gmail.com";
                field.keyboardType = UIKeyboardTypeEmailAddress;
                _doctorEmail = field;
                break;
            case 2:
                field.placeholder = @"";
                field.text = @"My Foot Scan Results";
                field.autocorrectionType = UITextAutocorrectionTypeYes;
                field.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                _emailSubject = field;
                break;
        }
        //add subview to the cell
        [cell.contentView addSubview:field];
   /* }else if (indexPath.section == 3)
    {
        UILabel *label = [[UILabel alloc]initWithFrame: CGRectMake(110,12,185,30)];
        label.text = @"Send";
        [cell.contentView addSubview:label];*/
    }else
    {
        NSLog(@"ERROR SendingTableViewController/cellForRowAtIndexPath -> Section being asked for is not accounted");
    }
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
 
}
*/

#pragma mark - MFMailComposeViewController Delegate>
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Text view delegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
