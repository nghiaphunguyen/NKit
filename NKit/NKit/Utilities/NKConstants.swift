//
//  NKConstants.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/13/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import Foundation

public struct NKAppInfo {
    public static let Name = (NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String) ?? ""
    public static let Build = (NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? Int) ?? 0
    public static let Version = (NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0"
    public static let Identifier = (NSBundle.mainBundle().infoDictionary?["CFBundleIdentifier"] as? String) ?? ""
}

public struct NKDeviceInfo {
    public static let Version = UIDevice.currentDevice().systemVersion
    public static let Model = UIDevice.currentDevice().model
}

public var nk_statusBarHeight: CGFloat = {
    return UIApplication.sharedApplication().statusBarFrame.size.height
}()

public var nk_rootViewController: UIViewController? {
    if let window = UIApplication.sharedApplication().delegate?.window {
        return window?.rootViewController
    }
    
    return nil
}

public var nk_documentDirectory: String = {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
}()

public var nk_libraryDirectory: String = {
    return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true).first!
}()