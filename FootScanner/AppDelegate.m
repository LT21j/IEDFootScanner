//
//  AppDelegate.m
//  FootScanner
//
//  Created by John Sayour on 3/27/15.
//  Copyright (c) 2015 Rehab. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SendingViewController.h"
#import "MainGraphsTableViewController.h"
#import "RfduinoManager.h"
#import "ScanViewController.h"

@interface AppDelegate()
{
    RFduinoManager *rfduinoManager;
    bool wasScanning;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // create window.
    CGRect windowBounds = [[UIScreen mainScreen] applicationFrame];
    windowBounds.origin.y = 0.0;
    [self setWindow:[[UIWindow alloc] initWithFrame:windowBounds]];
    
    //set Rfdunio manager using the singlton method
    rfduinoManager = RFduinoManager.sharedRFduinoManager;
    
    //set tint
    self.window.tintColor = [UIColor colorWithRed:150.0f/255.0f
                                             green:230.0f/255.0f
                                              blue:230.0f/255.0f
                                             alpha:1.0f];
    
    // View Controllers for tabController (one viewController per tab)
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    // first tab
    HomeViewController *firstView = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    firstView.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Home" image:[UIImage imageNamed: @"home-25.png"] selectedImage:[UIImage imageNamed:@"home_filled-25.png"]];
    [viewControllers addObject:firstView];

    //second tab
    SendingViewController *secondView = [[SendingViewController alloc] initWithNibName:@"SendingViewController" bundle:nil];
    //UINavigationController *navController1 = [[UINavigationController alloc]initWithRootViewController:secondView];
     secondView.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Send Info" image:[UIImage imageNamed: @"upload-25.png"] selectedImage:[UIImage imageNamed:@"upload_filled-25.png"]];
    secondView.delegate = firstView;
    [viewControllers addObject: secondView];
    
    //3rd tab
    MainGraphsTableViewController *thirdView = [[MainGraphsTableViewController alloc] initWithNibName:@"MainGraphsTableViewController" bundle:nil];
    //SetNavigation Controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:thirdView];
    [navController setTitle:@"Graphs"];
    navController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Graphs" image:[UIImage imageNamed: @"line_chart-25.png"] selectedImage:[UIImage imageNamed:@"line_chart_filled-25.png"]];
    [viewControllers addObject:navController];

    // create the tab controller and add the view controllers
    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:viewControllers];
    
    //create the scan viewcontoller
    ScanViewController *scanVC = [[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
    [firstView addChildViewController:scanVC];
    scanVC.homeVC = firstView;
    
    // add tabbar and show
    [[self window] addSubview:[tabController view]];
    [self.window makeKeyAndVisible];
    
    
    self.window.rootViewController = tabController;
    
    //add the popup scan view
    [scanVC showInView:firstView.view animated: YES];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    wasScanning = false;
    
    if (rfduinoManager.isScanning) {
        wasScanning = true;
        [rfduinoManager stopScan];
    }

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (wasScanning) {
        [rfduinoManager startScan];
        wasScanning = false;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
