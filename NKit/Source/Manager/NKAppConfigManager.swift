//
//  AppConfig.swift
//  NKit
//
//  Created by Nghia Nguyen on 10/22/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import UIKit

public protocol NKAppConfigDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?)
    
    func applicationDidBecomeActive(_ application: UIApplication)
    func applicationWillResignActive(_ application: UIApplication)
    func applicationDidEnterBackground(_ application: UIApplication)
    func applicationWillEnterForeground(_ application: UIApplication)
    func applicationWillTerminate(_ application: UIApplication)
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool
    func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings)
    func applicationDidReceiveMemoryWarning(_ application: UIApplication)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
}

extension NKAppConfigDelegate {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = [:]) {}
    
    public func applicationDidBecomeActive(_ application: UIApplication) {}
    public func applicationWillResignActive(_ application: UIApplication) {}
    public func applicationDidEnterBackground(_ application: UIApplication) {}
    public func applicationWillEnterForeground(_ application: UIApplication) {}
    public func applicationWillTerminate(_ application: UIApplication) {}
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {return false}
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {return false}
    public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {}
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {}
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}
    public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {}
    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {}
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {}
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {}
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool { return false }
}

public struct NKAppConfigManager: NKAppConfigDelegate {
    
    private let configs: [NKAppConfigDelegate]
    
    public init(configs: [NKAppConfigDelegate]) {
        self.configs = configs
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) {
        self.configs.forEach { (appConfig) in
            appConfig.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationDidBecomeActive(application)
        }
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationWillResignActive(application)
        }
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationDidEnterBackground(application)
        }
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationWillEnterForeground(application)
        }
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationWillTerminate(application)
        }
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        for appConfig in self.configs {
            if appConfig.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) == true {
                return true
            }

        }
        return false
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        for appConfig in self.configs {
            if appConfig.application(app, open: url, options: options) == true {
                return true
            }
        }
        return false
    }
    
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        for appConfig in self.configs {
            if appConfig.application(application, continue: userActivity, restorationHandler: restorationHandler) == true {
                return true
            }
        }
        
        return false
    }
    
    public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        self.configs.forEach { (appConfig) in
            appConfig.application(application, didFailToContinueUserActivityWithType: userActivityType, error: error)
        }
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.configs.forEach { (appConfig) in
            appConfig.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.configs.forEach { (appConfig) in
            appConfig.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }
    
    public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        self.configs.forEach { (appConfig) in
            appConfig.application(application, didRegister: notificationSettings)
        }
    }
    
    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        self.configs.forEach { (appConfig) in
            appConfig.applicationDidReceiveMemoryWarning(application)
        }
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        self.configs.forEach { (appConfig) in
            appConfig.application(application, didReceiveRemoteNotification: userInfo)
        }
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.configs.forEach { (appConfig) in
            appConfig.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
}

