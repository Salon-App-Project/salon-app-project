
import UIKit
import LGButton
import ParseSwift

class Login: UIViewController, UITextFieldDelegate {

    // MARK: - Outlet
    @IBOutlet weak var txtFldUsername: TextFieldEffects!
    @IBOutlet weak var txtFldPassword: TextFieldEffects!
    @IBOutlet weak var btnLogin: LGButton!
    @IBOutlet weak var btnSignUp: LGButton!
    @IBOutlet var btnRegisterSalon: LGButton!
    
    //for segue
    var userType = ""
    
    // MARK: - Action
    @IBAction func loginNow(_ sender: LGButton) {
        
            if self.txtFldUsername.text == "" {
                self.view.makeToast("Please Enter Email")
            }
            else if self.txtFldPassword.text == "" {
                self.view.makeToast("Please Enter Password")
            }
            else {
                sender.isLoading = true
                
                let username = txtFldUsername.text!
                let password = txtFldPassword.text!
                
                User.login(username: username, password: password) { [weak self] result in

                    switch result {
                    case .success(let user):
                        sender.isLoading = false
                        
                        print("✅ Successfully logged in as user: \(user)")

                        // Post a notification that the user has successfully logged in.
                        DispatchQueue.main.async {
                            if user.usertype == "user" {
                                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                            } else {
                                NotificationCenter.default.post(name: Notification.Name("loginsalon"), object: nil)
                            }
                        }

                    case .failure(let error):
                        sender.isLoading = false
                        // Show an alert for any errors
                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            }
        
    }
    
    @IBAction func RegisterNow(_ sender: LGButton) {
        userType = "user"
        performSegue(withIdentifier: "register", sender: nil)
    }
    
    @IBAction func registerSalon(_ sender: LGButton) {
        print("hi")
        userType = "salon"
        performSegue(withIdentifier: "register", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register" {
            let vc = segue.destination as! Register
            vc.userType = userType
        }
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtFldUsername.text = ""
        txtFldPassword.text = ""
    }
    
    // MARK: - TextField Delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtFldUsername {
            textField.resignFirstResponder()
            txtFldPassword.becomeFirstResponder()
        }
        else if textField == txtFldPassword {
            textField.resignFirstResponder()
        }
        return true
    }
}
