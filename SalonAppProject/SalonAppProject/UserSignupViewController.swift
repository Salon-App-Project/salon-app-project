//
//  UserSignupViewController.swift
//  SalonAppProject
//
//  Created by Alex Rivas on 3/22/23.
//

import UIKit
import ParseSwift
class UserSignupViewController: UIViewController {

    @IBOutlet weak var Taxtext: UITextField!
    @IBOutlet weak var Passwordtext: UITextField!
    @IBOutlet weak var Phonetext: UITextField!
    @IBOutlet weak var Emailtext: UITextField!
    @IBOutlet weak var Nametext: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Signup_press(_ sender: Any) {
        guard let name = Nametext.text,
                let phone = Phonetext.text,
                let email = Emailtext.text,
                let password = Passwordtext.text,
                !name.isEmpty,
                !phone.isEmpty,
                !email.isEmpty,
                !password.isEmpty else {
            showMissingFieldsAlert()
            return
        }
        var newUser = AppUser()
        newUser.username = name
        newUser.email = email
        newUser.password = password

        newUser.signup { [weak self] result in

            switch result {
            case .success(let user):

                print("✅ Successfully signed up user \(user)")

                // Post a notification that the user has successfully signed up.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                // Failed sign up
                self?.showAlert(description: error.localizedDescription)
     }
        }

    }
    @IBAction func Biz_Signup_press(_ sender: Any) {
        guard let name = Nametext.text,
                let phone = Phonetext.text,
                let email = Emailtext.text,
                let password = Passwordtext.text,
                let taxId = Taxtext.text,
                !name.isEmpty,
                !phone.isEmpty,
                !email.isEmpty,
                !password.isEmpty,
                !taxId.isEmpty else {
            showMissingFieldsAlert()
            return
        }
        var newUser = AppUser()
        newUser.username = name
        newUser.email = email
        newUser.taxid = taxId

        newUser.signup { [weak self] result in

            switch result {
            case .success(let user):

                print("✅ Successfully signed up user \(user)")

                // Post a notification that the user has successfully signed up.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                // Failed sign up
                self?.showAlert(description: error.localizedDescription)
     }
        }

    }
    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to sign you up.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Unknown error")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
