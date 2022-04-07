//
//  UIViewController+ErrorAlert.swift
//  UnitChatAuthenticator
//
//  Created by Andrew Elliott on 4/6/22.
//

import UIKit

extension UIViewController {

    func presentErrorToUser(localizedError: LocalizedError) {
        
        let alertController = UIAlertController(title: "Error", message: localizedError.errorDescription, preferredStyle: .actionSheet)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
