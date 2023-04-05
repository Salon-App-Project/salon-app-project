//
//  AppDelegate.swift
//  BeReal Clone
//
//  Created by Ruth Bilaro 3/18/23.

import UIKit
import ParseSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func onLoginTapped(_ sender: Any) {

        // Make sure all fields are non-nil and non-empty.
        guard let username = usernameField.text,
              let password = passwordField.text,
              !username.isEmpty,
              !password.isEmpty else {

            showMissingFieldsAlert()
            return
        }

        User.login(username: username, password: password) { [weak self] result in

            switch result {
            case .success(let user):
                print("✅ Successfully logged in as user: \(user)")

                // Post a notification that the user has successfully logged in.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                // Show an alert for any errors
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to log you in.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

