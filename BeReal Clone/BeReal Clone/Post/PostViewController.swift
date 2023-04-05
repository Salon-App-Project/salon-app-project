//
//  AppDelegate.swift
//  BeReal Clone
//
//  Created by Ruth Bilaro 3/18/23.

import UIKit
import PhotosUI
import ParseSwift
import MapKit

typealias JSONDictionary = [String:Any]

class PostViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!

    private var pickedImage: UIImage?
    
    private var imageLocation = "No Location"
    let locManager = CLLocationManager()
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
    //loading indicator
    var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }

    @IBAction func onPickedImageTapped(_ sender: UIBarButtonItem) {
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

    @IBAction func onShareTapped(_ sender: Any) {
        // Dismiss Keyboard
        view.endEditing(true)

        self.present(alert, animated: false, completion: nil)

        // Unwrap optional pickedImage
        guard let image = pickedImage,
              // Create and compress image data (jpeg) from UIImage
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        // Create a Parse File by providing a name and passing in the image data
        let imageFile = ParseFile(name: "image.jpg", data: imageData)

        // Create Post object
        var post = Post()

        // Set properties
        post.imageFile = imageFile
        post.caption = captionTextField.text
        post.location = imageLocation

        // Set the user as the current user
        post.user = User.current

        // Save post (async)
        post.save { [weak self] result in

            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post Saved! \(post)")

                    // Get the current user
                    if var currentUser = User.current {

                        // Update the `lastPostedDate` property on the user with the current date.
                        currentUser.lastPostedDate = Date()

                        // Save updates to the user (async)
                        currentUser.save { [weak self] result in
                            switch result {
                            case .success(let user):
                                print("✅ User Saved! \(user)")

                                // Switch to the main thread for any UI updates
                                DispatchQueue.main.async {
                                    self?.alert.dismiss(animated: true, completion: nil)
                                    
                                    // Return to previous view controller
                                    self?.navigationController?.popViewController(animated: true)
                                }

                            case .failure(let error):
                                self?.showAlert(description: error.localizedDescription)
                            }
                        }
                    }


                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func onViewTapped(_ sender: Any) {
        // Dismiss keyboard
        view.endEditing(true)
    }
}

extension PostViewController: PHPickerViewControllerDelegate {

    // PHPickerViewController required delegate method.
    // Returns PHPicker result containing picked image data.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        // Dismiss the picker
        picker.dismiss(animated: true)
        
        imageLocation = "No Location"
        
        /*if let assetId = results.first?.assetIdentifier, let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).firstObject {
            if let loc = asset.location {
                self.getAddress(location: loc)
                
            }
            
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: nil) { image, info in
                if let image = image {
                    
                    DispatchQueue.main.async {
                        // Set image on preview image view
                        self.previewImageView.image = image

                        // Set image to use when saving post
                        self.pickedImage = image
                    }
                }
            }
        }*/

        // Make sure we have a non-nil item provider
        guard let provider = results.first?.itemProvider,
              // Make sure the provider can load a UIImage
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

            // Make sure we can cast the returned object to a UIImage
            guard let image = object as? UIImage else {
                self?.showAlert()
                return
            }

            // Check for and handle any errors
            if let error = error {
                self?.showAlert(description: error.localizedDescription)
                return
            } else {
                //Get location
                if let assetId = results[0].assetIdentifier {
                    let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                    
                    print(assetResult.firstObject?.location?.coordinate ?? "No Location")
                    
                    DispatchQueue.main.async {
                        if let asset = assetResult.firstObject, let location = asset.location {
                            
                            self?.getAddress(location: location)
                        }
                    }
                }
                
                // UI updates (like setting image on image view) should be done on main thread
                DispatchQueue.main.async {

                    // Set image on preview image view
                    self?.previewImageView.image = image

                    // Set image to use when saving post
                    self?.pickedImage = image
                }
            }
        }
    }
    
    func getAddress(location:CLLocation) {
        
        locManager.requestWhenInUseAuthorization()
        
        if authStatus == inUse || authStatus == always {
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                if let _ = error {
                    self.imageLocation = "No Location"
                } else {
                    guard let placeMark = placemarks?.first else { return }
                    
                    if let address = placeMark.subAdministrativeArea {
                        self.imageLocation = address
                        print(address)
                    }
                }
            }
        }
    }
}
