//
//  SignupViewController.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    // MARK: Properties
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        observeFieldValues()
        attachKeyboardAction()
        observeKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Internal
    func observeKeyboard() {
        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func displayError(message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
    }
    
    @objc func keyboardWillAppear() {
        
        emailField.inputAccessoryView?.isHidden = false
        passwordField.inputAccessoryView?.isHidden = false
        usernameField.inputAccessoryView?.isHidden = false
    }
    
    @objc func keyboardWillDisappear() {
        //Do something here
        emailField.inputAccessoryView?.isHidden = true
        passwordField.inputAccessoryView?.isHidden = true
        usernameField.inputAccessoryView?.isHidden = true
        
    }
    
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    func observeFieldValues() {
        emailField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        errorLabel.text = nil
        errorLabel.isHidden = true
        if let email = emailField.text, let username = usernameField.text, let password = passwordField.text {
            createAccountButton.isEnabled = !email.isEmpty && !username.isEmpty && !password.isEmpty
        }
    }
    
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func attachKeyboardAction() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dissmissKeyboard))
        
        doneButton.tintColor = #colorLiteral(red: 0.8784313725, green: 0.368627451, blue: 0.3647058824, alpha: 1)
        toolbar.setItems([doneButton], animated: true)
        emailField.inputAccessoryView = toolbar
        passwordField.inputAccessoryView = toolbar
        usernameField.inputAccessoryView = toolbar
    }

    // MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountTapped(_ sender: UIButton) {
        if emailField.text != nil && passwordField.text != nil && usernameField.text != nil {
            if let email = emailField.text, let username = usernameField.text, let password = passwordField.text {
                spinner.startAnimating()
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                    if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                        let errorMessage = ErrorManager.shared.handleSignUpError(forCode: errorCode)
                        self?.spinner.stopAnimating()
                        self?.displayError(message: errorMessage)
                    } else {
                        if let user = result?.user {
                            let userData: [String: Any] = [
                                "provider" : user.providerID,
                            ]
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = username
                            changeRequest?.commitChanges { (error) in
                                DataService.shared.createUser(uid: user.uid, userData: userData)
                                self?.spinner.stopAnimating()
                                AuthService.shared.updateUID(uid: user.uid)
                                self?.dismiss(animated: true, completion: {
                                    AppDelegate.getAppDelegate().window?.rootViewController = self?.storyboard?.instantiateViewController(withIdentifier: "Todo List")
                                })
                            }
                        }
                    }                  
                }
            }
        }
    }

}
