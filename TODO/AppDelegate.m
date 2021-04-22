//
//  AppDelegate.m
//  TODO
//
//  Created by AbdElRahman Nabil on 4/5/21.
//  Copyright © 2021 AbdElRahman Nabil. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
       completionHandler:^(BOOL granted, NSError * _Nullable error) {
          // Enable or disable features based on authorization.
    }];
    return YES;
}


#pragma mark - UISceneSession lifecycle

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:notification.alertTitle    message:notification.alertBody
    delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

    [notificationAlert show];
   // NSLog(@"didReceiveLocalNotification");
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    UNNotificationPresentationOptions presentationOptions =      UNNotificationPresentationOptionSound+UNNotificationPresentationOptionAlert;
    completionHandler(presentationOptions);
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
