
import UIKit
import LGButton
import PhotosUI
import ParseSwift

class AddStyle: UIViewController {

    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var tfStyleName: HoshiTextField!
    @IBOutlet var tfStylePrice: HoshiTextField!
    @IBOutlet var tfStyleDescription: HoshiTextField!
    
    var pickedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CommonClass().setCircularImageVw(customImgVw: imgVw)
        
        imgVw.layer.cornerRadius = imgVw.frame.size.height/2
        imgVw.layer.masksToBounds = true
    }
    
    @IBAction func bPhotoClicked(_ sender: Any) {
        openGallary()
    }
    
    @IBAction func bSaveClicked(_ sender: LGButton) {
        if tfStyleName.text == "" {
            self.view.makeToast("Please enter Style Name")
        }
        else if tfStylePrice.text == "" {
            self.view.makeToast("Please enter Style Price")
        }
        else if tfStyleDescription.text == "" {
            self.view.makeToast("Please enter Style Description")
        }
        else if pickedImage == nil {
            self.view.makeToast("Please select Style Image")
        }
        else {
            sender.isLoading = true
            
            let name = tfStyleName.text!
            let price = tfStylePrice.text!
            let desc = tfStyleDescription.text!
            
            guard let image = pickedImage,
                  // Create and compress image data (jpeg) from UIImage
                  let imageData = image.jpegData(compressionQuality: 0.1) else {
                return
            }

            let imageFile = ParseFile(name: "style.jpg", data: imageData)
            
            var style = Style()
            style.user = User.current!
            style.stylename = name
            style.styleprice = price
            style.styledescription = desc
            style.imageFile = imageFile
            
            style.save { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let style):
                        print("✅ Style Saved! \(style)")

                        sender.isLoading = false

                        // Post a notification that the user has successfully logged in.
                        DispatchQueue.main.async {
                            self?.openAlert(setMsg: "Style Added Successfully")
                        }


                    case .failure(let error):
                        self?.view.makeToast(error.localizedDescription)
                    }
                }
            }
        }
    }
    
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
    
    func openAlert(setMsg: String) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Success", message: setMsg, preferredStyle: .alert)
        let saveActionButton = UIAlertAction(title: "Ok", style: .default)
        { _ in
            self.navigationController?.popViewController(animated: true)
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
}

extension AddStyle: PHPickerViewControllerDelegate {

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
                    self?.imgVw.image = image

                    // Set image to use when saving post
                    self?.pickedImage = image
                }
            }
        }
    }
}
