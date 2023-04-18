//
//  EditingUser.swift
//  Salon
//
//  Created by Alex Rivas on 4/16/23.
//  Copyright © 2023 Niraj Ajudiya. All rights reserved.
//

import Foundation
import LGButton
import ParseSwift
class EditingProfile:UIViewController,UITextFieldDelegate{
    @IBOutlet weak var txtFldEmail: TextFieldEffects!
    @IBOutlet weak var txtFldName: TextFieldEffects!
    @IBOutlet weak var txtFldPassword: TextFieldEffects!
    @IBOutlet weak var txtFldMobileNumber: TextFieldEffects!
    @IBOutlet weak var btnSave: LGButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var selectImage: UIButton!
    
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    //from segue
    var userType = ""
    @IBAction func onSaveButtonAction(_sender:LGButton){
        let email = txtFldEmail.text!
        let phone = txtFldMobileNumber.text!
        let username = txtFldName.text!
        let password = txtFldPassword.text!
        var currentUser = User()
        currentUser.email = email
        currentUser.phone = phone
        currentUser.username = username
        currentUser.password = password
        
        currentUser.save{ [weak self] result in
            switch result{
            case.success(let user):
                print("✅ Successfully saved user profile changes \(user)")
            case.failure(let saveerror):
                print(saveerror.localizedDescription)
                
            }
        }
        
        
        
    }
}
