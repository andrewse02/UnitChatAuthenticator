//
//  LoginViewController.swift
//  UnitChatAuthenticator
//
//  Created by Andrew Elliott on 4/6/22.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        checkLoggedIn()
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
                let fetchRequest = NSFetchRequest<Token>(entityName: "Token")
                if let results = try? CoreDataStack.context.fetch(fetchRequest),
                   let result = results.first {
                    CoreDataStack.context.delete(result)
                    CoreDataStack.saveContext()
                }
                
                TokenController.shared.token = Token(value: token)
                self.fetchUser()
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
    
    func checkLoggedIn() {
        fetchToken()
        
        if TokenController.shared.token != nil {
            fetchUser()
        }
    }
    
    func fetchToken() {
        let fetchRequest = NSFetchRequest<Token>(entityName: "Token")
        if let token = try? CoreDataStack.context.fetch(fetchRequest).first {
            TokenController.shared.token = token
        }
    }
    
    func fetchUser() {
        UsersNetworkManager.fetchUser { result in
            switch result {
            case .success(let user):
                UserController.shared.user = user
                DispatchQueue.main.async {
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController")
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.errorDescription ?? error)
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
}
