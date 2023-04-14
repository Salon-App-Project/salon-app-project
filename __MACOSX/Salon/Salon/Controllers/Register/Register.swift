
import UIKit
import LGButton
import ParseSwift

class Register: UIViewController, UITextFieldDelegate {

    // MARK: - Outlet
    @IBOutlet weak var txtFldEmail: TextFieldEffects!
    @IBOutlet weak var txtFldName: TextFieldEffects!
    @IBOutlet weak var txtFldPassword: TextFieldEffects!
    @IBOutlet weak var txtFldMobileNumber: TextFieldEffects!
    @IBOutlet weak var btnSignUp: LGButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var selectImage: UIButton!
    
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    //from segue
    var userType = ""
    
    // MARK: - Button Actions
    @IBAction func btnSignUp(_ sender: LGButton)
    {
            if !CommonClass().isValidEmail(testStr: txtFldEmail.text!) {
                self.view.makeToast("Please enter Email")
            }
            else if txtFldMobileNumber.text == "" {
                self.view.makeToast("Please enter Mobile No")
            }
            else if txtFldName.text == "" {
                self.view.makeToast("Please enter Name")
            }
            else if txtFldPassword.text == "" {
                self.view.makeToast("Please enter Password")
            }
            else if pickedImage == nil {
                self.view.makeToast("Please select Image")
            }
            else {
                
                sender.isLoading = true
                
                let email = txtFldEmail.text!
                let phone = txtFldMobileNumber.text!
                let username = txtFldName.text!
                let password = txtFldPassword.text!
                
                guard let image = pickedImage,
                      // Create and compress image data (jpeg) from UIImage
                      let imageData = image.jpegData(compressionQuality: 0.1) else {
                    return
                }

                let imageFile = ParseFile(name: "1.jpg", data: imageData)

                var newUser = User()
                newUser.username = username
                newUser.email = email
                newUser.password = password
                newUser.phone = phone
                newUser.usertype = userType
                newUser.imageFile = imageFile

                newUser.signup { [weak self] result in

                    switch result {
                    case .success(let user):
                        //sender.isLoading = false
                        
                        print("✅ Successfully signed up user \(user)")

                        // Post a notification that the user has successfully signed up.
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
                            /*if user.usertype == "user" {
                                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                            } else {
                                NotificationCenter.default.post(name: Notification.Name("loginsalon"), object: nil)
                            }*/
                        
                    case .failure(let error):
                        sender.isLoading = false
                        // Failed sign up
                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            }
       
    }
    
    // MARK: - Add Image
    @IBAction func addProfilePhoto(_ sender: Any)
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        let saveActionButton = UIAlertAction(title: "Gallery", style: .default)
        { _ in
            self.openGallary()
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        let deleteActionButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            self.openCamera()
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    // MARK: - Open Gallery
    func openGallary()
    {
        imagePicker.sourceType = .savedPhotosAlbum;
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    // MARK: - Open Camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            self.present(self.imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - TextField Delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtFldEmail {
            textField.resignFirstResponder()
            txtFldName.becomeFirstResponder()
        }
        else if textField == txtFldName {
            textField.resignFirstResponder()
            txtFldPassword.becomeFirstResponder()
        }
        else if textField == txtFldPassword {
            textField.resignFirstResponder()
            txtFldMobileNumber.becomeFirstResponder()
        }
        else if textField == txtFldMobileNumber {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CommonClass().setCircularImageVw(customImgVw: profileImageView)
        animateImageView()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.layer.masksToBounds = true
        imagePicker.delegate = self
        clearTextFlds()
        
        if userType == "user" {
            self.title = "New User"
        } else {
            self.title = "New Salon"
        }
        
        if User.current != nil {
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
    }

    // MARK: - Clear TextFields
    func clearTextFlds() {
        txtFldName.text = ""
        txtFldEmail.text = ""
        txtFldPassword.text = ""
        txtFldMobileNumber.text = ""
        profileImageView.image = UIImage.init(named: "placeholder.png")
    }
    
    // MARK: - Animate
    func animateImageView() {
        let oldValue = profileImageView.frame.width/2
        let newButtonWidth: CGFloat = 90

        /* Do Animations */
        CATransaction.begin() //1
        CATransaction.setAnimationDuration(2.0) //2
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)) //3

        // View animations //4
        UIView.animate(withDuration: 1.0) {
            self.profileImageView.frame = CGRect(x: 0, y: 0, width: newButtonWidth, height: newButtonWidth)
            self.profileImageView.center = self.view.center
        }

        // Layer animations
        let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius)) //5
        cornerAnimation.fromValue = oldValue //6
        cornerAnimation.toValue = newButtonWidth/2 //7

        profileImageView.layer.cornerRadius = newButtonWidth/2 //8
        profileImageView.layer.add(cornerAnimation, forKey: #keyPath(CALayer.cornerRadius)) //9

        CATransaction.commit() //10
    }
}

// MARK: - Extension
extension Register: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @objc public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImageView.image = possibleImage
            
            pickedImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImageView.image = possibleImage
            
            pickedImage = possibleImage
        } else {
            return
        }
        dismiss(animated: true, completion: nil)
    }
}
