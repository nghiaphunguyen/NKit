//
//  NKConstants.swift
//  NKit
//
//  Created by Nghia Nguyen on 2/13/16.
//  Copyright © 2016 knacker. All rights reserved.
//
import UIKit
import Foundation

public struct NKAppInfo {
    public static let Name = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
    public static let Build = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "") ?? 0
    public static let Version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0"
    public static let Identifier = (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String) ?? ""
}

public struct NKDeviceInfo {
    public static let Version = UIDevice.current.systemVersion
    public static let Model = UIDevice.current.model
}

public var nk_statusBarHeight: CGFloat = {
    return UIApplication.shared.statusBarFrame.size.height
}()

public var nk_rootViewController: UIViewController? {
    return UIApplication.shared.keyWindow?.rootViewController
}

public var nk_topRootViewController: UIViewController? {
    // Otherwise, we must get the root UIViewController and iterate through presented views
    return nk_rootViewController?.nk_topViewController
}

public var nk_topVisibleRootViewController: UIViewController? {
    return nk_rootViewController?.nk_topViewController?.nk_visibleViewController
}

public var nk_documentDirectory: String = {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}()

public var nk_libraryDirectory: String = {
    return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
}()
