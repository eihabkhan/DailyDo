//
//  LoginViewController.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    private var appDelegate = AppDelegate.getAppDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        observeFieldValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true

    }
    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if emailField.text != nil && passwordField.text != nil {
            if let email = emailField.text, let password = passwordField.text {
                spinner.startAnimating()
                Auth.auth().signIn(withEmail: email, password: password) {[weak self] (result, error) in
                    if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                        let errorMessage = ErrorManager.shared.handleLoginError(forCode: errorCode)
                        self?.spinner.stopAnimating()
                        self?.displayError(message: errorMessage)
                    } else {
                        if result?.user != nil {
                            self?.spinner.stopAnimating()
                            let mainVC = self?.storyboard?.instantiateViewController(withIdentifier: "Todo List") as? UITableViewController
                            mainVC?.tableView.reloadData()
                            AuthService.shared.updateUID(uid: result!.user.uid)
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        if let signupVC = storyboard?.instantiateViewController(withIdentifier: "Signup") as? SignupViewController {
            present(signupVC, animated: true)
        }
        
    }

    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    func displayError(message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
    }
    
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func observeFieldValues() {
        emailField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        errorLabel.text = nil
        errorLabel.isHidden = true
        if let email = emailField.text, let password = passwordField.text {
            loginButton.isEnabled = !email.isEmpty && !password.isEmpty
        }
    }
    
    
}
