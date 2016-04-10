//
//  NKScreenSize.swift
//
//  Created by Nghia Nguyen on 12/3/15.
//

import UIKit

public enum NKScreenType {
    case IP4S
    case IP5
    case IP6
    case IP6Plus
}

public struct NKScreenSize {
    public static let IP4S = CGSizeMake(320, 480)
    public static let IP5 = CGSizeMake(320, 568)
    public static let IP6 = CGSizeMake(375, 667)
    public static let IP6Plus = CGSizeMake(414, 736)
    public static let Current = UIScreen.mainScreen().bounds.size
    
    public static let CurrentType : NKScreenType = {
        if Current == IP5 {
            return .IP5
        }
        
        if Current == IP6 {
            return .IP6
        }
        
        if Current == IP6Plus {
            return .IP6Plus
        }
        
        return .IP4S
    }()
    
    public static var Layout = NKScreenSize.IP6 {
        didSet {
            LayoutRatio = Current.height / NKScreenSize.Layout.height
            
            let currentRatio = NKScreenSize.Current.height / NKScreenSize.Current.width
            let layoutRatio = NKScreenSize.Layout.height / NKScreenSize.Layout.width
            Ratio = currentRatio / layoutRatio
        }
    }
    
    
    private static var LayoutRatio = NKScreenSize.Current.height / NKScreenSize.Layout.height
    private static var Ratio: CGFloat = {
        let currentRatio = NKScreenSize.Current.height / NKScreenSize.Current.width
        let layoutRatio = NKScreenSize.Layout.height / NKScreenSize.Layout.width
        
        return currentRatio / layoutRatio
    }()
}

/**
 Standardize layout config depend on screen resolution.
 - Parameter num: layout config.
 - Returns: Config after standardize.
 */
public func ST(num: Any, powValue: CGFloat = 1) -> CGFloat {
    return NKScreenSize.LayoutRatio * (num as? CGFloat ?? 0) * pow(NKScreenSize.Ratio, powValue)
}
