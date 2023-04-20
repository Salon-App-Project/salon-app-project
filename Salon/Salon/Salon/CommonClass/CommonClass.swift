
import UIKit
import Foundation
import SystemConfiguration
import Toast_Swift
import KRProgressHUD
import KRActivityIndicatorView

class CommonClass: NSObject {
    
    // MARK: - ImageView Border
    func borderForImageView(customImgVw: UIImageView) {
        customImgVw.layer.borderWidth = 2.0
        customImgVw.layer.masksToBounds = false
        customImgVw.layer.borderColor = UIColor.init(red:114.0/255.0, green:35.0/255.0, blue:35.0/255.0, alpha: 1.0).cgColor
        //customImgVw.layer.cornerRadius = customImgVw.frame.size.height/2
        customImgVw.clipsToBounds = true
    }
    
    // MARK: - Circular ImageView
    func setCircularImageVw(customImgVw: UIImageView) {
        customImgVw.layer.borderWidth=1.5
        customImgVw.layer.masksToBounds = false
        customImgVw.layer.borderColor = UIColor.white.cgColor
        customImgVw.layer.cornerRadius = customImgVw.frame.size.height/2
        customImgVw.clipsToBounds = true
    }
    
    // MARK: - Email Validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // MARK: - Add Padding TextField
    func addPaddingTextFld(setFld: UITextField) {
        let paddingView = UIView(frame: CGRect(x:0, y:0, width:15, height:setFld.frame.height))
        setFld.leftView = paddingView
        setFld.leftViewMode = UITextField.ViewMode.always
    }
    
    // MARK: - Add Radius TextField
    func cornerRadiusTextFld(setFld: UITextField) {
        setFld.layer.cornerRadius = 5.0
        setFld.layer.masksToBounds = true
    }
}
