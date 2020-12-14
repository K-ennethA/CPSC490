//
//  RegisterViewController.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/6/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    let alert = UIAlertController(title: "Error", message: "There was an error. Possible Issue: Passwords must be at least 6 characters long", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                    self.present(alert, animated: true)
                } else {
                    //Navigate to the ChatViewController
                    User.sharedInstance.email =  email
                    self.performSegue(withIdentifier: "registeredSegue", sender: self)

                }
            }
        }
    }
    
}
