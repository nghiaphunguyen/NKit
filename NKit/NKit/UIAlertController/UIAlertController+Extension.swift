//
//  UIAlertController+Extension.swift
//
//  Created by Nghia Nguyen on 12/7/15.
//

import UIKit

public typealias NKAlertControllerHandler = (index: Int) -> Void

public enum NKAlertAction {
    case Default(String)
    case Cancel(String)
    case Destructive(String)
    
    public var title: String {
        switch self {
        case .Default(let title):
            return title
        case .Cancel(let title):
            return title
        case Destructive(let title):
            return title
        }
    }
    
    public var style: UIAlertActionStyle {
        switch self {
        case .Default(_):
            return .Default
        case .Cancel(_):
            return .Cancel
        case Destructive(_):
            return .Destructive
        }
    }
}

public extension UIAlertController {
    
    public static func nk_showAlertController(fromController controller: UIViewController? = nk_topVisibleVisibleViewController, title: String?, message: String?, actions: [NKAlertAction], type: UIAlertControllerStyle = .Alert, handler: NKAlertControllerHandler? = nil, completion: (() -> Void)? = nil) -> UIAlertController {
        
        var alertActions = [UIAlertAction]()
        for (index, action) in actions.enumerate() {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: { (_) in
                handler?(index: index)
            })
            alertActions.append(alertAction)
        }
        
        return self.nk_showAlertController(fromController: controller, title: title, message: message, actions: alertActions, type: type, completion: completion)
    }
    
    public static func nk_showAlertController(fromController controller: UIViewController? = nk_topVisibleVisibleViewController,
        title: String?,
        message: String?,
        actions: [UIAlertAction],
        type: UIAlertControllerStyle = .Alert,
        completion: (() -> Void)? = nil) -> UIAlertController {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: type)
            for action in actions {
                alertController.addAction(action)
            }
            
            controller?.presentViewController(alertController, animated: true, completion: completion)
            return alertController
    }
}