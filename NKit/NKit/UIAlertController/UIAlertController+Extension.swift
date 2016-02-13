//
//  UIAlertController+Extension.swift
//
//  Created by Nghia Nguyen on 12/7/15.
//

import Foundation

public typealias NKAlertControllerHandler = (index: Int) -> Void

public extension UIAlertController {
    
    public static func nk_showAlertController(fromController controller: UIViewController,
        title: String,
        message: String,
        cancelTitle: String? = nil,
        cancelHandler: (() -> Void)? = nil,
        destructiveTitle: String? = nil,
        destructiveHandler: (() -> Void)? = nil,
        otherTitles: [String] = [String](),
        otherHandler: NKAlertControllerHandler? = nil,
        type: UIAlertControllerStyle = .Alert,
        completion: (() -> Void)? = nil) -> UIAlertController {
            var actions = [UIAlertAction]()
            
            if destructiveTitle != nil {
                let destructiveAction = UIAlertAction(title: destructiveTitle, style: .Destructive) { (alertAction) -> Void in
                    destructiveHandler?()
                }
                actions.append(destructiveAction)
            }
            
            for (index, otherTitle) in otherTitles.enumerate() {
                let action = UIAlertAction(title: otherTitle, style: .Default, handler: { (alertAction) -> Void in
                    otherHandler?(index: index)
                })
                
                actions.append(action)
            }
            
            if cancelTitle != nil {
                let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
                    cancelHandler?()
                }
                
                if type == .Alert {
                    actions.insert(cancelAction, atIndex: 0)
                } else {
                    actions.append(cancelAction)
                }
            }
            
            return nk_showAlertController(fromController: controller, title: title, message: message, actions: actions, type: type, completion: completion)
    }
    
    public static func nk_showAlertController(fromController controller: UIViewController,
        title: String,
        message: String,
        actions: [UIAlertAction],
        type: UIAlertControllerStyle = .Alert,
        completion: (() -> Void)? = nil) -> UIAlertController {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: type)
            for action in actions {
                alertController.addAction(action)
            }
            
            controller.presentViewController(alertController, animated: true, completion: completion)
            return alertController
    }
    
    
}