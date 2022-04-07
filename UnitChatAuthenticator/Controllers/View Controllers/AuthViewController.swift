//
//  AuthViewController.swift
//  UnitChatAuthenticator
//
//  Created by Andrew Elliott on 4/6/22.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Helper Functions
    
    func updateViews() {
        guard let user = UserController.shared.user else { return }
        
        usernameLabel.text = "Hello, \(user.username)"
        codeTextField.attributedPlaceholder = NSAttributedString(string: codeTextField.placeholder ?? "Enter Code", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.25)])
        
        codeTextField.isEnabled = false
        codeTextField.isHidden = true
        
        // UIKit does not like SVGs :angry:
        if let url = URL(string: user.profilePic.replacingOccurrences(of: ".svg", with: ".png")) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.profileImage.layer.cornerRadius = (self?.profileImage.frame.size.height ?? 48) / 2
                        self?.profileImage.clipsToBounds = true
                        self?.profileImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
