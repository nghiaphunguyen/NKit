//
//  UIAlertController+Extension.swift
//
//  Created by Nghia Nguyen on 12/7/15.
//

import UIKit

public typealias NKAlertControllerHandler = (index: Int) -> Void

public struct NKAlertAction {
    let title: String
    let style: UIAlertActionStyle
    
    public static func defaultStyle(title: String) -> NKAlertAction {
        return NKAlertAction(title: title, style: .Default)
    }
    
    public static func cancelStyle(title: String) -> NKAlertAction{
        return NKAlertAction(title: title, style: .Cancel)
    }
    
    public static func destructiveStyle(title: String) -> NKAlertAction {
        return NKAlertAction(title: title, style: .Destructive)
    }
}

public extension UIAlertController {
    
    public static func nk_showAlertController(fromController controller: UIViewController? = nk_topVisibleVisibleViewController, title: String?, message: String?, actions: [NKAlertAction], type: UIAlertControllerStyle = .Alert, handler: NKAlertControllerHandler, completion: (() -> Void)? = nil) -> UIAlertController {
        
        var alertActions = [UIAlertAction]()
        for (index, action) in actions.enumerate() {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: { (_) in
                handler(index: index)
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