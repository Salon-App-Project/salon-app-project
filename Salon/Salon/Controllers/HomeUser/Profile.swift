
import UIKit
import ParseSwift
import LGButton
import Alamofire
import AlamofireImage
import PhotosUI

class Profile: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var customVw: UIView!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldMobileNumber: UITextField!
    @IBOutlet weak var txtFldAddress1: UITextField!
    @IBOutlet weak var txtFldCity: UITextField!
    @IBOutlet weak var txtFldState: UITextField!
    @IBOutlet weak var txtFldPincode: UITextField!
    @IBOutlet weak var btnUpdate: LGButton!
    
    var imagePicker = UIImagePickerController()
    
    var pickedImage:UIImage?
    var changedImage = false
    
    var imageDataRequest: DataRequest?
    
    var salondetails: SalonDetails!
    var userdetails: UserDetails!
    
    //loading indicator
    var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
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
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    let photoLibrary = PHPhotoLibrary.shared()
                    var config = PHPickerConfiguration(photoLibrary: photoLibrary)
                    config.filter = .images
                    config.selectionLimit = 1
                    
                    let picker = PHPickerViewController(configuration: config)
                    picker.delegate = self
                    
                    self.present(picker, animated: true)
                }
            } else {
                print("No Access")
            }
        }
    }
    
    // MARK: - Open Camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            self.present(self.imagePicker, animated: true, completion: nil)
        } else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style:.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CommonClass().borderForImageView(customImgVw: profileImageView)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        
        
        
        CommonClass().addPaddingTextFld(setFld: txtFldName)
        CommonClass().addPaddingTextFld(setFld: txtFldEmail)
        CommonClass().addPaddingTextFld(setFld: txtFldMobileNumber)
        CommonClass().addPaddingTextFld(setFld: txtFldAddress1)
        CommonClass().addPaddingTextFld(setFld: txtFldCity)
        CommonClass().addPaddingTextFld(setFld: txtFldState)
        CommonClass().addPaddingTextFld(setFld: txtFldPincode)
        
        CommonClass().cornerRadiusTextFld(setFld: txtFldName)
        CommonClass().cornerRadiusTextFld(setFld: txtFldEmail)
        CommonClass().cornerRadiusTextFld(setFld: txtFldMobileNumber)
        CommonClass().cornerRadiusTextFld(setFld: txtFldAddress1)
        CommonClass().cornerRadiusTextFld(setFld: txtFldCity)
        CommonClass().cornerRadiusTextFld(setFld: txtFldState)
        CommonClass().cornerRadiusTextFld(setFld: txtFldPincode)
        
        alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .green
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            alert.view.heightAnchor.constraint(equalToConstant: 95),
            alert.view.widthAnchor.constraint(equalToConstant: 95),
            loadingIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor)
        ])
        
        setProfile()
    }
    
    
    
    func setProfile() {
        view.endEditing(true)

        self.present(alert, animated: false, completion: nil)
        
        if let user = User.current {
            txtFldName.text = user.username!
            txtFldEmail.text = user.email!
            
            do {
                
                let constraint: QueryConstraint = try "user" == user
                
                if user.usertype! == "salon" {
                    let query = SalonDetails.query(constraint)
                    
                    query.first { [weak self] result in
                        switch result {
                        case .success(let salondetails):
                            self?.salondetails = salondetails
                            self?.txtFldMobileNumber.text = salondetails.phone
                            self?.txtFldAddress1.text = salondetails.address
                            self?.txtFldCity.text = salondetails.city
                            self?.txtFldState.text = salondetails.state
                            self?.txtFldPincode.text = salondetails.zipcode
                            
                            if let imageFile = salondetails.imageFile,
                               let imageUrl = imageFile.url {
                                
                                // Use AlamofireImage helper to fetch remote image from URL
                                self?.imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                                    switch response.result {
                                    case .success(let image):
                                        self?.alert.dismiss(animated: true)
                                        // Set image view image with fetched image
                                        self?.profileImageView.image = image
                                        
                                        self?.pickedImage = image
                                    case .failure(let error):
                                        self?.alert.dismiss(animated: true)
                                        print("❌ Error fetching image: \(error.localizedDescription)")
                                        break
                                    }
                                }
                            }
                            
                        case .failure(let error):
                            self?.view.makeToast(error.localizedDescription)
                        }
                    }
                } else {
                    let query = UserDetails.query(constraint)
                    
                    query.first { [weak self] result in
                        switch result {
                        case .success(let userdetails):
                            self?.userdetails = userdetails
                            self?.txtFldMobileNumber.text = userdetails.phone
                            self?.txtFldAddress1.text = userdetails.address
                            self?.txtFldCity.text = userdetails.city
                            self?.txtFldState.text = userdetails.state
                            self?.txtFldPincode.text = userdetails.zipcode
                            
                            if let imageFile = userdetails.imageFile,
                               let imageUrl = imageFile.url {
                                
                                // Use AlamofireImage helper to fetch remote image from URL
                                self?.imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                                    switch response.result {
                                    case .success(let image):
                                        self?.alert.dismiss(animated: true)
                                        // Set image view image with fetched image
                                        self?.profileImageView.image = image
                                        
                                        self?.pickedImage = image
                                    case .failure(let error):
                                        self?.alert.dismiss(animated: true)
                                        print("❌ Error fetching image: \(error.localizedDescription)")
                                        break
                                    }
                                }
                            }
                            
                        case .failure(let error):
                            self?.view.makeToast(error.localizedDescription)
                        }
                    }
                }
                
            } catch {
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    @IBAction func bUpdateClicked(_ sender: LGButton) {
        if txtFldMobileNumber.text == "" {
            self.view.makeToast("Please enter Mobile No")
        }
        else if txtFldAddress1.text == "" {
            self.view.makeToast("Please enter Address")
        }
        else if txtFldCity.text == "" {
            self.view.makeToast("Please enter City")
        }
        else if txtFldState.text == "" {
            self.view.makeToast("Please enter State")
        }
        else if txtFldPincode.text == "" {
            self.view.makeToast("Please enter Pincode")
        }
        else if pickedImage == nil {
            self.view.makeToast("Please select Image")
        }
        else {
            
            sender.isLoading = true
            
            let phone = txtFldMobileNumber.text!
            let address = txtFldAddress1.text!
            let city = txtFldCity.text!
            let state = txtFldState.text!
            let pincode = txtFldPincode .text!
            
            
            guard let image = pickedImage,
                  // Create and compress image data (jpeg) from UIImage
                  let imageData = image.jpegData(compressionQuality: 0.1) else {
                return
            }

            let imageFile = ParseFile(name: "salon.jpg", data: imageData)

            if User.current!.usertype == "salon" {
                salondetails.phone = phone
                salondetails.address = address
                salondetails.city = city
                salondetails.state = state
                salondetails.zipcode = pincode
                
                if changedImage {
                    salondetails.imageFile = imageFile
                }
                
                salondetails.save { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let details):
                            print("✅ Details Saved! \(details)")

                            self?.view.makeToast("Profile Updated Successfully.")
                            
                            sender.isLoading = false
                            self?.performSegue(withIdentifier: "backSalonHome", sender: nil)
                        case .failure(let error):
                            self?.view.makeToast(error.localizedDescription)
                        }
                    }
                }
            } else {
                userdetails.phone = phone
                userdetails.address = address
                userdetails.city = city
                userdetails.state = state
                userdetails.zipcode = pincode
                
                if changedImage {
                    userdetails.imageFile = imageFile
                }
                
                userdetails.save { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let details):
                            print("✅ Details Saved! \(details)")

                            self?.view.makeToast("Profile Updated Successfully.")
                            
                            sender.isLoading = false
                            self?.performSegue(withIdentifier: "backHome", sender: nil)

                        case .failure(let error):
                            self?.view.makeToast(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        imageDataRequest?.cancel()
    }
}

// MARK: - Extension
extension Profile: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let possibleImage = info[.editedImage] as? UIImage {
             profileImageView.image = possibleImage
             
             pickedImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
             profileImageView.image = possibleImage
             
             pickedImage = possibleImage
         } else {
             return
         }
         dismiss(animated: true, completion: nil)
     }
}

extension Profile: PHPickerViewControllerDelegate {

    // PHPickerViewController required delegate method.
    // Returns PHPicker result containing picked image data.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        // Dismiss the picker
        picker.dismiss(animated: true)

        // Make sure we have a non-nil item provider
        guard let provider = results.first?.itemProvider,
              // Make sure the provider can load a UIImage
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

            // Make sure we can cast the returned object to a UIImage
            guard let image = object as? UIImage else {
                print("error")
                return
            }

            // Check for and handle any errors
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                // UI updates (like setting image on image view) should be done on main thread
                DispatchQueue.main.async {

                    // Set image on preview image view
                    self?.profileImageView.image = image

                    // Set image to use when saving post
                    self?.pickedImage = image
                    
                    self?.changedImage = true
                }
            }
        }
    }
}
