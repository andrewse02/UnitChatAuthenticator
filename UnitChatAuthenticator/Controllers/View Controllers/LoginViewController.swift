//
//  LoginViewController.swift
//  UnitChatAuthenticator
//
//  Created by Andrew Elliott on 4/6/22.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
              !username.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else { return }
        
        UsersNetworkManager.loginRequest(username: username, password: password) { result in
            switch result {
            case .success(let token):
                TokenController.shared.token = Token(value: token)
                UsersNetworkManager.fetchUser { result in
                    switch result {
                    case .success(let user):
                        UserController.shared.user = user
                        print(user)
                        
                        // Transition to second view
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print(error.errorDescription ?? error)
                            self.presentErrorToUser(localizedError: error)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.errorDescription ?? error)
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func updateViews() {
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder ?? "Username", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.25)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder ?? "Password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.25)])
    }
}
