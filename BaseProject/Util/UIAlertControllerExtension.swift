//
//  UIAlertControllerExtension.swift
//  BaseProject
//
//  Created by leedongseok on 17/08/2019.
//  Copyright © 2019 Good Effect. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    convenience init(
        title: String,
        message: String?,
        doneButtonTitle: String,
        completed: ((UIAlertAction)-> Void)? = nil
        ) {
        self.init(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: doneButtonTitle,
            style: .default,
            handler: completed
        )
        addAction(action)
    }
    
    static func presentError(
        in vc: UIViewController,
        title: String = "Error",
        message: String?,
        doneButtonTitle: String = "OK",
        completed: ((UIAlertAction)-> Void)? = nil
        ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            doneButtonTitle: doneButtonTitle,
            completed: completed
        )
        vc.present(alert, animated: true)
    }
}

