//
//  UIAlertController+Extension.swift
//
//  Created by Nghia Nguyen on 12/7/15.
//

import UIKit

public typealias NKAlertControllerHandler = (index: Int) -> Void
public typealias NKAlertAction = (title: String, style: UIAlertActionStyle)

public extension UIAlertController {
    
    public static func nk_showAlertController(fromController controller: UIViewController, title: String?, message: String?, actions: [NKAlertAction], type: UIAlertControllerStyle = .Alert, handler: NKAlertControllerHandler, completion: (() -> Void)? = nil) -> UIAlertController {
        
        var alertActions = [UIAlertAction]()
        for (index, action) in actions.enumerate() {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: { (_) in
                handler(index: index)
            })
            alertActions.append(alertAction)
        }
        
        return self.nk_showAlertController(fromController: controller, title: title, message: message, actions: alertActions, type: type, completion: completion)
    }
    
    public static func nk_showAlertController(fromController controller: UIViewController,
        title: String?,
        message: String?,
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