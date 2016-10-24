//
//  AppConfig.swift
//  NKit
//
//  Created by Nghia Nguyen on 10/22/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit

public typealias NKAppConfig = UIApplicationDelegate

public class NKAppConfigManager: NSObject, UIApplicationDelegate {
    
    private let configs: [NKAppConfig]
    
    public init(configs: [NKAppConfig]) {
        self.configs = configs
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        self.configs.forEach { (appConfig) in
            _ = appConfig.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            _ = appConfig.applicationDidBecomeActive?(application)
        }
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationWillResignActive?(application)
        }
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationDidEnterBackground?(application)
        }
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationWillEnterForeground?(application)
        }
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationWillTerminate?(application)
        }
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        for appConfig in self.configs {
            if appConfig.application?(application, open: url, sourceApplication: sourceApplication, annotation: annotation) == true {
                return true
            }

        }
        return false
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        for appConfig in self.configs {
            if appConfig.application?(app, open: url, options: options) == true {
                return true
            }
        }
        return false
    }
    
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        for appConfig in self.configs {
            if appConfig.application?(application, continue: userActivity, restorationHandler: restorationHandler) == true {
                return true
            }
        }
        
        return false
    }
    
    public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        self.configs.forEach { (appConfig) in
            appConfig.application?(application, didFailToContinueUserActivityWithType: userActivityType, error: error)
        }
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.configs.forEach { (appConfig) in
            appConfig.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.configs.forEach { (appConfig) in
            appConfig.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }
    
    public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        self.configs.forEach { (appConfig) in
            appConfig.application?(application, didRegister: notificationSettings)
        }
    }
    
    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationDidReceiveMemoryWarning?(application)
        }
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        self.configs.forEach { (appConfig) in
            appConfig.application?(application, didReceiveRemoteNotification: userInfo)
        }
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.configs.forEach { (appConfig) in
            appConfig.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
}

