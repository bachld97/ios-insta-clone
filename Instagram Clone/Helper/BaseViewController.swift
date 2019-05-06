//
//  BaseViewController.swift
//  Instagram Clone
//
//  Created by CPU12071 on 5/6/19.
//  Copyright © 2019 Le Duy Bach. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func showSimpleAlert(title: String, message: String, cancelTitle: String) {
        let actions = [
            UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        ]
        showAlert(title: title, message: message, actions: actions)
    }
    
    func showAlert(
        title: String, message: String, actions: [UIAlertAction] = [],
        preferredStyle: UIAlertController.Style = .alert
        ) {
        let localizedTitle = NSLocalizedString(title, comment: "")
        let localizedMessage = NSLocalizedString(message, comment: "")
        let alertController = UIAlertController(
            title: localizedTitle, message: localizedMessage,
            preferredStyle: preferredStyle
        )
        
        actions.forEach { alertController.addAction($0) }
        self.present(alertController, animated: true, completion: nil)
    }
}
